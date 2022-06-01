//
//  MeditationApp.swift
//  MeditationApp
//
//  Created by Elton Jhony on 30.05.22.
//

import SwiftUI

@main
struct MeditationApp: App {
    @StateObject var audioManager = StreammingAudioManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(audioManager)
        }
    }
}
