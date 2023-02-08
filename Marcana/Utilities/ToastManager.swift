//
//  ToastManager.swift
//  Marcana
//
//  Created by Deniz Ozagac on 08/02/2023.
//


import Foundation
import SimpleToast
import SwiftUI

class ToastManager: ObservableObject {
    @Published var showingToast = false
    let toastOptions = SimpleToastOptions(
        alignment: .bottom,
        hideAfter: 1,
        backdrop: Color.black.opacity(0.2),
        animation: .default,
        modifierType: .slide
    )

}
