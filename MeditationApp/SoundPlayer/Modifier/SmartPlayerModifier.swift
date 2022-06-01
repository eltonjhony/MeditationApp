//
//  SmartPlayerModifier.swift
//  MeditationApp
//
//  Created by Elton Jhony on 31.05.22.
//

import Foundation
import SwiftUI

struct SmartPlayerModifier: ViewModifier {
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomLeading) {
            content
            SmartPlaybackView()
                .padding(.horizontal, 16)
                .offset(x: currentPosition.width, y: currentPosition.height)
                .gesture(DragGesture()
                    .onChanged(onDragChanged(_:))
                    .onEnded(onDragEnded(_:))
                )
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    private func onDragChanged(_ value: DragGesture.Value) {
        currentPosition = CGSize(
            width: value.translation.width + newPosition.width,
            height: value.translation.height + newPosition.height
        )
    }
    
    private func onDragEnded(_ value: DragGesture.Value) {
        withAnimation {
            onDragChanged(value)
            newPosition = currentPosition
        }
    }
}

extension StyleModifier {
    
    static func playerWidget() -> StyleModifier<T> where T == SmartPlayerModifier {
        .init(modifier: T())
    }
    
}
