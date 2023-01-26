//
//  SingleReaderView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 27/11/2022.
//

import SwiftUI
import OpenAISwift
import AnimateText

struct ThreeCardSelectionView: View {
    let openAPI = OpenAISwift(authToken: "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")

    var chosenQuestion: String = ""
    var deck = Deck()

    @State var waitingForAPIResponse = false
    @State var showingFortuneSheet = false

    @State private var card1Open = false
    @State private var card2Open = false
    @State private var card3Open = false
    @State private var response = ""
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
            
            VStack(spacing: 24) {
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 40) {
                        Spacer()
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
                        Spacer()
                    }
                        .padding(25)
                }
                    .fullScreenCover(isPresented: $showingFortuneSheet) {
                    FortuneView(response: $response, waitingForAPIResponse: $waitingForAPIResponse)
                }
                Spacer()
                Spacer()
            }

            //MARK: Continue Button
            VStack {
                Spacer()
                Text("Read Fortune")
                    .modifier(OnboardingContinueButtonModifier(canContinue: canContinue))
                    .onTapGesture {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    sendAPIRequest(
                        AIPrompt: prepareAPIPrompt(chosenCards: shownCards, chosenQuestion: chosenQuestion)
                    )
                    waitingForAPIResponse = true
                    showingFortuneSheet = true
                }
            }
                .opacity(canContinue && !showingFortuneSheet ? 1 : 0)
                .animation(.easeIn(duration: 0.3), value: canContinue)

        }
            .modifier(customNavBackModifier())
            .padding()
            .navigationTitle("Reveal Your Cards")
    }

    func prepareAPIPrompt(chosenCards: [Card], chosenQuestion: String) -> String {
        print("PROMPT SENT TO AI")
        let user = PersistentDataManager.shared.user

        let AIprompt = """
        Act as a mystical fortune teller named Aurelion that uses tarot cards to tell a personalized fortune.
        I will give you general information about myself and 3 tarot cards I picked.
        Try to use the general information I give about myself in the answer you give.
        Use the cards I chose to make interpretations and create fortune tellings for my past, present and future respectively.
        I will also ask a personal question that you should provide a fortune reading for.
        As a part of your fortune reading, ask at least one question that will make the reader curious.
        Don't just tell the meaning of the cards, make it personal to the reader.
        Give answers that provoke curiosity, wonder and mystery.
        Provide at least one paragraph per introduction ,past, present and future card interpretation.
        Provide the answer in the tone of a mystical and spiritually attuned fortune teller.
        Break your answer into paragraphs.

        Here is my personal information:
        Name: \(user.name)
        Birthday: \(user.birthday.formatted(date: .abbreviated, time: .omitted))
        Gender: \(user.gender)
        Occupation: \(user.occupation)
        Relationship Status: \(user.relationship)

        These are the tarot cards that I picked that represent my past, present and future:

        Past: \(chosenCards[0].name)
        Current: \(chosenCards[1].name)
        Future: \(chosenCards[2].name)

        My personal question:
        \(chosenQuestion)?
        """

        return AIprompt
    }


    func sendAPIRequest(AIPrompt: String) {
        // There are mode API parameters but this library doesnt accept them yet
        // https://beta.openai.com/docs/api-reference/completions/create
        openAPI.sendCompletion(with: AIPrompt,
                               model: .gpt3(.davinci),
                               maxTokens: 500) { result in

            switch result {
            case .success(let response):
                let responseText = response.choices.first?.text ?? "Sorry, something went wrong."
                self.response = responseText.trimmingCharacters(in: .whitespacesAndNewlines)
                waitingForAPIResponse = false
            case .failure(let error):
                print(error)
                self.response = error.localizedDescription
            }
        }
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
                .frame(width: 200, height: 300)
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
                CardDetailView(showingSheet: $showingSheet, card: shownCard)
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
