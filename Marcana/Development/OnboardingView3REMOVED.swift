//
//  OnboardingView3.swift
//  Marcana
//
//  Created by Deniz Ozagac on 21/02/2023.
//

import SwiftUI

struct OnboardingView3: View {
    @State private var currentTab = 0


    var body: some View {
        ZStack(alignment: .top) {
            BackgroundView()

            OnboardingCustomBackButton()
                .padding(.leading)

            ProgressStepperView(stepperColor: Color.white,
                                progressStep: 3,
                                numberOfSteps: 4)
                .zIndex(2)
                .padding(.top)

            //MARK: - Placing the continue button at the same spot at all screens
            VStack {
//                Spacer()
//                    .frame(height: UIValues.onboardingScreenTopPadding)

                TabView(selection: $currentTab) {

                    // MARK: - Tab 1
                    VStack(spacing: 24) {
                        Image("OnboardingImage1")
                            .resizable()
                            .scaledToFit()
                            .shadow(radius: 50)
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                            .padding(.bottom, 54)
                        VStack(spacing: 0) {
                            VStack(spacing: 8) {
                                VStack {
                                    Text("Tarot is a tool for ")
                                    Text("Spiritual Guidance ").bold()
                                    Text("and ")
                                    Text("Self Discovery").bold()
                                }
                                    .font(.customFontTitle2)
                                    .padding(.bottom, 40)
                            }
                                .frame(height: 100)
                        }
                            .multilineTextAlignment(.center)
                    }
                        .foregroundColor(.text)
                        .tabItem {
                        Text("Page 1")
                    }
                        .tag(1)

                    // MARK: - Tab 2
                    VStack(spacing: 24) {
                        Image("OnboardingImage2")
                            .resizable()
                            .scaledToFit()
                            .shadow(radius: 50)
                        VStack(spacing: 0) {
                            VStack(spacing: 8) {
                                VStack {
                                    Text("It enables the reader to ")
                                    Text("connect with their ")
                                    Text("Inner Wisdom").bold()
                                }
                                    .font(.customFontTitle2)
                                    .padding(.bottom, 40)
                            }
                                .frame(height: 100)
                        }
                            .multilineTextAlignment(.center)
                    }
                        .tabItem {
                        Text("Page 2")
                    }
                        .tag(2)

                    // MARK: - Tab 3
                    VStack(spacing: 24) {
                        Image("OnboardingImage3")
                            .resizable()
                            .scaledToFit()
                            .shadow(radius: 50)
                        VStack(spacing: 0) {
                            VStack(spacing: 8) {
                                VStack {
                                    Text("Tarot ") +
                                        Text("Helps You Understand").bold()
                                    Text("what you need to know")
                                    Text("about a situation")
                                }
                                    .font(.customFontTitle2)
                                    .padding(.bottom, 40)
                            }
                                .frame(height: 100)
                        }
                            .multilineTextAlignment(.center)
                    }
                        .tabItem {
                        Text("Page 3")
                    }
                        .tag(3)
                }
                    .tabViewStyle(.page)

                Spacer()


                NavigationLink {
                    OnboardingSetRemindersView()
                } label: {
                    Text("Continue")
                        .modifier(OnboardingContinueButtonModifier(canContinue: true))
                }
                    .padding(.bottom, UIValues.onboardingContinueButtonBottomPadding)
            }
                .padding(.horizontal, UIValues.bigButtonHPadding)
        }
            .navigationBarBackButtonHidden(true)
            .zIndex(1) // This is needed to enable transition out animations. It's a bug: https://sarunw.com/posts/how-to-fix-zstack-transition-animation-in-swiftui/
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

struct OnboardingView3_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView3()
    }
}
