//
//  OnboardingView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 05/02/2023.
//

import SwiftUI

struct OnboardingViewWelcome: View {
    var body: some View {

        ZStack {
            BackgroundView()

            VStack {
                Spacer()
                Image("AIFortuneTeller")
                    .resizable()
                    .scaledToFit()

                Text("Welcome!")
                    .font(Font.custom("Palatino-Bold", size: 38))

                Spacer()

                VStack {
                    Text("Marcana provides ")
                    Text("deeply personal").bold()
                    Text("Tarot Readings")
                }
                    .font(.customFontTitle2)
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 44)

                Spacer()

                NavigationLink {
                    OnboardingUserGoalsView()
                } label: {
                    Text("Continue")
                        .modifier(OnboardingContinueButtonModifier(canContinue: true))
                }
                    .padding(.horizontal, UIValues.bigButtonHPadding)
                    .padding(.bottom, UIValues.onboardingContinueButtonBottomPadding)
            }
        }
    }
}


//MARK: Custom modifier for the continue navigation button
struct OnboardingContinueButtonModifier: ViewModifier {
    var canContinue: Bool
    func body(content: Content) -> some View {
        content
            .font(.customFontTitle3)
            .fontWeight(.semibold)
            .frame(height: 55) // so the button stays same size even if text in it changes/disappears
        .frame(maxWidth: .infinity)
            .background(canContinue ? .white : .gray)
            .foregroundColor(.marcanaBackground)
            .cornerRadius(50)
            .shadow(radius: 8)
    }
}


struct OnboardingViewWelcome_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingViewWelcome()
            .preferredColorScheme(.dark)
    }
}
