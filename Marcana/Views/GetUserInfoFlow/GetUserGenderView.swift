//
//  TestingView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

enum GenderPronoun: String, Equatable, CaseIterable {
    case her = "Her"
    case him = "Him"
    case them = "Them"

    var icon: String {
        switch self {
        case .him:
            return "GenderMale"
        case .her:
            return "GenderFemale"
        case .them:
            return "GenderIntersex"
        }
    }
}

struct GetUserGenderView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var getUserInfoStep: Int
    
    // Gender
    @AppStorage("userGender") var userGender: String?

    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                    .frame(height: 50)

                VStack(spacing: 16) {
                    //MARK: - Gender Selection
                    VStack(spacing: 8) {
                        Image(systemName: "person.fill")
                            .font(.largeTitle)

                        QuestionText(text: "How should we call you?")
 
                        Text("Your personal information is solely used for generating personalized fortune tellings and will be kept confidential.")
                            .multilineTextAlignment(.center)
                            .font(.customFontFootnote)
                            .padding(.horizontal)
                            

                        //MARK: Gender Buttons
                        HStack(spacing: 16) {
                            ForEach(GenderPronoun.allCases, id: \.self) { gender in
                                Button(action: {
                                    userGender = gender.rawValue
                                
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                        withAnimation(.spring()) {
                                            getUserInfoStep += 1
                                        }
                                        
                                        if getUserInfoStep == 99 {
                                            dismiss() // so the view can be dismissed when accessed from the settings
                                        }
                                        
                                    }
                                }
                                ) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(userGender == gender.rawValue ? Color.text : .clear)
                                        .frame(width: 95, height: 95)
                                        .overlay(RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.text, lineWidth: 1).background(.clear))
                                        .overlay(
                                        VStack {
                                            Image(gender.icon)
                                                .renderingMode(.template)
                                            Text(gender.rawValue)
                                                .font(.title2)
                                        }
                                            .foregroundColor(userGender == gender.rawValue ? Color.black : .text))
                                }
                            }
                        }
                        .padding(.top)
                    }
                }
                .padding(.vertical, 24)
                    .background(.ultraThinMaterial)
                    .cornerRadius(48)
                
                Spacer()
            }
        }
    }
}


struct GetUserGenderAndBirthdayView_Previews: PreviewProvider {
    @State static var getUserInfoStep = 2
    static var previews: some View {
        GetUserGenderView(getUserInfoStep: $getUserInfoStep)
            .environmentObject(MockUserOO())
            .preferredColorScheme(.dark)
    }
}
