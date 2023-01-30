//
//  GetUserOccupationView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

struct GetUserOccupationView: View {
    @Binding var onboardingStage: Int
    @AppStorage("userOccupation") var userOccupation = ""
    @FocusState private var focusTextField

    private var canContinue: Bool {
        userOccupation.isNotEmpty
    }

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 100)
                VStack(spacing: 12) {
                    Image(systemName: "briefcase.fill")
                        .font(.largeTitle)
                    QuestionText(text: "What is your occupation?")
                        .padding(.bottom, 24)
                    TextField("Enter your occupation", text: $userOccupation, prompt: Text("Job"))
                        .font(.title)
                        .foregroundColor(.text)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.plain)
                        .focused($focusTextField)
                        .onSubmit {
                        if userOccupation.isNotEmpty {
                            onboardingStage += 1
                            focusTextField = false
                        }
                    }
                }
                    .padding(24)
                    .background(.ultraThinMaterial)
                    .cornerRadius(48)
            }

            //MARK: Continue Button
            VStack {
                Spacer()
                OnboardingContinueButton(onboardingStage: $onboardingStage, canContinue: canContinue)
                    .simultaneousGesture(TapGesture().onEnded {
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
