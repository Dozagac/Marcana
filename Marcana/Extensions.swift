//
//  Extensions.swift
//  Marcana
//
//  Created by Deniz Ozagac on 29/11/2022.
//

import Foundation
import SwiftUI

// Protocol Extension
extension Collection {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}

extension Color {
    static let background = Color("Background")
    static let icon = Color("Icon")
    static let text = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
}
