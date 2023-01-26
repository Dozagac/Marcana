//
//  OnboardingView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 12/01/2023.
//
//

import SwiftUI

struct OnboardingView: View {
    //Transitions
    let transition: AnyTransition = .asymmetric(insertion: .move(edge: .trailing),
                                                removal: .move(edge: .leading))
    @StateObject var user = UserOO()
    @State var onboardingStage: Int = 0

    var body: some View {

        ZStack {
            VideoBackgroundView(videoFileName: "tarotTableVideo", playRate: 0.8)
//            Color.black

            //MARK: Back button for onboarding
            OnboardingBackButton(onboardingStage: $onboardingStage)

            //MARK: Onboarding Views
            Group {
                switch onboardingStage {
                case 0:
                    GetUserNameView(onboardingStage: $onboardingStage).transition(transition)
                case 1:
                    GetUserGenderAndBirthdayView(onboardingStage: $onboardingStage).transition(transition)
                case 2:
                    GetUserOccupationView(onboardingStage: $onboardingStage).transition(transition)
                case 3:
                    GetUserRelationshipView(onboardingStage: $onboardingStage).transition(transition)
                default:
                    VStack {
                        Text("This should not appear")
                        Button("Reset") {
                            onboardingStage = 0
                        }
                    }
                }
            }
                .zIndex(1) // This is needed to enable transition out animations. It's a bug: https://sarunw.com/posts/how-to-fix-zstack-transition-animation-in-swiftui/
            .environmentObject(user)
                .accentColor(.text)
                .preferredColorScheme(.dark)
        }
    }
}


struct QuestionText: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.title)
            .foregroundColor(.text)
            .frame(maxWidth: .infinity)
            .minimumScaleFactor(0.8)
    }
}


struct OnboardingContinueButton: View {
    @Binding var onboardingStage: Int
    var canContinue: Bool
    var body: some View {
        Button {
            if onboardingStage == 3 {
                finalizeOnboarding()
            } else {
                withAnimation(.spring()) {
                    onboardingStage += 1
                }
            }
        } label: {
            Text("Continue")
                .modifier(OnboardingContinueButtonModifier(canContinue: canContinue))
        }
            .disabled(!canContinue)

    }
    func finalizeOnboarding() {
        print("finish onboarding")
    }
}


//MARK: Custom modifier for the continue navigation button
struct OnboardingContinueButtonModifier: ViewModifier {
    var canContinue: Bool
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .frame(width: 280, height: 50)
            .background(canContinue ? Color.text : .purple)
            .foregroundColor(canContinue ? .black : .text)
            .cornerRadius(12)
            .saturation(canContinue ? 1 : 0)
            .padding(.bottom, 24)
            .animation(.easeIn(duration: 0.3), value: canContinue)
    }
}


struct OnboardingBackButton: View {
    @Binding var onboardingStage: Int
    var body: some View {
        HStack {
            VStack {
                Button {
                    if onboardingStage > 0 {
                        onboardingStage -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 40, height: 40)
                        .tint(Color.text)
                }
                Spacer()
            }
                .opacity(onboardingStage == 0 ? 0 : 1)
            Spacer()
        }
            .padding()
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .preferredColorScheme(.dark)
    }
}