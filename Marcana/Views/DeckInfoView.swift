//
//  DeckInfoView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 27/11/2022.
//

import SwiftUI

struct DeckInfoView: View {
    @EnvironmentObject var deck: Deck
    @State private var showingSheet = false
    @State var sheetCard: Card? = nil

    var body: some View {
        List {
            Section("Major Arcana") {
                ForEach(deck.majorCards) { card in
                    ListItem(card: card)
                        .onTapGesture {
                        self.sheetCard = card
                        self.showingSheet.toggle()
                    }
                }
            }
            Section("Minor Arcana") {
                ForEach(deck.minorCards, id: \.name) { card in
                    NavigationLink(destination: CardDetailView(card: card), label: {
                        ListItem(card: card)
                    })
                }
            }
        }
            .sheet(item: self.$sheetCard) {item in
                CardDetailView(card: item)
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
                Text(card.suite.name.capitalized)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
            .navigationTitle("Cards")
            .navigationBarTitleDisplayMode(.large)
    }
}

struct DeckInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DeckInfoView()
            .environmentObject(Deck())
    }
}
