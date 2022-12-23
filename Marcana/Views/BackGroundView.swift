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
        ZStack {
            Color.background
                .ignoresSafeArea()
            HStack {
                VStack {
                    // Creating this with an arc causes the image's cut part to overflow the screen and messes up the layout of the pages it is in. Infinite width child Views extend past the Screen.
                    Image("CornerSun")
                    Spacer()
                }
                Spacer()
            }.ignoresSafeArea()
        }
    }
}


struct PlainBackgroundView: View {
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
        }
    }
}


struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}


