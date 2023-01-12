//
//  BackGroundView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 07/12/2022.
//

import Foundation
import SwiftUI
import AVKit

struct OnboardingBackgroundView: View {
    @State private var player = AVPlayer()

    var body: some View {
        ZStack {
//            GeometryReader { geo in
//                PlayerView()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: geo.size.width, height: geo.size.height + 100)
//                    .edgesIgnoringSafeArea(.all)
//                    .overlay(Color.black.opacity(0.5))
//                    .blur(radius: 6)
//                    .edgesIgnoringSafeArea(.all)
//                    .colorMultiply(.foreground) // #6B4E71
//            }
        }
    }
}

struct BackgroundView: View {
    var body: some View {
        ZStack {
//            Color.background
//                .ignoresSafeArea()
//            HStack {
//                VStack {
//                    // Creating this with an arc causes the image's cut part to overflow the screen and messes up the layout of the pages it is in. Infinite width child Views extend past the Screen.
//                    Image("CornerSun")
//                    Spacer()
//                }
//                Spacer()
//            }.ignoresSafeArea()
        }
    }
}

struct OnboardingBackgroundViewBKP: View {
    @State private var change = false

    var body: some View {
        ZStack {
            Image("onboardingBackground")
                .resizable()
                .ignoresSafeArea()
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
        OnboardingBackgroundView()
    }
}


