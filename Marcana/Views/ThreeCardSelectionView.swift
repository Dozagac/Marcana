//
//  SingleReaderView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 27/11/2022.
//

import SwiftUI
import OpenAISwift

struct ThreeCardSelectionView: View {
    let openAPI = OpenAISwift(authToken: "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")

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.lightText]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.lightText]
    }

    @EnvironmentObject var deck: Deck

    @State var card1Open = false
    @State var card2Open = false
    @State var card3Open = false
    @State var response = "... Reading your fortune ..."

    var body: some View {

        ZStack {
            BackgroundView()

            HStack {
                VStack {
                    ClosedCardView(cardOpen: $card1Open, positionText: "Past")
                }
                VStack {
                    ClosedCardView(cardOpen: $card2Open, positionText: "Present")
                }
                VStack {
                    ClosedCardView(cardOpen: $card3Open, positionText: "Future")
                }
            }

            if card1Open && card2Open && card3Open {
                VStack {
                    Spacer()
                    NavigationLink(destination: Text("FORTUNE TIME WOO")) {
                        Text("Continue")
                            .modifier(ContinueNavLinkModifier())
                    }
                }
            }
        }
            .navigationTitle("Reveal Your Cards")
    }

    func prepareAPIPrompt(card: Card, question: String) -> String {
        print("PROMPT SENT TO AI")
        let name = "Deniz"
        let age = 29
        let gender = "Male"
        let sexualOrientation = "Straight"
        let employment = "Aspiring Entrepreneur"
        let relationship = "In a relationship"

        let cardPast = "The fool" // TODO add reversed, upright info
        let cardPresent = "The emperor"
        let cardFuture = "6 of Swords"

        let personalQuestion = "Does Hugo love me?"

        let AIprompt = """
        Act as a mystical fortune teller named Aurelion that uses tarot cards to tell a personalized fortune.
        I will give you general information about myself and 3 tarot cards that I picked that are used to create fortune readings for my past, present and future respectively.
        I will also ask a personal question that you should provide a fortune reading for.
        Give answers that provoke curiousity, wonder and mystery.
        As a part of your fortune reading, ask least one question that will nudge the reader to think about their personal lives.
        Try to make it less generic and more personal so the reader can get surprised.
        Provide at least one paragraph per past, present and future readings.
        Provide the answer in the tone of a mystical and spiritually attuned fortune teller.

        Here is my personal information:
        Name: \(name)
        Age: \(age)
        Gender: \(gender)
        Sexual orientation: \(sexualOrientation)
        Employment Status: \(employment)
        Relationship Status: \(relationship)

        These are the cards that I picked that represent my past, present and future:

        Past: \(cardPast)
        Current: \(cardPresent)
        Future: \(cardFuture)

        My personal question:
        \(personalQuestion)

        
        For example:
        My card is \(card.name).
        Keywords: \(card.interpretation.split(separator: "\nReversed")[0])
        My question is: \(question)
        """

        return AIprompt
    }

    //sendAPIRequest(
    //    AIPrompt: prepareAPIPrompt(
    //        card: shownCard,
    //        question: "How is my love life looking in the future?"))


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


struct ClosedCardView: View {
    @State private var showingSheet = false
    @Binding var cardOpen: Bool
    @State private var shownCard: Card = Deck().allCards.randomElement() ?? Deck().allCards[0]

    let positionText: String

    var body: some View {
        VStack {
            //MARK: Flipping Card
            Image(cardOpen ? shownCard.image : "facedownCard")
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: Color.gray, radius: 10, x: 0, y: 0)
                .onTapGesture {
                withAnimation(.linear(duration: 1.0)) {
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
                .sheet(isPresented: $showingSheet) { CardDetailView(card: shownCard) }
                .padding(.bottom, 10)

            //MARK: Revealed Card Text
            if cardOpen {
                withAnimation(.linear(duration: 1.0)) {
                    VStack(spacing: 8) {
                        //MARK: Card NAme
                        Text(shownCard.name)
                            .foregroundColor(.text)
                            .cornerRadius(8)
                            .frame(width: 120, height: 20)
                            .minimumScaleFactor(0.2)
                            .lineLimit(1)
                    }
                }
            }

            Text(positionText)
                .foregroundColor(cardOpen ? Color.gray : Color.text)
        }
    }
}


//MARK: Custom modifier for the continue navigation button
struct ContinueNavLinkModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .frame(width: 280, height: 50)
            .background(Color.foreground.opacity(0.9))
            .foregroundColor(.text)
            .cornerRadius(10)
            .padding(.bottom, 10)
    }
}


struct ThreeCardSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ThreeCardSelectionView()
                .environmentObject(Deck())
        }
    }
}
