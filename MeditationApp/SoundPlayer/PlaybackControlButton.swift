//
//  PlaybackControlButton.swift
//  MeditationApp
//
//  Created by Elton Jhony on 31.05.22.
//

import Foundation
import SwiftUI

struct PlaybackControlButton: View {
    var systemName = "play"
    var fontSize: CGFloat = 24
    var color = Color.white
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: systemName)
                .font(.system(size: fontSize))
                .foregroundColor(color)
        }
    }
}
