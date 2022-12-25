//
//  TestingView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

struct GetUserGenderView: View {
    @State private var selectedGender: Gender? = nil
    @State private var lgbtq = false

    enum Gender: String, CaseIterable {
        case female = "Female"
        case male = "Male"


        var icon: Image {
            switch self {
            case .male:
                return Image("GenderMaleWhite")
            case .female:
                return Image("GenderFemaleWhite")
            }
        }
    }

    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 20) {

                //MARK: Question Title
                QuestionText(text: "Welcome {Name}")
                QuestionText(text: "What is your gender?")

                HStack(spacing: 20) {
                    //MARK: Gender Buttons
                    ForEach(Gender.allCases, id: \.self) { gender in
                        Button(action: {
                            self.selectedGender = gender }
                        ) {
                            HStack {
                                gender.icon
                                Text(gender.rawValue)
                                    .font(.title2)
                            }
                        }
                            .frame(width: 165, height: 165)
                            .background(self.selectedGender == gender ? Color.foreground : Color.clear)
                            .foregroundColor(Color.text)
                            .overlay(RoundedRectangle(cornerRadius: 10
                        ).stroke(Color.text, lineWidth: 1).background(.clear))
                    }
                }

                //MARK: LQBTQ Toggle
                Button(action: {
                    lgbtq.toggle() }
                ) {
                    HStack {
                        Image("GenderPride")
                        Text("LGBTQ")
                    }
                }
                    .frame(width: 165, height: 50)
                    .background(lgbtq ? Color.foreground : Color.clear)
                    .foregroundColor(Color.text)
                    .overlay(RoundedRectangle(cornerRadius: 10
                ).stroke(Color.text, lineWidth: 1).background(.clear))
            }

            //MARK: Continue Button
            if selectedGender != nil {
                VStack {
                    Spacer()
                    NavigationLink(destination: GetUserOccupationView()) {
                        Text("Continue")
                            .modifier(ContinueNavLinkModifier())
                    }
                }
            }
        }
    }
}




struct GetUserGenderView_Previews: PreviewProvider {
    static var previews: some View {
        GetUserGenderView()
    }
}
