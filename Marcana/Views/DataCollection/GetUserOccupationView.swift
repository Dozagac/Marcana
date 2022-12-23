//
//  GetUserOccupationView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

struct GetUserOccupationView: View {
    @State private var occupation: String = ""
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Spacer()
                QuestionText(text: "What is your occupation?")
                TextField("Enter your occupation", text: $occupation, prompt: Text("Student, Artist, Lawyer, Engineer etc."))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)

                Spacer()
            }
            
            //MARK: Continue Button
            if occupation.isNotEmpty {
                VStack {
                    Spacer()
                    NavigationLink(destination: GetUserRelationshipView()) {
                        Text("Continue")
                            .modifier(ContinueNavLinkModifier())
                    }
                }
            }
        }
    }
}

struct GetUserOccupationView_Previews: PreviewProvider {
    static var previews: some View {
        GetUserOccupationView()
    }
}
