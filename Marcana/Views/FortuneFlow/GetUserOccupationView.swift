//
//  GetUserOccupationView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

struct GetUserOccupationView: View {
    @State private var occupation: String = ""
    private var defaultOccupations = [
        "Working as a ___",
        "Studying ___",
        "Not Working",
        "Looking for a job",
        "Parent",
        "Business Owner",
        "Retired",
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Spacer()
                QuestionText(text: "What is your occupation?")
                    .padding(.bottom, 20)
                TextField("Enter your occupation", text: $occupation, prompt: Text("Student, Artist, Lawyer, Engineer ..."))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                
                VStack {
                    Text("You can enter your job title in detail, or choose one below:")
                }
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .foregroundColor(.text)


                VStack(alignment: .leading, spacing: 10) {
                    //MARK: Gender Buttons
                    ForEach(defaultOccupations, id: \.self) { occupation in
                        Button(action: {
                            self.occupation = occupation }
                        ) {
                            HStack{
                                Text(occupation)
                                    .font(.subheadline)
                                    .padding(.leading, 8)
                                    .padding(4)
                                Spacer()
                            }
                        }
                            .frame(maxWidth: .infinity)
                            .background(Color.clear)
                            .foregroundColor(Color.text)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10
                        ).stroke(Color.text, lineWidth: 0.3).background(.clear))
                            .padding(.horizontal, 20)
                    }
                }
                
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
