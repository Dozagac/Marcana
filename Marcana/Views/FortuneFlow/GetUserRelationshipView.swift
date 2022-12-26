//
//  GetUserRelationshipView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

struct GetUserRelationshipView: View {
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
            BackgroundView()
            VStack(spacing: 12) {
                QuestionText(text: "What is your relationship status?")
                    .padding(12) // 10 + 10 with VStack spacing
                ForEach(Relationship.allCases, id: \.self) { status in
                    Button(action: {
                        self.selectedRelationship = status }
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
                        .overlay(RoundedRectangle(cornerRadius: 10
                    ).stroke(Color.text, lineWidth: 1).background(.clear))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)

            //MARK: Continue Button
            if selectedRelationship != nil {
                VStack {
                    Spacer()
                    NavigationLink(destination: GetUserQuestionView()) {
                        Text("Continue")
                            .modifier(ContinueNavLinkModifier())
                    }
                }
            }
        }
    }
}



struct GetUserRelationshipView_Previews: PreviewProvider {
    static var previews: some View {
        GetUserRelationshipView()
    }
}
