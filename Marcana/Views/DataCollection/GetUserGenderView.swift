//
//  TestingView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

struct GetUserGenderView: View {
    @State private var selectedGender: Gender? = nil
    
    enum Gender: String, CaseIterable {
        case male = "Male"
        case female = "Female"
        case lgbtq = "LGBTQ"
        
        var icon: Image {
            switch self {
            case .male:
                return Image("GenderMale")
            case .female:
                return Image("GenderFemale")
            case .lgbtq:
                return Image("GenderPride")
            }
        }
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                QuestionText(text: "Welcome {Name}, \nWhat is your gender?")
                    .padding(.bottom, 10)
                ForEach(Gender.allCases, id: \.self) { gender in
                    Button(action: {
                        self.selectedGender = gender }
                    ) {
                        HStack {
                            gender.icon
                                .frame(width: 30)
                                .padding(.leading)
                            Text(gender.rawValue)
                            Spacer()
                        }
                    }
                    .frame(width: 200, height: 50)
                    .background(self.selectedGender == gender ? Color.foreground : Color.clear)
                    .foregroundColor(Color.text)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10
                                             ).stroke(Color.text, lineWidth: 1).background(.clear))
                }
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
