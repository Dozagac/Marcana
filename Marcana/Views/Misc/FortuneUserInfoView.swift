//
//  UserInfoView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 01/02/2023.
//

import SwiftUI

struct FortuneUserInfoView: View {
    var fortuneReading: FortuneReading
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                Text("\(fortuneReading.userName) (\(fortuneReading.userGender))")
            }
            HStack(spacing: 12) {
                Image(systemName: "birthday.cake.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                Text(Date(timeIntervalSince1970: fortuneReading.userBirthday).formatted(date: .abbreviated, time: .omitted))
            }
            HStack(spacing: 12) {
                Image(systemName: "briefcase.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                Text(fortuneReading.userOccupation)
            }
            HStack(spacing: 12) {
                Image(systemName: "heart.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                Text(fortuneReading.userRelationship)
            }

            
            Divider()
                .padding(12)
            
            HStack(spacing: 12) {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                Text(fortuneReading.fortuneQuestion)
                    .font(.customFontBody)
                    .lineLimit(nil)
            }

        }
        .font(.customFontTitle3)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(24)
        .modifier(customNavBackModifier())
    }
        
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        FortuneUserInfoView(fortuneReading: FortuneHistory.dummyFortunes[0])
            .preferredColorScheme(.dark)
    }
}
