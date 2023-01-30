//
//  SingleReaderView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 27/11/2022.
//

import SwiftUI
import AnimateText

struct SelectThreeCardsView: View {
    @StateObject var fortuneRequester: FortuneRequester
    var fortuneQuestion: String
    
    // Manually initialize the StateObject with parameter
    // https://stackoverflow.com/questions/62635914/initialize-stateobject-with-a-parameter-in-swiftui
    init(fortuneQuestion: String = "") {
        self._fortuneRequester = StateObject(wrappedValue: FortuneRequester(fortuneQuestion: fortuneQuestion))
        self.fortuneQuestion = fortuneQuestion
    }

    var deck = Deck()

    @State private var animateViews = false
    @State var showingFortuneSheet = false
    @State private var card1Open = false
    @State private var card2Open = false
    @State private var card3Open = false
    
    @State private var shownCards: [Card] = [
        Deck().allCards.randomElement()!,
        Deck().allCards.randomElement()!,
        Deck().allCards.randomElement()!
    ]

    private var canContinue: Bool {
        card1Open && card2Open && card3Open
    }

    private var allCardsClosed: Bool {
        card1Open || card2Open || card3Open
    }

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(spacing: 24) {
                Spacer()
                    .frame(height: 100)

                //MARK: - Cards
                HStack(alignment: .top, spacing: 24) {
                    ClosedCardView(
                        cardOpen: $card1Open,
                        shownCard: $shownCards[0],
                        positionText: "Past")
                        .scaleEffect(allCardsClosed ? 1 : animateViews ? 1.05 : 1)
                        .shadow(color: allCardsClosed ? .gray : animateViews ? .white : .gray, radius: 8, x: 0, y: 0)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateViews)

                    ClosedCardView(
                        cardOpen: $card2Open,
                        shownCard: $shownCards[1],
                        positionText: "Present")
                        .offset(y: -50)
                        .shadow(color: Color.gray, radius: 8, x: 0, y: 0)

                    ClosedCardView(
                        cardOpen: $card3Open,
                        shownCard: $shownCards[2],
                        positionText: "Future")
                        .shadow(color: Color.gray, radius: 8, x: 0, y: 0)
                }
                    .padding(.horizontal, 24)
                    .fullScreenCover(isPresented: $showingFortuneSheet) {
                    FortuneView(fortuneRequester: fortuneRequester)
                }


                HStack{
                    Image(systemName: "hand.tap.fill")
                        .font(.largeFont2)
                    Text("Tap to reveal cards")
                        .font(.largeFont3)
                }
                .foregroundColor(.text)
                .padding(.top, 70)
                .opacity(allCardsClosed ? 0 : animateViews ? 1 : 0)
                .offset(x: 0, y: allCardsClosed ? 100 : animateViews ? 0 : 150)

                Spacer()
                    .frame(minHeight: 200)
            }
                .onAppear {
                withAnimation(Animation.easeOut(duration: 1.5).delay(0.5)) {
                    animateViews.toggle()
                }
            }

            //MARK: - Continue Button
            VStack {
                Spacer()
                Spacer()
                Text("Read Fortune")
                    .modifier(OnboardingContinueButtonModifier(canContinue: canContinue))
                    .onTapGesture {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    fortuneRequester.sendAPIRequest(
                        AIPrompt: fortuneRequester.prepareAPIPrompt(chosenCards: shownCards, fortuneQuestion: fortuneQuestion)
                    )
                    fortuneRequester.waitingForAPIResponse = true
                    showingFortuneSheet = true
                }
                Spacer()
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
//                .shadow(color: Color.gray, radius: 8, x: 0, y: 0)
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
                            .font(.mediumLargeFont)
                            .foregroundColor(.text)
                            .cornerRadius(8)
                            .frame(width: 98, height: 24)
                            .minimumScaleFactor(0.2)
                            .lineLimit(2)
                    }
                }
            }

            Text(positionText)
                .font(.mediumLargeFont)
                .frame(width: 98, height: 24)
                .foregroundColor(cardOpen ? Color.gray : Color.text)
                .padding(.vertical, 0) // to narrow down the default spacing for Text, if needed
        }
    }
}


struct SelectThreeCardsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SelectThreeCardsView(fortuneQuestion: "This is a dummy question")
                .environmentObject(MockUserOO())
                .preferredColorScheme(.dark)
        }
    }
}
