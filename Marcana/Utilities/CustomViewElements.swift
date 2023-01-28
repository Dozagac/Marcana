//
//  CustomViewElements.swift
//  Marcana
//
//  Created by Deniz Ozagac on 13/01/2023.
//

import SwiftUI

//MARK: Custom modifier for the back button in onboarding
struct customNavBackModifier: ViewModifier {
    @Environment(\.presentationMode) var presentationMode
    func body(content: Content) -> some View {
        content
        // Hide the system back button
        .navigationBarBackButtonHidden(true)
        // Add your custom back button here
        .navigationBarItems(leading:
            Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .frame(width: 24, height: 24)
        })
    }
}

