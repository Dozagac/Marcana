//
//  CollectUserInfoView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI


struct GetUserNameView: View {
    @Binding var onboardingStage: Int
    @State private var name: String = ""
    @FocusState private var focusTextField
    private var canContinue: Bool {
        name.isNotEmpty
    }

    var body: some View {
        ZStack {
            // MARK: - Get User Name

            VStack{
                Spacer()
                    .frame(height: 100)
                
                VStack(spacing: 12) {
                    Image(systemName: "person.fill")
                        .font(.largeTitle)
                    QuestionText(text: "What is your name?")

                    TextField("Enter your name", text: $name, prompt: Text("Name"))
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.plain)
                        .focused($focusTextField)
                        .onSubmit {
                        if name.isNotEmpty {
                            PersistentDataManager.shared.user.name = name
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
                
                Spacer()
            }

            //MARK: Continue Button
            VStack {
                Spacer()
                OnboardingContinueButton(onboardingStage: $onboardingStage, canContinue: canContinue)
                    .simultaneousGesture(TapGesture().onEnded {
                    PersistentDataManager.shared.user.name = name
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


