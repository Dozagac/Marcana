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
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage(UserDataManager.UserKeys.userRelationship.rawValue) var userRelationship : String?
    @AppStorage(wrappedValue: true, DefaultKeys.doUserInfoFlow) var doUserInfoFlow

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
                        
                        Text("Your personal information is solely used for generating personalized fortune tellings and will be kept confidential.")
                            .multilineTextAlignment(.center)
                            .font(.customFontFootnote)
                            .padding(.bottom, 12)
                        
                            
                        ForEach(Relationship.allCases, id: \.self) { relationshipStatus in
                            Button {
                                userRelationship = relationshipStatus.rawValue
                                
                                AnalyticsManager.shared.setUserProperties(properties: [AnalyticsAmplitudeUserPropertyKeys.userRelationship: relationshipStatus.rawValue])
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                    doUserInfoFlow = false // this dismisses the userInfoFlow sheet
                                    self.presentationMode.wrappedValue.dismiss() // so the view can be dismissed when accessed from the settings
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(userRelationship == relationshipStatus.rawValue ? Color.text : .clear)
                                    .frame(height: 50)
                                    .overlay(
                                    ZStack {
                                        // Stroke Border
                                        RoundedRectangle(cornerRadius: 25).stroke(Color.text, lineWidth: 1).background(.clear)
                                        // Button Text
                                        HStack {
                                            Text(relationshipStatus.rawValue)
                                                .padding(.leading, 16)
                                            Spacer()
                                        }
                                        .foregroundColor(userRelationship == relationshipStatus.rawValue ? Color.black : .text)
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
            .padding(.horizontal, UIValues.bigButtonHPadding)
        }
        .onAppear{
            AnalyticsManager.shared.logEvent(
                eventName: AnalyticsKeys.userInfoFlowRelationshipPageview
            )
        }
    }
}



struct GetUserRelationshipView_Previews: PreviewProvider {
    @State static var getUserInfoStep = 4
    static var previews: some View {
        GetUserRelationshipView(getUserInfoStep: $getUserInfoStep)
            .preferredColorScheme(.dark)
    }
}
