//
//  ContentView.swift
//  MeditationApp
//
//  Created by Elton Jhony on 30.05.22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var audioManager: StreammingAudioManager
    
    private let fakePlaylist = Playlist.fakePlaylist()
    
    var body: some View {
        content
            .style(.playerWidget())
            .background(Color.black)
    }
    
    private var content: some View {
        ScrollView {
            VStack {
                Image(fakePlaylist.thumb)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3, alignment: .center)
                    .clipped()
                trackContent
                Spacer()
            }
        }
    }
    
    private var trackContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("MUSIC")
                .fontWeight(.regular)
                .font(.footnote)
                .foregroundColor(.gray)
            Text(fakePlaylist.duration)
                .fontWeight(.regular)
                .font(.footnote)
                .foregroundColor(.gray)
            
            Text("\(fakePlaylist.tracks.count) songs")
                .fontWeight(.regular)
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.top, 4)
            
            Text(fakePlaylist.name)
                .fontWeight(.bold)
                .font(.title)
                .foregroundColor(.white)
                .padding(.top, 4)
            
            Button("▶ Play") {
                audioManager.showPlayer.toggle()
            }
            .frame(idealWidth: .infinity, maxWidth: .infinity, minHeight: 40, maxHeight: 40, alignment: .center)
            .foregroundColor(Color.black)
            .background(Color.white)
            .cornerRadius(16)
            .padding(.vertical, 16)
            .sheet(isPresented: $audioManager.showPlayer) {
                PlayerView(tracks: fakePlaylist.tracks)
            }
            
            Text(fakePlaylist.desc)
                .fontWeight(.regular)
                .font(.footnote)
                .foregroundColor(.white)
            
        }
        .padding()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(StreammingAudioManager())
    }
}
