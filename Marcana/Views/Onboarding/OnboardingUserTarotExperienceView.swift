//
//  OnboardingView2.swift
//  Marcana
//
//  Created by Deniz Ozagac on 21/02/2023.
//

import SwiftUI

struct OnboardingUserTarotExperienceView: View {
    @State var userTarotExperience: Experience? = nil
    var body: some View {
        ZStack(alignment: .top) {
            BackgroundView()

            OnboardingCustomBackButton()
                .padding(.leading)

            ProgressStepperView(stepperColor: Color.white,
                                progressStep: 2,
                                numberOfSteps:4)
                .zIndex(2)
                .padding(.top)

            //MARK: - Placing the continue button at the same spot at all screens
            VStack {
                // has a 100 height spacer as the first element in VStack
                UserExperienceQuestionView(userTarotExperience: $userTarotExperience)

                Spacer()

                NavigationLink {
                    OnboardingTestimonialsView()
                } label: {
                    Text("Continue")
                        .modifier(OnboardingContinueButtonModifier(canContinue: userTarotExperience != nil))
                }
                .disabled(userTarotExperience == nil)
                    .padding(.bottom, UIValues.onboardingContinueButtonBottomPadding)
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
        OnboardingUserTarotExperienceView()
    }
}
