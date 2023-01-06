//
//  CollectUserInfoView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI


struct GetUserNameView: View {
    @State private var name: String = ""
    private var filled: Bool {
        name.isNotEmpty
    }
    var body: some View {
        ZStack {
            BackgroundView()

            //MARK: Get User Name
            VStack(spacing: 24) {
                Spacer()
                QuestionText(text: "Hello, seeker of answers")
                TextField("Enter your name", text: $name, prompt: Text("What is your name?"))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
            }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)

            //MARK: Continue Button
            VStack {
                Spacer()
                NavigationLink(destination: GetUserGenderView()) {
                    Text("Continue")
                        .modifier(ContinueNavLinkModifier(filled: filled))
                }
            }
        }
    }
}


struct CollectUserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GetUserNameView()
    }
}

struct QuestionText: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.title)
            .foregroundColor(.text)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .minimumScaleFactor(0.8)
    }
}
