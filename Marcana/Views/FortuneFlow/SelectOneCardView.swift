//
//  SelectOneCardView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 30/01/2023.
//

import SwiftUI
import AnimateText

struct SelectOneCardView: View {
    @Binding var showingFortuneSheet: Bool
    @StateObject var fortuneRequester: FortuneRequester
    var fortuneQuestion: String
    var deck = Deck()

    // Manually initialize the StateObject with parameter
    // https://stackoverflow.com/questions/62635914/initialize-stateobject-with-a-parameter-in-swiftui
    init(showingFortuneSheet: Binding<Bool>, fortuneQuestion: String = "") {
        let randomFortuneCards = deck.DrawCards(n: 1)

        self._fortuneRequester = StateObject(wrappedValue: FortuneRequester(
            fortuneQuestion: fortuneQuestion,
            fortuneType: .with1card,
            fortuneCards: randomFortuneCards
        )
        )
        self.fortuneQuestion = fortuneQuestion
        self._showingFortuneSheet = showingFortuneSheet
        self.fortuneCards = randomFortuneCards
    }

    @State private var continueIsPushed = false // triggers navigation view

    @State private var animateViews = false

    @State private var cardOpen = false

    private var fortuneCards: [DrawnCard]

    private var canContinue: Bool {
        cardOpen
    }

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(spacing: 24) {
                Spacer()
                    .frame(height: 100)

                //MARK: - Card to pick
                ClosedCardView(
                    width: 200,
                    height: 300,
                    cardOpen: $cardOpen,
                    shownCard: fortuneCards[0],
                    positionText: "")
                    .scaleEffect(cardOpen ? 1 : animateViews ? 1.05 : 1)
                    .shadow(color: cardOpen ? .gray : animateViews ? .white : .gray, radius: 15, x: 0, y: 0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateViews)

                // MARK: Activation Prompt for user
                HStack {
                    Image(systemName: "hand.tap.fill")
                        .font(.customFontTitle2)
                    Text("Tap the card")
                        .font(.customFontTitle3)
                }
                    .foregroundColor(.text)
                    .padding(.top, 70)
                    .opacity(cardOpen ? 0 : animateViews ? 1 : 0)
                    .offset(x: 0, y: cardOpen ? 100 : animateViews ? 0 : 150)

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
                        AIPrompt: fortuneRequester.prepareAPIPrompt1Card()
                    )
                    fortuneRequester.waitingForAPIResponse = true
                } label: {
                    Text("Read Fortune")
                        .modifier(GetUserInfoContinueButtonModifier(canContinue: canContinue))
                }
                    .navigationDestination(isPresented: $continueIsPushed, destination: {
                    FortuneLoadingView(
                        showingFortuneSheet: $showingFortuneSheet,
                        fortuneRequester: fortuneRequester
                    )
                })
                Spacer()
            }
                .opacity(canContinue && !fortuneRequester.waitingForAPIResponse ? 1 : 0)
                .animation(.easeIn(duration: 0.3), value: canContinue)

        }
            .modifier(customNavBackModifier())
            .navigationTitle("Reveal Your Cards")
    }
}



struct SelectOneCardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SelectOneCardView(showingFortuneSheet: .constant(true),
                              fortuneQuestion: "This is a dummy question")
                .environmentObject(MockUserOO())
                .preferredColorScheme(.dark)
        }
    }
}

