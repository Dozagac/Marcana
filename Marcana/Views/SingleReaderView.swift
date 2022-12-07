//
//  SingleReaderView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 27/11/2022.
//

import SwiftUI

struct SingleReaderView: View {
    @EnvironmentObject var deck: Deck
    @State private var showingSheet = false
    @State var shownCard: Card = Deck().allCards.randomElement() ?? Deck().allCards[0]

    var body: some View {

        HStack {
            // MARK: Card Back
            Image("facedownCard")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .shadow(color: Color.gray, radius: 10, x: 0, y: 0)
            

            // MARK: Card Front
            CardDisplayImageView(image: shownCard.image)
                .onTapGesture { self.showingSheet.toggle() }
                .sheet(isPresented: $showingSheet) { CardDetailView(card: shownCard) }

        }
    
            .navigationTitle("Single Card")
    }
}



struct SingleReaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SingleReaderView()
                .environmentObject(Deck())
        }
    }
}
