//
//  GetUserOccupationView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

struct GetUserOccupationView: View {
    @Binding var getUserInfoStep: Int
    @AppStorage(UserDataManager.UserKeys.userOccupation.rawValue) var userOccupation = ""
    @FocusState private var focusTextField

    private var canContinue: Bool {
        userOccupation.isNotEmpty
    }

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 50)
                VStack(spacing: 12) {
                    Image(systemName: "briefcase.fill")
                        .font(.largeTitle)
                    QuestionText(text: "What is your job/occupation?")
                    Text("Your personal information is solely used for generating personalized fortune tellings and will be kept confidential.")
                        .multilineTextAlignment(.center)
                        .font(.customFontFootnote)
                        .padding(.horizontal)
                    
                    TextField("Enter your occupation", text: $userOccupation, prompt: Text("Job"))
                        .padding(.top, 12)
                        .font(.customFontTitle3)
                        .foregroundColor(.text)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.plain)
                        .focused($focusTextField)
                        .onSubmit {
                        if userOccupation.isNotEmpty {
                            getUserInfoStep += 1
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
                GetUserInfoContinueButton(getUserInfoStep: $getUserInfoStep, canContinue: canContinue)
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
    @State static var getUserInfoStep = 3
    static var previews: some View {
        GetUserOccupationView(getUserInfoStep: $getUserInfoStep)
            .environmentObject(MockUserOO())
            .preferredColorScheme(.dark)
    }
}
