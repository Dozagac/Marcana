//
//  BackGroundView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 07/12/2022.
//

import Foundation
import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.bgGradient2, Color.bgGradient1]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}
