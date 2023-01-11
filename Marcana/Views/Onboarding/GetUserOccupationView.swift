//
//  GetUserOccupationView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

struct GetUserOccupationView: View {
    @EnvironmentObject var newUser: User
    @State private var occupation: String = ""
    @FocusState private var focusTextField

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

                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal)
                }
            }


            //MARK: Continue Button

            VStack {
                Spacer()
                NavigationLink(destination: GetUserRelationshipView()) {
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
            .environmentObject(MockUser())
    }
}
