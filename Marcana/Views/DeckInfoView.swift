//
//  DeckInfoView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 27/11/2022.
//

import SwiftUI

struct DeckInfoView: View {
    @EnvironmentObject var deck: Deck

    var body: some View {
        List(deck.allCards, id: \.name) { card in
            NavigationLink(destination: CardDetailView(card: card), label: {
                ListItem(card: card)
            })
        }
    }
}


struct ListItem: View {
    var card: Card

    var body: some View {
        HStack {
            Image(card.image)
                .resizable()
                .scaledToFit()
                .frame(height: 90.0)
                .cornerRadius(8)
                .shadow(radius: 3)

            Spacer().frame(width: 16)

            VStack(alignment: .leading) {
                Text(card.name)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                Spacer().frame(height: 8)
                Text(card.suite.capitalized)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .navigationBarTitle("Cards", displayMode: .large)
    }
}

struct DeckInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DeckInfoView()
            .environmentObject(Deck())
    }
}
