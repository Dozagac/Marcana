//
//  SingleReaderView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 27/11/2022.
//

import SwiftUI
import AnimateText

struct SelectThreeCardsView: View {
    @Binding var showingFortuneSheet: Bool
    @StateObject var fortuneRequester: FortuneRequester
    var fortuneQuestion: String
    let deck = Deck()

    // Manually initialize the StateObject with parameter
    // https://stackoverflow.com/questions/62635914/initialize-stateobject-with-a-parameter-in-swiftui
    init(showingFortuneSheet: Binding<Bool>, fortuneQuestion: String = "") {
        let randomFortuneCards = deck.DrawCards(n: 3)

        self._fortuneRequester = StateObject(wrappedValue: FortuneRequester(
            fortuneQuestion: fortuneQuestion,
            fortuneType: .with3cards,
            fortuneCards: randomFortuneCards
        )
        )
        self.fortuneQuestion = fortuneQuestion
        self._showingFortuneSheet = showingFortuneSheet
        self.fortuneCards = randomFortuneCards
    }

    @State private var continueIsPushed = false // triggers navigation view

    @State private var animateViews = false

    @State private var card1Open = false
    @State private var card2Open = false
    @State private var card3Open = false

    private var fortuneCards: [DrawnCard]

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

                //MARK: - Cards to pick
                HStack(alignment: .top, spacing: 24) {
                    ClosedCardView(
                        cardOpen: $card1Open,
                        shownCard: fortuneCards[0],
                        positionText: "Past")
                        .scaleEffect(allCardsClosed ? 1 : animateViews ? 1.05 : 1)
                        .shadow(color: allCardsClosed ? .gray : animateViews ? .white : .gray, radius: 10, x: 0, y: 0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateViews)

                    ClosedCardView(
                        cardOpen: $card2Open,
                        shownCard: fortuneCards[1],
                        positionText: "Present")
                        .offset(y: -50)
                        .shadow(color: Color.gray, radius: 8, x: 0, y: 0)

                    ClosedCardView(
                        cardOpen: $card3Open,
                        shownCard: fortuneCards[2],
                        positionText: "Future")
                        .shadow(color: Color.gray, radius: 8, x: 0, y: 0)
                }
                    .padding(.horizontal, 24)

                // MARK: Activation Prompt for user
                HStack {
                    Image(systemName: "hand.tap.fill")
                        .font(.customFontTitle2)
                    Text("Tap the cards")
                        .font(.customFontTitle3)
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
                Button {
                    continueIsPushed.toggle()
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    fortuneRequester.sendAPIRequest(
                        AIPrompt: fortuneRequester.prepareAPIPrompt3Cards()
                    )
                    fortuneRequester.waitingForAPIResponse = true
                } label: {
                    Text("Read Fortune")
                        .modifier(GetUserInfoContinueButtonModifier(canContinue: canContinue))
                }
                    .navigationDestination(isPresented: $continueIsPushed) {
                    FortuneLoadingView(showingFortuneSheet: $showingFortuneSheet, fortuneRequester: fortuneRequester)
                }
                Spacer()
            }
                .opacity(canContinue && !fortuneRequester.waitingForAPIResponse ? 1 : 0)
                .animation(.easeIn(duration: 0.3), value: canContinue)

        }
            .modifier(customNavBackModifier())
            .navigationTitle("Reveal Your Cards")
    }
}


struct ClosedCardView: View {
    var width: CGFloat = 100
    var height: CGFloat = 150

    @State private var showingSheet = false
    @Binding var cardOpen: Bool
    var shownCard: DrawnCard

    let positionText: String

    var body: some View {
        VStack(spacing: 12) {
            //MARK: Flipping Card
            Image(cardOpen ? shownCard.Card.image : "facedownCard")
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height)
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
                CardDetailView(card: shownCard.Card)
            }

            //MARK: Revealed Card Text
            if cardOpen {
                withAnimation(.linear(duration: 1.0)) {
                    VStack(spacing: 0) {
                        //MARK: Card NAme
                        Text(shownCard.Card.name)
                            .font(.customFontHeadline)
                            .foregroundColor(.text)
                            .cornerRadius(8)
                            .frame(width: 98, height: 24)
                            .minimumScaleFactor(0.2)
                            .lineLimit(2)
                    }
                }
            }

            Text(positionText)
                .font(.customFontHeadline)
                .frame(width: 98, height: 24)
                .foregroundColor(cardOpen ? Color.gray : Color.text)
                .padding(.vertical, 0) // to narrow down the default spacing for Text, if needed
        }
    }
}


struct SelectThreeCardsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SelectThreeCardsView(showingFortuneSheet: .constant(true),
                                 fortuneQuestion: "This is a dummy question")
                .environmentObject(MockUserOO())
                .preferredColorScheme(.dark)
        }
    }
}
