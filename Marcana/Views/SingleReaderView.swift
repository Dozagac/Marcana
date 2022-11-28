//
//  SingleReaderView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 27/11/2022.
//

import SwiftUI

struct SingleReaderView: View {
    @EnvironmentObject var deck: Deck
    
    var body: some View {
        CardDisplayImageView(image: deck.allCards.randomElement()?.image ?? "maj_00")
            
    }
    
}

struct SingleReaderView_Previews: PreviewProvider {
    static var previews: some View {
        SingleReaderView()
            .environmentObject(Deck())
    }
}
