//
//  OnboardingView2.swift
//  Marcana
//
//  Created by Deniz Ozagac on 21/02/2023.
//

import SwiftUI

struct OnboardingView2: View {
    @State var userTarotExperience: Experience? = nil
    var body: some View {
        ZStack(alignment: .top) {
            BackgroundView()

            OnboardingCustomBackButton()
                .padding(.leading)

            ProgressStepperView(stepperColor: Color.white,
                                progressStep: 2)
                .zIndex(2)
                .padding(.top)

            //MARK: - Placing the continue button at the same spot at all screens
            VStack {
                // has a 100 height spacer as the first element in VStack
                UserExperienceQuestionView(userTarotExperience: $userTarotExperience)

                Spacer()

                NavigationLink {
                    OnboardingView3()
                } label: {
                    Text("Continue")
                        .font(.customFontTitle3)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(userTarotExperience == nil ? .gray : .white)
                        .foregroundColor(.marcanaBackground)
                        .cornerRadius(50)
//                        .padding(.horizontal, 24)
                        .shadow(radius: 8)
                }
                .disabled(userTarotExperience == nil)
                    .padding(.bottom, 35)
                    .simultaneousGesture(TapGesture().onEnded {
                    // Save the Goal selection to the userDefaults
                        if let userTarotExperience {
                            UserDefaults.standard.set(userTarotExperience.rawValue, forKey: DefaultKeys.userTarotExperience)
                        }
                })
            }
            .padding(.horizontal, UIValues.bigButtonHPadding)
        }
            .navigationBarBackButtonHidden(true)
    }
}

enum Experience: String, CaseIterable {
    case experienced
    case mediocre
    case learning
    case beginner

    var title: String {
        switch self {
        case .experienced:
            return "Experienced"
        case .mediocre:
            return "Practicing"
        case .learning:
            return "Learning"
        case .beginner:
            return "New to Tarot"
        }
    }
}

struct UserExperienceQuestionView: View {
    @Binding var userTarotExperience : Experience?
    var body: some View {
        VStack {
            Spacer()
                .frame(height: UIValues.onboardingScreenTopPadding)
            
            VStack(alignment: .leading) {

                Text("How familiar are you with Tarot?")
                    .font(.customFontTitle3)
                    .foregroundColor(.white)
                    .fontWeight(.black)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)

                VStack(alignment: .leading, spacing: 12) {
                    Text("I am ...").italic()

                    ForEach(Experience.allCases, id: \.rawValue) { experience in
                        Button(action: {
                            userTarotExperience = experience
                        }, label: {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(userTarotExperience == experience ? Color.white : Color.clear)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)

                                .overlay(RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.text, lineWidth: 1).background(.clear))
                                .overlay(alignment: .leading) {
                                Text(experience.title)
                                    .foregroundColor(userTarotExperience == experience ? .black : .white)
                                    .fontWeight(.bold)
                                    .padding(.leading, 24)
                            }
                        })
                    }
                }
                    .font(.customFontBody)
                    .padding(.top)
            }
        }
    }
}

struct OnboardingView2_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView2()
    }
}
