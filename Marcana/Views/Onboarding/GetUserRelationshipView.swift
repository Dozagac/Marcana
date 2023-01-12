//
//  GetUserRelationshipView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

// Last step of onboarding
struct GetUserRelationshipView: View {
    @AppStorage(wrappedValue: true, "doOnboarding") var doOnboarding
    @EnvironmentObject var newUser: UserOO
    @State private var selectedRelationship: Relationship? = nil
    private var canContinue: Bool {
        selectedRelationship != nil
    }

    enum Relationship: String, CaseIterable {
        case single = "Single"
        case complicated = "It is complicated"
        case relationship = "In a relationship"
        case engaged = "Engaged"
        case married = "Married"
    }

    var body: some View {
        ZStack {
            OnboardingBackgroundView()
            VStack(spacing: 12) {
                QuestionText(text: "What is your relationship status?")
                    .padding(12)
                ForEach(Relationship.allCases, id: \.self) { status in
                    NavigationLink(destination: MainView()
                    // navlink animation?
                    ) {
                        HStack() {
                            Text(status.rawValue)
                                .padding(.leading, 16)
                            Spacer()
                        }
                    }
                        .frame(width: 350, height: 50)
                        .background(self.selectedRelationship == status ? Color.foreground : Color.clear)
                        .foregroundColor(Color.text)
                        .simultaneousGesture(TapGesture().onEnded {
                        self.selectedRelationship = status
                        newUser.relationship = selectedRelationship?.rawValue ?? Relationship.single.rawValue
                        doOnboarding = false
                        // SAVE THE USER SOMEHOW
                        //users.users.append(newUser)
                    })
                        .overlay(RoundedRectangle(cornerRadius: 10
                    ).stroke(Color.text, lineWidth: 1).background(.clear))
                }
            }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
        }
            .modifier(OnboardingCustomNavBack())
    }
}



struct GetUserRelationshipView_Previews: PreviewProvider {
    static var previews: some View {
        GetUserRelationshipView()
            .environmentObject(MockUserOO())
    }
}
