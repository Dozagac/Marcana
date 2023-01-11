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

struct OnboardingBackgroundView: View {
    @State private var change = false
    
    var body: some View {
        //        ZStack {
        //            Image("onboardingBackground")
        //                .resizable()
        //                .ignoresSafeArea()
        //        }
        ZStack {

            //MARK: Linear Gradiant with rotating hue
            LinearGradient(
                gradient: Gradient(colors: [.blue, .purple, .red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
                .hueRotation(.degrees(change ? 360 : 0))
                .ignoresSafeArea()

            //MARK: Opacity and blur mask
            Color.black
                .opacity(0.3) // 1 opacity gives an interesting effect
            .blur(radius: 0)
                .ignoresSafeArea()
        }
            .animation(.linear(duration: 10).repeatForever(autoreverses: false), value: change)
            .onAppear {
            change.toggle()
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


