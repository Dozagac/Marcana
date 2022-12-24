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
            VStack {
                QuestionText(text: "What is your relationship status?")
                    .padding(.bottom, 20)
                ForEach(Relationship.allCases, id: \.self) { status in
                    Button(action: {
                        self.selectedRelationship = status }
                    ) {
                        HStack() {
                            Text(status.rawValue)
                                .padding(.leading)
                            Spacer()
                        }
                    }
                        .frame(width: 200, height: 50)
                        .background(self.selectedRelationship == status ? Color.foreground : Color.clear)
                        .foregroundColor(Color.text)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10
                    ).stroke(Color.text, lineWidth: 1).background(.clear))
                }
            }

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
