//
//  OnboardingView4.swift
//  Marcana
//
//  Created by Deniz Ozagac on 21/02/2023.
//

import SwiftUI

struct OnboardingTestimonialsView: View {
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
                Spacer()
                    .frame(height: UIValues.onboardingScreenTopPadding)
//                    .frame(height: UIScreen.main.bounds.height * 0.05)

                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("From our Users")
                            .font(.customFontTitle3)
                            .foregroundColor(.white)
                            .fontWeight(.black)
                            .lineLimit(1)

                        ZStack(alignment: .bottom){
                            ScrollView{
                                VStack(spacing: 12) {
                                    // testimonials
                                    TestimonialView(testimonialUser: TestimonialUser(imageName: "UserPortrait1", name: "Maria", testimonial: "Great app for tarot beginners like me! Easy to use and understand.\nLove the personal touch to readings!"))
                                    
                                    TestimonialView(testimonialUser: TestimonialUser(imageName: "UserPortrait2", name: "Ana", testimonial: "As a tarot enthusiast, I've used many apps but this one stands out. The readings feel authentic and the app is user-friendly. Highly recommend!"))
                                    
                                    TestimonialView(testimonialUser: TestimonialUser(imageName: "UserPortrait3", name: "Katya", testimonial: "This app has helped me find moments of self-reflection during my day"))
                                    
                                    TestimonialView(testimonialUser: TestimonialUser(imageName: "UserPortrait4", name: "Kylie", testimonial: "I was one of the early testers, I still use it daily. It helps me practice my Tarot reading skills"))
                                }
                                Spacer()
                                    .frame(height: 20)
                            }
                            ScrollerTextBottomGradientEffectView(effectColor: Color.marcanaBackground)
                        }
                    }

                    //MARK: - Olive branch icon
                    TestimonialProofCrownView()
                        .padding(.vertical, 12)

                    // Turn on notification button
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
        }
            .navigationBarBackButtonHidden(true)
            .onAppear{
                AnalyticsManager.shared.logEvent(eventName: AnalyticsKeys.onboardingTestimonialsPageview)
            }
    }
}

struct TestimonialUser {
    let imageName: String
    let name: String
    let testimonial: String
}


struct TestimonialView: View {
    let testimonialUser: TestimonialUser
    var body: some View {

        HStack(alignment: .top) {
            Image(testimonialUser.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
            VStack(alignment: .leading, spacing: 4) {
                Text(testimonialUser.name).bold()
                Text(testimonialUser.testimonial)
                    .font(.subheadline)
                    .layoutPriority(1)
                    .fixedSize(horizontal: false, vertical: true)
            }
                .foregroundColor(.black)

            Spacer()
        }
            .padding()
            .background(.gray)
            .cornerRadius(12)
    }
}

struct TestimonialProofCrownView: View {
    var body: some View {
        VStack {
            HStack {
                Image("OliveBranch")
                    .frame(height: 40)

                VStack {
                    Text("Apps We Love").bold()
                    Text("Apple")

                }
                    .font(.customFontBody)

                Image("OliveBranch")
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .frame(height: 40)

            }
            HStack(spacing: 0) {
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
            }
                .foregroundColor(.yellow)
        }
    }
}

struct OnboardingView4_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingTestimonialsView()
    }
}


