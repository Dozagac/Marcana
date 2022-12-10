//
//  SingleReaderView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 27/11/2022.
//

import SwiftUI
import OpenAISwift

struct SingleReaderView: View {
    let openAPI = OpenAISwift(authToken: "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")
    @EnvironmentObject var deck: Deck
    @State private var showingSheet = false
    @State private var cardOpen = false
    @State private var isLoading = false
    @State private var shownCard: Card = Deck().allCards.randomElement() ?? Deck().allCards[0]

    @State var response = "... Reading your fortune ..."

    var body: some View {

        ZStack {
            BackgroundView()

            VStack {
                //MARK: Flippin Card
                Image(cardOpen ? shownCard.image : "facedownCard")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: Color.gray, radius: 10, x: 0, y: 0)
                    .onTapGesture {
                    withAnimation(.linear(duration: 1.0)) {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        shownCard = Deck().allCards[1]
                        if cardOpen { // show card explanation on tap if card is open
                            self.showingSheet.toggle()
                        } else {
                            sendAPIRequest(
                                AIPrompt: prepareAPIPrompt(
                                    card: shownCard,
                                    question: "How is my love life looking in the future?"))
//                            response = "DUMMY RESPONSE LALALA"
                        }
                        // open the card if the card was not open
                        self.cardOpen = true
                    }
                }
                    .sheet(isPresented: $showingSheet) { CardDetailView(card: shownCard) }
                    .navigationTitle("Fortune AI")
                    .navigationBarTitleDisplayMode(.inline)
                    .padding(.bottom, 25)

                //MARK: Fortune Text Scroll View
                if cardOpen {
                    withAnimation(.linear(duration: 3.0)) {

                        VStack {
                            //MARK: Card NAme
                            Text(shownCard.name)
                                .padding(8)
                                .foregroundStyle(.primary)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)

                            //MARK: Fortune Result
                            ScrollView {
                                Text(response)
                            }
                                .foregroundStyle(.primary)
                                .padding(20)
                                .background(.ultraThinMaterial)
                                .cornerRadius(20, corners: [.topLeft, .topRight])
                        }
                    }
                }
            }
        }
    }



    func prepareAPIPrompt(card: Card, question: String) -> String {
        print("PROMPT SENT TO AI")
        let AIprompt = """
        Act like a mystical fortune teller that specializes in Tarot card readings.
        Try to revoke excitement and curiosity from the reader, try to be entertaining.
        Minimum 200 words.

        I will tell you a card and a paired question and you will tell my fortune using that card as a basis for your tarot reading. I will also provide some keywords to set the context for your answer. Preface your fortune reading with a brief comment on the card's meaning in the context of my question.
        
        For example:
        My card is \(card.name).
        Keywords: \(card.interpretation.split(separator: "\nReversed")[0])
        My question is: \(question)
        """

        return AIprompt
    }

    func sendAPIRequest(AIPrompt: String) {
        // There are mode API parameters but this library doesnt accept them yet
        // https://beta.openai.com/docs/api-reference/completions/create
        openAPI.sendCompletion(with: AIPrompt,
                               model: .gpt3(.davinci),
                               maxTokens: 16) { result in

            switch result {
            case .success(let response):
                let responseText = response.choices.first?.text ?? "No Fortune, Sorry."
                self.response = responseText
            case .failure(let error):
                print(error)
                self.response = error.localizedDescription
            }
        }
    }


    let dummyFortune = """
        The figure calls for no special description the face is rather dark, suggesting also courage, but somewhat lethargic in tendency. The bull's head should be noted as a recurrent symbol on the throne. The sign of this suit is represented throughout as engraved or blazoned with the pentagram, typifying the correspondence of the four elements in human nature and that by which they may be governed. In many old Tarot packs this suit stood for current coin, money, deniers. I have not invented the substitution of pentacles and I have no special cause to sustain in respect of the alternative. But the consensus of divinatory meanings is on the side of some change, because the cards do not happen to deal especially with questions of money.
        """
}



struct SingleReaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SingleReaderView()
                .environmentObject(Deck())
        }
    }
}
