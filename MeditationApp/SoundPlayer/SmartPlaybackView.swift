//
//  SmartPlaybackView.swift
//  MeditationApp
//
//  Created by Elton Jhony on 31.05.22.
//

import Foundation
import SwiftUI

struct SmartPlaybackView: View {
    @EnvironmentObject var audioManager: StreammingAudioManager
    
    @ViewBuilder
    var body: some View {
        if let currentTrack = audioManager.currentTrack, audioManager.isReadyToPlay {
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Image(currentTrack.thumb)
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .leading)
                        .cornerRadius(4)
                        .padding(.leading, 16)
                        .padding(.trailing, 8)
                        .padding(.vertical, 8)
                    Text(currentTrack.name)
                        .fontWeight(.bold)
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(.top, 4)
                    
                    Spacer()
                    PlaybackControlButton(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill", fontSize: 44, color: .black) {
                        audioManager.playPause()
                    }.padding(.trailing, 4)
                }
            }
            .background(Color.white)
            .cornerRadius(16)
            .padding(.bottom, 24)
            .onTapGesture {
                audioManager.showPlayer.toggle()
            }
        }
    }
    
}
