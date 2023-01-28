//
//  GetUserOccupationView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

struct GetUserOccupationView: View {
    @Binding var onboardingStage: Int
    @State private var occupation: String = ""
    @FocusState private var focusTextField

    private var canContinue: Bool {
        occupation.isNotEmpty
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 100)
                VStack(spacing: 12) {
                    Image(systemName: "star.fill")
                        .font(.largeTitle)
                    QuestionText(text: "What is your occupation?")
                        .padding(.bottom, 24)
                    TextField("Enter your occupation", text: $occupation, prompt: Text("Job"))
                        .font(.title)
                        .foregroundColor(.text)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.plain)
                        .focused($focusTextField)
                        .onSubmit {
                        if occupation.isNotEmpty {
                            onboardingStage += 1
                            focusTextField = false
                        }
                    }
                }
                    .padding(24)
                    .background(.ultraThinMaterial)
                    .cornerRadius(48)

                Spacer()
            }

            //MARK: Continue Button
            VStack {
                Spacer()
                OnboardingContinueButton(onboardingStage: $onboardingStage, canContinue: canContinue)
                    .simultaneousGesture(TapGesture().onEnded {
                    PersistentDataManager.shared.user.occupation = occupation
                    focusTextField = false
                })
            }
        }
            .onAppear {
            // this is necessary to make focus work
            DispatchQueue.main.async { focusTextField = true }
        }
    }
}


struct GetUserOccupationView_Previews: PreviewProvider {
    @State static var onboardingStage = 3
    static var previews: some View {
        GetUserOccupationView(onboardingStage: $onboardingStage)
            .environmentObject(MockUserOO())
            .preferredColorScheme(.dark)
    }
}
