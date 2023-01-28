//
//  SingleReaderView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 27/11/2022.
//

import SwiftUI
import AnimateText

struct ThreeCardSelectionView: View {
    @StateObject var fortuneRequester = FortuneRequester()

    var chosenQuestion: String = ""
    var deck = Deck()

//    @State var waitingForAPIResponse = false
    @State var showingFortuneSheet = false

    @State private var card1Open = false
    @State private var card2Open = false
    @State private var card3Open = false
//        """
//        The figure calls for no special description the face is rather dark, suggesting also courage, but somewhat lethargic in tendency. The bull's head should be noted as a recurrent symbol on the throne. The sign of this suit is represented throughout as engraved or blazoned with the pentagram, typifying the correspondence of the four elements in human nature and that by which they may be governed. In many old Tarot packs this suit stood for current coin, money, deniers. I have not invented the substitution of pentacles and I have no special cause to sustain in respect of the alternative. But the consensus of divinatory meanings is on the side of some change, because the cards do not happen to deal especially with questions of money.
//        """


    @State private var shownCards: [Card] = [
        Deck().allCards.randomElement()!,
        Deck().allCards.randomElement()!,
        Deck().allCards.randomElement()!
    ]

    private var canContinue: Bool {
        card1Open && card2Open && card3Open
    }
    



    var body: some View {
        ZStack {
            BackgroundView()

            VStack(spacing: 24) {
                Spacer()
                    .frame(height: 100)
                
                HStack(spacing: 24) {
                    ClosedCardView(
                        cardOpen: $card1Open,
                        shownCard: $shownCards[0],
                        positionText: "Past")

                    ClosedCardView(
                        cardOpen: $card2Open,
                        shownCard: $shownCards[1],
                        positionText: "Present")

                    ClosedCardView(
                        cardOpen: $card3Open,
                        shownCard: $shownCards[2],
                        positionText: "Future")
                }
                    .padding(.horizontal, 24)
                    .fullScreenCover(isPresented: $showingFortuneSheet) {
                        FortuneView(fortuneRequester: fortuneRequester)
                }
                Spacer()
            }

            //MARK: Continue Button
            VStack {
                Spacer()
                Text("Read Fortune")
                    .modifier(OnboardingContinueButtonModifier(canContinue: canContinue))
                    .onTapGesture {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    fortuneRequester.sendAPIRequest(
                        AIPrompt: fortuneRequester.prepareAPIPrompt(chosenCards: shownCards, chosenQuestion: chosenQuestion)
                    )
                    fortuneRequester.waitingForAPIResponse = true
                    showingFortuneSheet = true
                }
            }
                .opacity(canContinue && !showingFortuneSheet ? 1 : 0)
                .animation(.easeIn(duration: 0.3), value: canContinue)

        }
            .modifier(customNavBackModifier())
            .navigationTitle("Reveal Your Cards")
    }
}


struct ClosedCardView: View {
    @State private var showingSheet = false
    @Binding var cardOpen: Bool
    @Binding var shownCard: Card

    let positionText: String

    var body: some View {
        VStack(spacing: 12) {
            //MARK: Flipping Card
            Image(cardOpen ? shownCard.image : "facedownCard")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: Color.gray, radius: 8, x: 0, y: 0)
                .onTapGesture {
                withAnimation(.easeIn(duration: 1.0)) {
                    // Haptic feedback
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    // show card explanation on tap if card is open
                    if cardOpen {
                        self.showingSheet.toggle()
                    } else {
                        // open the card if the card was not open
                        self.cardOpen = true
                    }
                }
            }
                .sheet(isPresented: $showingSheet) {
                CardDetailView(card: shownCard)
            }

            //MARK: Revealed Card Text
            if cardOpen {
                withAnimation(.linear(duration: 1.0)) {
                    VStack(spacing: 0) {
                        //MARK: Card NAme
                        Text(shownCard.name)
                            .foregroundColor(.text)
                            .cornerRadius(8)
                            .frame(width: 98, height: 24)
                            .minimumScaleFactor(0.2)
                            .lineLimit(1)
                    }
                }
            }

            Text(positionText)
                .frame(width: 98, height: 24)
                .foregroundColor(cardOpen ? Color.gray : Color.text)
                .padding(-8) // to narrow down the default spacing for Text
        }
    }
}


struct ThreeCardSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ThreeCardSelectionView()
                .environmentObject(MockUserOO())
                .preferredColorScheme(.dark)
        }
    }
}
