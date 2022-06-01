//
//  Extensions.swift
//  MeditationApp
//
//  Created by Elton Jhony on 30.05.22.
//

import Foundation
import SwiftUI

extension DateComponentsFormatter {
    
    static let abbreviated: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        
        return formatter
    }()
    
    static let positional: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        return formatter
    }()
    
}

// MARK: - Style

struct StyleModifier<T: ViewModifier> {
    let modifier: T
}

extension View {
    func style<T: ViewModifier>(_ viewModifier: StyleModifier<T>) -> some View {
        modifier(viewModifier.modifier)
    }
}

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
