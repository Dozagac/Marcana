//
//  CollectUserInfoView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI


struct GetUserNameView: View {
    @Binding var getUserInfoStep: Int
    @FocusState private var focusTextField
    @AppStorage(wrappedValue: 0, DefaultKeys.readingCountPerUserName) var readingCountPerUserName
    @AppStorage(wrappedValue: "", UserDataManager.UserKeys.userName.rawValue) var userName
    private var canContinue: Bool {
        userName.isNotEmpty
    }

    var body: some View {
        ZStack(alignment: .top) {
            // MARK: - Get User Name
            VStack {
                Spacer()
                    .frame(height: 50)

                VStack(spacing: 12) {
                    Image(systemName: "pencil.line")
                        .font(.largeTitle)
                    QuestionText(text: "What is your name?")

                    Text("Your personal information is solely used for generating personalized fortune tellings and will be kept confidential.")
                        .multilineTextAlignment(.center)
                        .font(.customFontFootnote)
                        .padding(.horizontal)

                    TextField("Enter your name", text: $userName, prompt: Text("Name"))
                        .font(.customFontTitle3)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.plain)
                        .focused($focusTextField)
                        .onChange(of: userName) { _ in
                        readingCountPerUserName = 0
                    }
                        .onSubmit {
                        if userName.isNotEmpty {
                            getUserInfoStep += 1
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
                .padding(.horizontal, UIValues.bigButtonHPadding)

            //MARK: Continue Button
            VStack {
                Spacer()
                GetUserInfoContinueButton(getUserInfoStep: $getUserInfoStep, canContinue: canContinue)
                    .simultaneousGesture(TapGesture().onEnded {
                    focusTextField = false
                    AnalyticsManager.shared.setUserProperties(properties: [AnalyticsAmplitudeUserPropertyKeys.userName: userName])
                })
            }
                .padding(.horizontal, UIValues.bigButtonHPadding)
        }
            .onAppear {
            // this is necessary to make focus work
            DispatchQueue.main.async { focusTextField = true }

            AnalyticsManager.shared.logEvent(
                eventName: AnalyticsKeys.userInfoFlowNamePageview
            )
        }
    }
}



struct CollectUserInfoView_Previews: PreviewProvider {
    @State static var getUserInfoStep = 1
    static var previews: some View {
        GetUserNameView(getUserInfoStep: $getUserInfoStep)
            .preferredColorScheme(.dark)
    }
}


