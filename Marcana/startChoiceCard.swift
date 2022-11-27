//
//  StartChoiceCard.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//
// https://ix76y.medium.com/creating-a-image-card-in-swift-ui-beginner-tutorial-2881b4420ea3

import SwiftUI

struct startChoiceCard: View {

    let buttonInfo: startButton

    var body: some View {
        VStack(alignment: .leading) {
            Image(buttonInfo.imageName)
                .resizable()
                .frame(width: 200, height: 200)
                .scaledToFit()

            cardText
                .padding(.horizontal, 8)
        }
        .frame(width: 200)
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 24.0))
        .shadow(color: .cyan, radius: 8)
    }

    var cardText: some View {
        VStack (alignment: .leading) {
            Text(buttonInfo.title)
                .font(.headline)
                .foregroundColor(.primary)
                .minimumScaleFactor(0.5)

            Text(buttonInfo.subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }.padding(.bottom, 12)
    }
}



struct StartChoiceCard_Previews: PreviewProvider {
    static var previews: some View {
        startChoiceCard(buttonInfo: startButton.example)
    }
}
