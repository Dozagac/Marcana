//
//  OnboardingView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 05/02/2023.
//

import SwiftUI

struct OnboardingView: View {
    @State private var onboardingStep = 0
    @Binding var showingPaywall: Bool

    var body: some View {
        ZStack(alignment: .top) {
            BackgroundView()

            VStack {
                TabView(selection: $onboardingStep) {

                    OnboardingStartView()

                    OnboardingPageView(stepImageName: "OnboardingImage1", stepText: "Ask open ended questions", stepSubText: "There are no wrong questions", position: 1)
                        .tabItem {
                        Text("Page 1")
                    }
                        .tag(1)

                    OnboardingPageView(stepImageName: "OnboardingImage2", stepText: "Pick your Tarot Cards", stepSubText: "", position: 2)
                        .tabItem {
                        Text("Page 2")
                    }
                        .tag(2)

                    OnboardingPageView(stepImageName: "OnboardingImage3", stepText: "Get personalized readings", stepSubText: "Most personalized readings in any app", position: 3)
                        .tabItem {
                        Text("Page 3")
                    }
                        .tag(3)
                }
                    .tabViewStyle(.page)
//                .animation(.easeOut(duration: 0.9), value: onboardingStep)


                OnboardingContinueButton(showingPaywall: $showingPaywall, onboardingStep: $onboardingStep, finalStep: 4)
                    .padding(.bottom, 35)
            }
        }
            .zIndex(1) // This is needed to enable transition out animations. It's a bug: https://sarunw.com/posts/how-to-fix-zstack-transition-animation-in-swiftui/
    }
}

struct OnboardingStartView: View {
    var body: some View {

        VStack {
            Spacer()
            Image("MarcanaIconNoBg")
                .resizable()
                .frame(width: 200, height: 200)
            Text("Welcome to Marcana")
                .font(Font.custom("Palatino-Bold", size: 34))
                .padding(.bottom, 24)

            Text("Get the most insightful and personalized tarot readings you've ever had")
                .font(.customFontBody)
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 44)

            Spacer()
            Text("Let's show you how it works")
                .font(.customFontTitle3.bold())
            Spacer()
        }
    }
}

struct OnboardingPageView: View {
    let stepImageName: String
    let stepText: String
    let stepSubText: String
    let position: Int

    var body: some View {
        VStack(spacing: 64) {
            Image(stepImageName)
                .resizable()
                .scaledToFit()
                .shadow(radius: 50)
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Image(systemName: "\(position).circle")
                        .font(.largeTitle)
                    Text(stepText)
                        .font(.customFontTitle3.bold())
                    Text(stepSubText)
                        .font(.customFontSubheadline)
                        .padding(.bottom, 40)
                }
                    .frame(height: 100)
            }
                .multilineTextAlignment(.center)
        }
            .foregroundColor(.text)
    }
}


struct OnboardingContinueButton: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showingPaywall: Bool
    @Binding var onboardingStep: Int
    var finalStep: Int
    var body: some View {
        Button {
            if onboardingStep == finalStep - 1 {
                showingPaywall = true
            } else {
                withAnimation(.spring()) {
                    onboardingStep += 1
                }
            }
        } label: {
            Text(onboardingStep == finalStep ? "Finish" : "Continue")
                .font(.customFontTitle3)
                .fontWeight(.semibold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.text)
                .foregroundColor(.black)
                .cornerRadius(50)
                .padding(.horizontal, 24)
                .shadow(radius: 8)
        }

    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(showingPaywall: .constant(false))
            .preferredColorScheme(.dark)
    }
}
