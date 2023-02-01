//
//  CollectUserInfoView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI


struct GetUserNameView: View {
    @Binding var onboardingStage: Int
    @FocusState private var focusTextField

    @AppStorage("userName") var userName = ""
    private var canContinue: Bool {
        userName.isNotEmpty
    }

    var body: some View {
        ZStack(alignment: .top) {
            // MARK: - Get User Name
            VStack {
                Spacer()
                    .frame(height: 100)

                VStack(spacing: 12) {
                    Image(systemName: "pencil.line")
                        .font(.largeTitle)
                    QuestionText(text: "What is your name?")

//                    Group {
//                        Text("We value your privacy and assure you that the information you provide will not be used for anything other than providing you with a personalized reading.")
//                            .multilineTextAlignment(.center)
//                            .font(.customFontCallout)
//                    }

                    Text("We ask for your name to personalize your reading and ensure the accuracy of your fortune telling experience.")
                        .multilineTextAlignment(.center)
                        .font(.customFontCallout)

                    TextField("Enter your name", text: $userName, prompt: Text("Name"))
                        .font(.customFontTitle2)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.plain)
                        .focused($focusTextField)
                        .onSubmit {
                        if userName.isNotEmpty {
                            onboardingStage += 1
                            focusTextField = false
                        }
                    }
                }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.text)
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



struct CollectUserInfoView_Previews: PreviewProvider {
    @State static var onboardingStage = 1
    static var previews: some View {
        GetUserNameView(onboardingStage: $onboardingStage)
            .environmentObject(MockUserOO())
            .preferredColorScheme(.dark)
    }
}


