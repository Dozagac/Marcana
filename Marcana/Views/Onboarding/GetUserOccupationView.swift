//
//  GetUserOccupationView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

struct GetUserOccupationView: View {
    @EnvironmentObject var newUser: UserOO
    @State private var occupation: String = ""
    @FocusState private var focusTextField
    @State var continueOnBoarding = false

    private var canContinue: Bool {
        occupation.isNotEmpty
    }

    var body: some View {
        ZStack {
            OnboardingBackgroundView()

            VStack(spacing: 36) {
                VStack {
                    QuestionText(text: "What is your occupation?")
                        .padding(.bottom, 24)
                    TextField("Enter your occupation", text: $occupation, prompt: Text("")) //"Student, Artist, Lawyer, Engineer ..."
                    .font(.title)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.plain)
                        .focused($focusTextField)
                        .onSubmit {
                            if occupation.isNotEmpty{
                                continueOnBoarding = true
                            }
                        }

                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.text)
                        .padding(.horizontal)
                }
            }


            //MARK: Continue Button

            VStack {
                Spacer()
                NavigationLink(destination: GetUserRelationshipView(), isActive: $continueOnBoarding) {
                    Text("Continue")
                        .modifier(ContinueNavLinkModifier(canContinue: canContinue))
                }
                    .disabled(!canContinue)
                    .simultaneousGesture(TapGesture().onEnded {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    newUser.occupation = occupation
                })
            }
        }
            .modifier(OnboardingCustomNavBack())
            .onAppear {
            // this is necessary to make focus work
            DispatchQueue.main.async { focusTextField = true }
        }
    }
}


struct GetUserOccupationView_Previews: PreviewProvider {
    static var previews: some View {
        GetUserOccupationView()
            .environmentObject(MockUserOO())
    }
}
