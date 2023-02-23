//
//  OnboardingView4.swift
//  Marcana
//
//  Created by Deniz Ozagac on 21/02/2023.
//

import SwiftUI

struct OnboardingView4: View {
    var body: some View {
        ZStack(alignment: .top) {
            BackgroundView()

            OnboardingCustomBackButton()
                .padding(.leading)

            ProgressStepperView(stepperColor: Color.white,
                                progressStep: 4)
                .zIndex(2)
                .padding(.top)

            //MARK: - Placing the continue button at the same spot at all screens
            VStack {
                Spacer()
                    .frame(height: UIValues.onboardingScreenTopPadding)

                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("User Reviews")
                            .font(.customFontTitle3)
                            .foregroundColor(.white)
                            .fontWeight(.black)
                            .lineLimit(1)

                        // testimonials
                        TestimonialView(testimonialUser: TestimonialUser(imageName: "UserPortrait1", name: "Maria", testimonial: "I was one of the early testers and I kept on using Marcana for its sincere and actually personal tarot readings."))
//                        TestimonialView(testimonialUser: TestimonialUser(imageName: "UserPortrait2", name: "Ana", testimonial: "I like how Marcana offers actual personalized fortune readings, not just generic stuff from a database.\nHappy to see something different :)"))
                        TestimonialView(testimonialUser: TestimonialUser(imageName: "UserPortrait3", name: "Katya", testimonial: "This app has helped me find moments of self-reflection during my day.\nHighly recommend!"))
                    }

                    Spacer()

                    //MARK: - Olive branch icon
                    TestimonialProofCrownView()

                    Spacer()

                    NavigationLink {
                        OnboardingView5()
                    } label: {
                        Text("Continue")
                            .font(.customFontTitle3)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(.marcanaBackground)
                            .cornerRadius(50)
                        //                        .padding(.horizontal, 24)
                        .shadow(radius: 8)
                    }
                        .padding(.bottom, 35)
                }
                    .padding(.horizontal, UIValues.bigButtonHPadding)
            }
        }
            .navigationBarBackButtonHidden(true)
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
        OnboardingView4()
    }
}


