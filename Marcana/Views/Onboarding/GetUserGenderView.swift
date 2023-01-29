//
//  TestingView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

enum GenderPronoun: String, Equatable, CaseIterable {
    case her = "Her"
    case him = "Him"
    case them = "Them"

    var icon: String {
        switch self {
        case .him:
            return "GenderMale"
        case .her:
            return "GenderFemale"
        case .them:
            return "GenderIntersex"
        }
    }
}

struct GetUserGenderView: View {
    @Binding var onboardingStage: Int
    
    // Gender
//    @State private var selectedGender: GenderPronoun? = nil
    @AppStorage("userGender") var userGender: String?

    // Condition for the continue button
    private var canContinue: Bool {
        userGender != nil
    }

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 100)

                VStack(spacing: 16) {
                    //MARK: - Gender Selection
                    VStack(spacing: 8) {
                        Image(systemName: "person.fill")
                            .font(.largeTitle)

                        QuestionText(text: "How should we call you?")
                            .padding(.bottom)

                        //MARK: Gender Buttons
                        HStack(spacing: 16) {
                            ForEach(GenderPronoun.allCases, id: \.self) { gender in
                                Button(action: {
                                    userGender = gender.rawValue
                                }
                                ) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(userGender == gender.rawValue ? Color.text : .clear)
                                        .frame(width: 95, height: 95)
                                        .overlay(RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.text, lineWidth: 1).background(.clear))
                                        .overlay(
                                        VStack {
                                            Image(gender.icon)
                                                .renderingMode(.template)
                                            Text(gender.rawValue)
                                                .font(.title2)
                                        }
                                            .foregroundColor(userGender == gender.rawValue ? Color.black : .text))
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 24)
                    .background(.ultraThinMaterial)
                    .cornerRadius(48)
                Spacer()
            }

            //MARK: Continue Button
            VStack {
                Spacer()
                OnboardingContinueButton(onboardingStage: $onboardingStage, canContinue: canContinue)
            }
        }
    }
}


struct GetUserGenderAndBirthdayView_Previews: PreviewProvider {
    @State static var onboardingStage = 2
    static var previews: some View {
        GetUserGenderView(onboardingStage: $onboardingStage)
            .environmentObject(MockUserOO())
            .preferredColorScheme(.dark)
    }
}
