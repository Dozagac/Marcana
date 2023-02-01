//
//  CustomViewElements.swift
//  Marcana
//
//  Created by Deniz Ozagac on 13/01/2023.
//

import SwiftUI

//MARK: Custom modifier for the back button in navigation
struct customNavBackModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss
    func body(content: Content) -> some View {
        content
        // Hide the system back button
        .navigationBarBackButtonHidden(true)
        // Add your custom back button here
        .navigationBarItems(leading:
            Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .frame(width: 24, height: 24)
        })
        .foregroundColor(.text)
    }
}

