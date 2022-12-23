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
    static let foreground = Color("Foreground")
    static let icon = Color("Icon")
    static let iconUnselected = Color("IconUnselected")
    static let text = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
}


struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
