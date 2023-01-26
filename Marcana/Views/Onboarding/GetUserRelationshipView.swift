//
//  GetUserRelationshipView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

// Last step of onboarding
struct GetUserRelationshipView: View {
    @Binding var onboardingStage: Int
    @AppStorage(wrappedValue: true, "doOnboarding") var doOnboarding
    @State private var selectedRelationship: Relationship? = nil

    enum Relationship: String, CaseIterable {
        case single = "Single"
        case complicated = "It is complicated"
        case relationship = "In a relationship"
        case engaged = "Engaged"
        case married = "Married"
    }

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 100)
                VStack{
                    VStack(spacing: 12) {
                        QuestionText(text: "What is your relationship status?")
                            .padding(.bottom, 12)
                        ForEach(Relationship.allCases, id: \.self) { status in
                            Button {
                                selectedRelationship = status
                                PersistentDataManager.shared.user.relationship = selectedRelationship!.rawValue
                                // Save the user to local
                                PersistentDataManager.shared.saveUserToLocal()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    doOnboarding = false // this dismisses the view
                                    print("onboardingStage: \(onboardingStage)")
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selectedRelationship == status ? Color.text : .clear)
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
                                            .foregroundColor(selectedRelationship == status ? Color.black : .text)
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
        .padding(.horizontal, 16)
    }
}



struct GetUserRelationshipView_Previews: PreviewProvider {
    @State static var onboardingStage = 4
    static var previews: some View {
        GetUserRelationshipView(onboardingStage: $onboardingStage)
            .environmentObject(MockUserOO())
            .preferredColorScheme(.dark)
    }
}
