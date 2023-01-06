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
    private var filled: Bool {
        selectedGender != nil
    }


    enum Gender: String, CaseIterable {
        case female = "Female"
        case male = "Male"
        case other = "Other"


        var icon: Image {
            switch self {
            case .male:
                return Image("GenderMaleWhite")
            case .female:
                return Image("GenderFemaleWhite")
            case .other:
                return Image(systemName: "bubbles.and.sparkles")
                    
            }
        }
    }

    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 24) {

                //MARK: Question Title
                QuestionText(text: "Welcome {Name}, \nWhat is your gender?")

                HStack(spacing: 24) {
                    //MARK: Gender Buttons
                    ForEach(Gender.allCases, id: \.self) { gender in
                        Button(action: {
                            self.selectedGender = gender }
                        ) {
                            VStack {
                                gender.icon
                                Text(gender.rawValue)
                                    .font(.title2)
                            }
                        }
                            .frame(width: 110, height: 110)
                            .background(self.selectedGender == gender ? Color.foreground : Color.clear)
                            .foregroundColor(Color.text)
                            .overlay(RoundedRectangle(cornerRadius: 10
                        ).stroke(Color.text, lineWidth: 1).background(.clear))
                    }
                }
            }

            //MARK: Continue Button

                VStack {
                    Spacer()
                    NavigationLink(destination: GetUserOccupationView()) {
                        Text("Continue")
                            .modifier(ContinueNavLinkModifier(filled: filled))
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
