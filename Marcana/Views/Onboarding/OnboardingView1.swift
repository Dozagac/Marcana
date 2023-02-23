//
//  OnboardingView1.swift
//  Marcana
//
//  Created by Deniz Ozagac on 21/02/2023.
//

import SwiftUI

struct OnboardingView1: View {
    @State var selectedGoals: Set<Goal> = []
    var body: some View {
        ZStack(alignment: .top) {
            BackgroundView()

            OnboardingCustomBackButton()
                .padding(.leading)

            ProgressStepperView(stepperColor: Color.white,
                                progressStep: 1)
                .zIndex(2)
                .padding(.top)


            //MARK: - Placing the continue button at the same spot at all screens
            VStack {
                // has a 100 height spacer as the first element in VStack
                UserGoalQuestionView(selectedGoals: $selectedGoals)
                Spacer()
                NavigationLink {
                    OnboardingView2()
                } label: {
                    Text("Continue")
                        .font(.customFontTitle3)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedGoals.isEmpty ? .gray : .white)
                        .foregroundColor(.marcanaBackground)
                        .cornerRadius(50)
//                        .padding(.horizontal, 24)
                    .shadow(radius: 8)
                }
                .disabled(selectedGoals.isEmpty)
                .padding(.bottom, 35)
                    .simultaneousGesture(TapGesture().onEnded {
                    // Save the Goal selection to the userDefaults
                    UserDefaults.standard.set(selectedGoals.map { $0.rawValue }, forKey: DefaultKeys.userGoals)
                })

            }
                .padding(.horizontal, UIValues.bigButtonHPadding)
        }
            .navigationBarBackButtonHidden(true)
    }
}

enum Goal: String, CaseIterable {
    case learnTarot
    case LookForAnswers
    case DevelopIntuition
    case FindSpiritualGuidance
    case IncreaseSelfAwareness
    case HaveFun

    var title: String {
        switch self {
        case .learnTarot:
            return "Learn Tarot"
        case .LookForAnswers:
            return "Look for answers"
        case .DevelopIntuition:
            return "Develop my intuition"
        case .FindSpiritualGuidance:
            return "Find spiritual guidance"
        case .IncreaseSelfAwareness:
            return "Increase self-awareness"
        case .HaveFun:
            return "Have Fun"
        }
    }
}

struct UserGoalQuestionView: View {
    @Binding var selectedGoals: Set<Goal>

    var body: some View {
        VStack {
            Spacer()
                .frame(height: UIValues.onboardingScreenTopPadding)

            VStack(alignment: .leading) {
                Text("What brings you to Marcana?")
                    .font(.customFontTitle3)
                    .foregroundColor(.white)
                    .fontWeight(.black)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)


                VStack(alignment: .leading, spacing: 12) {
                    Text("I want to ...").italic()


                    ForEach(Goal.allCases, id: \.rawValue) { goal in
                        Button {
                            if selectedGoals.contains(goal) {
                                selectedGoals.remove(goal)
                            } else {
                                selectedGoals.insert(goal)
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(selectedGoals.contains(goal) ? Color.white : Color.clear)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)

                                .overlay(RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.text, lineWidth: 1).background(.clear))
                                .overlay(alignment: .leading) {
                                Text(goal.title)
                                    .foregroundColor(selectedGoals.contains(goal) ? .black : .white)
                                    .fontWeight(.bold)
                                    .padding(.leading, 24)
                            }
                        }
                    }
                }
                    .font(.customFontBody)
                    .padding(.top)
            }
        }
    }
}

struct OnboardingCustomBackButton: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        HStack {
            VStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 40, height: 40)
                        .tint(Color.text)
                }
                Spacer()
            }
            Spacer()
        }
    }
}

struct OnboardingView1_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView1()
    }
}
