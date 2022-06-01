//
//  SoundTrack.swift
//  MeditationApp
//
//  Created by Elton Jhony on 31.05.22.
//

import Foundation

struct SoundTrack {
    let trackUrl: String
    let thumb: String
    let name: String
    let duration: String
    
    static func fakeTracks() -> [SoundTrack] {
        [
            fakeTrack(),
            fakeTrack(thumb: "meditation1", trackUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3", name: "SoundHelix Song 2"),
            fakeTrack(thumb: "meditation2", trackUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3", name: "SoundHelix Song 3")
        ]
    }
    
    static func fakeTrack(thumb: String = "meditation", trackUrl: String = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", name: String = "SoundHelix Song 1") -> SoundTrack {
        .init(
            trackUrl: trackUrl,
            thumb: thumb,
            name: name,
            duration: "6m 12s"
        )
    }
}
