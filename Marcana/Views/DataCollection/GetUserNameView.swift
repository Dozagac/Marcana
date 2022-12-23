//
//  CollectUserInfoView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI


struct GetUserNameView: View {
    @State private var name: String = ""
    var body: some View {
        ZStack {
            BackgroundView()
            
            //MARK: Get User Name
            VStack {
                Spacer()
                QuestionText(text: "Hello, seeker of answers")
                TextField("Enter your name", text: $name, prompt: Text("What is your name?"))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                Spacer()
            }
            
            //MARK: Continue Button
            if name.isNotEmpty {
                VStack {
                    Spacer()
                    NavigationLink(destination: GetUserGenderView()) {
                        Text("Continue")
                            .modifier(ContinueNavLinkModifier())
                    }
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
            .font(.title2)
            .foregroundColor(.text)
    }
}
