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
            Image(card.image)
                .resizable()
                .scaledToFill()
                .frame(width: 300)

            Text(card.interpretation)
                .font(.footnote)
                .italic()
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            
            Text(card.description)
                .padding(.horizontal, 20)
                .lineLimit(nil)
        }
        .navigationBarTitle(card.name, displayMode: .inline)
    }
}

struct CardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CardDetailView(card: Deck().allCards[0])
    }
}
