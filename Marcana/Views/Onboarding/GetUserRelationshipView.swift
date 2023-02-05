//
//  GetUserRelationshipView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

enum Relationship: String, CaseIterable {
    case single = "Single"
    case complicated = "It is complicated"
    case relationship = "In a relationship"
    case engaged = "Engaged"
    case married = "Married"
}

// Last step of userInfoFlow
struct GetUserRelationshipView: View {
    @Binding var getUserInfoStep: Int
    @AppStorage(wrappedValue: true, "doUserInfoFlow") var doUserInfoFlow
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("userRelationship") var userRelationship : String?

    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                    .frame(height: 50)
                VStack{
                    VStack(spacing: 12) {
                        Image(systemName: "heart.circle")
                            .font(.largeTitle)
                        QuestionText(text: "Relationship status")
                        
                        Text("Your relationship status can give us a better understanding of your personal relationships and help us provide a more accurate reading.")
                            .multilineTextAlignment(.center)
                            .font(.customFontCallout)
                            .padding(.bottom, 12)
                        
                            
                        ForEach(Relationship.allCases, id: \.self) { status in
                            Button {
                                userRelationship = status.rawValue
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    doUserInfoFlow = false // this dismisses the last view of userInfoFlow
                                    dismiss() // so the view ca be dismissed when accessed from the settings
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(userRelationship == status.rawValue ? Color.text : .clear)
                                    .frame(height: 50)
                                    .overlay(
                                    ZStack {
                                        // Stroke Border
                                        RoundedRectangle(cornerRadius: 10).stroke(Color.text, lineWidth: 1).background(.clear)
                                        // Button Text
                                        HStack {
                                            Text(status.rawValue)
                                                .padding(.leading, 16)
                                            Spacer()
                                        }
                                        .foregroundColor(userRelationship == status.rawValue ? Color.black : .text)
                                    }
                                )
                            }
                        }
                        
                    }
                        .frame(maxWidth: .infinity)
                    
                        .padding(.horizontal, 24)
                }
                .padding(.vertical, 24)
                    .background(.ultraThinMaterial)
                .cornerRadius(48)
                
                Spacer()
            }
        }
    }
}



struct GetUserRelationshipView_Previews: PreviewProvider {
    @State static var getUserInfoStep = 4
    static var previews: some View {
        GetUserRelationshipView(getUserInfoStep: $getUserInfoStep)
            .environmentObject(MockUserOO())
            .preferredColorScheme(.dark)
    }
}
