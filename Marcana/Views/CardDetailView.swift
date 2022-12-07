//
//  CardDetailView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 27/11/2022.
//

import SwiftUI

struct CardDetailView: View {
    var card: Card

    var body: some View {
        ScrollView {
            // MARK: Card Image
            CardDisplayImageView(image: card.image)
                .shadow(color: Color.gray, radius: 4, x: 0, y: 4)
                .padding(.top, 20)


            // MARK: Title
            Text(card.name)
                .font(.title)
                .padding()

            // MARK: Card keywords, interpretation
            Text(card.interpretation)
                .font(.footnote)
                .italic()
                .padding(.horizontal, 20)
                .padding(.bottom, 10)

            // MARK: Description
            Text(card.description)
                .padding(.horizontal, 20)
                .lineLimit(nil)
        }
            .onAppear {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
}


struct CardDisplayImageView: View {
    var image: String

    var body: some View {
        Image(image)
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 300)
    }
}

struct CardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CardDetailView(card: Deck().allCards[0])
    }
}
