//
//  StreammingAudioManager.swift
//  MeditationApp
//
//  Created by Elton Jhony on 30.05.22.
//

import Foundation
import AVKit

final class StreammingAudioManager: NSObject, ObservableObject {
    
    private var player: AVPlayer?
    private var asset: AVAsset?
    private var playerItem: AVPlayerItem?

    // Key-value observing context
    private var playerItemContext = 0

    private let requiredAssetKeys = [
        "playable",
        "hasProtectedContent"
    ]
    
    @Published var showPlayer: Bool = false
    
    @Published private(set) var isPlaying: Bool = false {
        didSet {
            if isPlaying {
                player?.play()
            } else {
                player?.pause()
            }
        }
    }
    @Published private(set) var isReadyToPlay: Bool = false
    @Published private(set) var isLooping = false
    
    @Published var progressTime: Double = 0.0
    
    private var tracks: [SoundTrack] = []
    private var currentTrackIndex: Int = 0
    private var autoPlayEnabled = false
    
    private var hasNextTrack: Bool {
        tracks.count - 1 != currentTrackIndex
    }
    
    private var hasPreviousTrack: Bool {
        currentTrackIndex > 0
    }
    
    var currentTrack: SoundTrack? {
        tracks[safe: currentTrackIndex]
    }
    
    var currentTime: Double {
        player?.currentTime().seconds ?? 0
    }
    
    var duration: Double {
        player?.currentItem?.duration.seconds ?? 0
    }
    
    func prepareToPlay(with tracks: [SoundTrack], autoPlayEnabled: Bool) {
        progressTime = currentTime
        if isReadyToPlay { return }
        self.tracks = tracks
        self.autoPlayEnabled = autoPlayEnabled
        prepareToPlay()
    }
    
    func playPause() {
        guard let player = player, isReadyToPlay else { return }
        if player.isPlaying {
            isPlaying = false
        } else {
            isPlaying = true
        }
    }
    
    func updateTrackProgress() {
        if isReadyToPlay {
            progressTime = currentTime
        }
    }
    
    func reset() {
        isPlaying = false
        isReadyToPlay = false
        currentTrackIndex = 0
        seekTime(to: .zero)
    }
    
    func goForward(seconds: Double = 10.0) {
        guard let player = player, isReadyToPlay else { return }
        guard let duration = player.currentItem?.duration else { return }
        
        let newTime = CMTimeGetSeconds(player.currentTime()) + seconds
        
        if newTime < CMTimeGetSeconds(duration) {
            seekTime(to: newTime)
        }
    }
    
    func goBackForward(seconds: Double = 10.0) {
        guard let player = player, isReadyToPlay else { return }
        var newTime = CMTimeGetSeconds(player.currentTime()) - seconds
        
        if newTime < 0 {
            newTime = 0
        }
        seekTime(to: newTime)
    }
    
    func toggleLoop() {
        isLooping = !isLooping
    }
    
    func previousTrack() {
        if hasPreviousTrack {
            seekTime(to: .zero)
            currentTrackIndex -= 1
            prepareToPlay()
        }
    }
    
    func nextTrack() {
        if hasNextTrack {
            seekTime(to: .zero)
            currentTrackIndex += 1
            prepareToPlay()
        }
    }
    
    func seekTime(to value: Double) {
        player?.seek(to: value.toTime)
        progressTime = value
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }

            // Switch over status value
            switch status {
            case .readyToPlay:
                if autoPlayEnabled {
                    isReadyToPlay = true
                    isPlaying = true
                }
            case .failed, .unknown:
                print("Something went wrong. Player not able to play")
                isReadyToPlay = false
            @unknown default:
                print("Something went wrong. Player not able to play")
                isReadyToPlay = false
            }
        }
        
    }
    
    private func prepareToPlay() {
        isReadyToPlay = false
        guard let track = currentTrack, let url = URL(string: track.trackUrl) else {
            print("Resource not found for index: \(currentTrackIndex)")
            return
        }
        
        enablePlayerOnSilentMode()
        asset = AVURLAsset(url: url)
        playerItem = AVPlayerItem(asset: asset!)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
        
        player = AVPlayer(playerItem: playerItem)
        
        addLoopingObserver()
    }
    
    private func enablePlayerOnSilentMode() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    private func addLoopingObserver() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { [weak self] notification in
            self?.playerDidEnd()
        }
    }
    
    private func playerDidEnd() {
        seekTime(to: .zero)
        isPlaying = false
        if hasNextTrack {
            nextTrack()
        } else if isLooping {
            isPlaying = true
        }
    }
    
}

private extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

private extension Float64 {
    var toTime: CMTime {
        CMTimeMakeWithSeconds(self, preferredTimescale: 1000)
    }
}
