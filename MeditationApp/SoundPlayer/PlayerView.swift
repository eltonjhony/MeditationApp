//
//  PlayerView.swift
//  MeditationApp
//
//  Created by Elton Jhony on 30.05.22.
//

import Foundation
import SwiftUI
import AVFAudio

struct PlayerView: View {
    @EnvironmentObject var audioManager: StreammingAudioManager
    @Environment(\.dismiss) var dismiss
    
    let tracks: [SoundTrack]
    var autoPlayEnabled = true
    
    @State private var isDragging: Bool = false
    
    let timer = Timer
        .publish(every: 0.5, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            if let currentSoundTrack = audioManager.currentTrack {
                content(with: currentSoundTrack)
            } else {
                ProgressView()
                    .foregroundColor(.white)
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .onAppear {
            audioManager.prepareToPlay(with: tracks, autoPlayEnabled: autoPlayEnabled)
        }
        .onReceive(timer) { _ in
            if !isDragging {
                audioManager.updateTrackProgress()
            }
        }
    }
    
    private func content(with currentSoundTrack: SoundTrack) -> some View {
        ZStack {
            Image(currentSoundTrack.thumb)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width)
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    actionButton(image: "dismiss") {
                        dismiss()
                    }
                    Spacer()
                    actionButton(image: "close") {
                        audioManager.reset()
                        dismiss()
                    }
                }
                
                Text(currentSoundTrack.name)
                    .fontWeight(.bold)
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Spacer()
                if audioManager.isReadyToPlay {
                    playback
                } else {
                    ProgressView()
                        .foregroundColor(.white)
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            .padding(16)
        }
    }
    
    private var playback: some View {
        VStack {
            sliderDuration
            actionButtons
        }
    }
    
    private var sliderDuration: some View {
        VStack(spacing: 6) {
            withAnimation {
                Slider(value: $audioManager.progressTime, in: 0...audioManager.duration) { editing in
                    
                    isDragging = editing
                    if !editing {
                        audioManager.seekTime(to: audioManager.progressTime)
                    }
                    
                }
                .accentColor(.white)
            }
            
            HStack {
                Text(progressText)
                Spacer()
                Text(remainingDuration)
            }
            .font(.caption)
            .foregroundColor(.white)
        }
    }
    
    private var actionButtons: some View {
        HStack {
            let color: Color = audioManager.isLooping ? .teal : .white
            PlaybackControlButton(systemName: "backward.fill", color: color) {
                audioManager.previousTrack()
            }
            
            Spacer()
            
            PlaybackControlButton(systemName: "gobackward.10") {
                audioManager.goBackForward()
            }
            
            Spacer()
            
            PlaybackControlButton(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill", fontSize: 56) {
                audioManager.playPause()
            }
            
            Spacer()
            
            PlaybackControlButton(systemName: "goforward.10") {
                audioManager.goForward()
            }
            
            Spacer()
            
            PlaybackControlButton(systemName: "forward.fill") {
                audioManager.nextTrack()
            }
        }
    }
    
    private func actionButton(image: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(image)
                .foregroundColor(.white)
        }
    }
    
}

extension PlayerView {
    
    private var progressText: String {
        DateComponentsFormatter.positional.string(from: audioManager.currentTime) ?? "0:00"
    }
    
    private var remainingDuration: String {
        DateComponentsFormatter.positional.string(from: audioManager.duration - audioManager.currentTime) ?? "0:00"
    }
    
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(tracks: SoundTrack.fakeTracks(), autoPlayEnabled: false)
            .environmentObject(StreammingAudioManager())
    }
}
