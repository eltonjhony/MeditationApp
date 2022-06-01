//
//  Playlist.swift
//  MeditationApp
//
//  Created by Elton Jhony on 01.06.22.
//

import Foundation

struct Playlist {
    let name: String
    let thumb: String
    let duration: String
    let desc: String
    let tracks: [SoundTrack]
    
    static func fakePlaylist() -> Playlist {
        .init(
            name: "Daily Meditation Mix",
            thumb: "playlist",
            duration: "18m 10s",
            desc: "Clear your mind slumber into nothingness. Allocate only a few moments for a quick breather.",
            tracks: SoundTrack.fakeTracks()
        )
    }
}
