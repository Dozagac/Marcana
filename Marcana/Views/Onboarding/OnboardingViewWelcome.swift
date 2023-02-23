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
                    Text("Marcana provides deeply personal ") +
                        Text("Tarot Readings").bold()
                }
                    .font(.customFontTitle2)
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 44)

                Spacer()

                NavigationLink {
                    OnboardingView1()
                } label: {
                    Text("Continue")
                        .font(.customFontTitle3)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.marcanaBackground)
                        .cornerRadius(50)
                        .padding(.horizontal, 24)
                        .shadow(radius: 8)
                }
                    .padding(.bottom, 35)
            }
        }
    }
}


struct OnboardingViewWelcome_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingViewWelcome()
            .preferredColorScheme(.dark)
    }
}
