//
//  Modifiers.swift
//  Marcana
//
//  Created by Deniz Ozagac on 29/11/2022.
//

import Foundation
import SwiftUI

struct MyTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.text)
    }
}
