//
//  FortuneRequester.swift
//  Marcana
//
//  Created by Deniz Ozagac on 28/01/2023.
//

import SwiftUI
import Foundation
import OpenAISwift

@MainActor class FortuneRequester: ObservableObject {
    init(fortuneQuestion: String, fortuneType: FortuneType, fortuneCards: [DrawnCard]) {
        // read data from userdefaults/appstorage
        self.fortuneReading = FortuneReading(
            fortuneQuestion: fortuneQuestion,
            fortuneText: "",
            fortuneType: fortuneType,
            fortuneCards: fortuneCards,
            userName: UserDefaults.standard.string(forKey: UserDataManager.UserKeys.userName.rawValue) ?? UserDataManager.userNameDefault,
            userGender: UserDefaults.standard.string(forKey: UserDataManager.UserKeys.userGender.rawValue) ?? UserDataManager.userGenderDefault,
            userBirthday: UserDefaults.standard.double(forKey: UserDataManager.UserKeys.userBirthday.rawValue),
            userOccupation: UserDefaults.standard.string(forKey: UserDataManager.UserKeys.userOccupation.rawValue) ?? UserDataManager.userOccupationDefault,
            userRelationship: UserDefaults.standard.string(forKey: UserDataManager.UserKeys.userRelationship.rawValue) ?? UserDataManager.userRelationshipDefault
        )
    }

//    @StateObject var fortuneHistory = FortuneHistory.shared
    @Published var fortuneReading: FortuneReading
    @Published var waitingForAPIResponse = false {
        didSet {
            print ("waitingForAPIResponse: \(waitingForAPIResponse)")
        }
    }
    @Published private(set) var response = ""

    static let dummyResponse = """
For your past card, Death is a powerful card that symbolizes endings and new beginnings. It could mean that in the past you had to go through some difficult changes or losses which were necessary for growth and transformation. This card suggests that although it was hard at first, these changes ultimately allowed you to move forward in life with more clarity and purpose than before.

The High Priestess represents your current state of being; this card often indicates inner wisdom, intuition and spiritual connection. You may be feeling connected to yourself on a deeper level right now as well as understanding yourself better than ever before - this will lead to greater self-confidence moving forward! Additionally, it can also signify an upcoming opportunity or decision where you must use both logic and intuition together in order for success - trust yourself!

Finally we come to the 7 of Cups which signifies your future path ahead. This card often appears when there are multiple options available but not all will bring desired results; take time to really think about what each option brings before making any decisions as they can have long lasting effects on your life going forward. In addition, it could also indicate that love is coming into play soon - if Hugo loves you then he may appear again in due course so keep an open heart ready for him! As for whether Hugo loves you specifically: my advice would be to look within yourself first - do YOU love him? That answer lies deep within...
"""


    func prepareAPIPrompt1Card() -> String {
        let userReGreetingText = getUserGreetingPromptExtra()

        let AIprompt = """
        Act as a spiritually attuned tarot reader named Marcana that tells highly personalized tarot readings.
        I will give you general information about myself and I will pick 1 tarot cards that I have chosen.
        I will also ask a personal question that sets the context for the fortune reading session.
        
        Start your response by warmly welcoming me in the tone of a mystically attuned tarot reader and fortune teller.
        \(userReGreetingText)

        Use the cards I chose to make interpretations and create "1 card spread" tarot reading.
         
        Try to make references to the general information I give about myself in the answer you give.
        You can also make references to my star sign, which you know from my birthday.
        Try to answer the question in a definitive way, and avoid giving an ambiguous answer.
         
        As a part of your fortune reading, ask at least one question that will make the reader curious.
        Don't just tell the meaning of the cards, make it personal to the reader by connecting their meaning to the asked question.
        The answer should be customised to the person so they don't feel like you say the same interpretations to everyone.
        Prioritise using words that convey emotion and feelings.
        Give answers that provoke curiosity and wonder.

        Try to answer the question in a definitive way, avoid giving an ambiguous answer.
        You can use risky statements, it will feel more personal, which is good.

        Provide your answer in paragraphs for better readability.

        Here is my personal information:
        Name: \(self.fortuneReading.userName)
        Birthday: \(Date(timeIntervalSince1970: self.fortuneReading.userBirthday).formatted(date: .abbreviated, time: .omitted))
        Gender: \(self.fortuneReading.userGender)
        Occupation: \(self.fortuneReading.userOccupation)
        Relationship Status: \(self.fortuneReading.userRelationship)

        I picked this tarot card: \(self.fortuneReading.fortuneCards[0].Card.name), \(self.fortuneReading.fortuneCards[0].Orientation)

        My question for the fortune reading:
        \(self.fortuneReading.fortuneQuestion)?
        
        Welcome!
        """

        print("PROMPT SENT TO AI")
        return AIprompt
    }


    func prepareAPIPrompt3Cards() -> String {
        let userReGreetingText = getUserGreetingPromptExtra()

        let AIprompt = """
        Act as a spiritually attuned tarot reader named Marcana that tells highly personalized tarot readings.
        I will give you general information about myself and I will pick 3 tarot cards that I have chosen.
        I will also ask a personal question that sets the context for the fortune reading session.
        
        Start your response by warmly welcoming me in the tone of a mystically attuned tarot reader and fortune teller.
        \(userReGreetingText)

        Use the cards I chose to make interpretations and create a "3 card spread" tarot reading for my past, present and future.
         
        Try to make references to the general information I give about myself in the answer you give.
        You can also make references to my star sign, which you know from my birthday.
        Try to answer the question in a definitive way, and avoid giving an ambiguous answer.
         
        As a part of your fortune reading, ask at least one question that will make the reader curious.
        Don't just tell the meaning of the cards, make it personal to the reader by connecting their meaning to the asked question.
        The answer should be customised to the person so they don't feel like you say the same interpretations to everyone.
        Prioritise using words that convey emotion and feelings.
        Give answers that provoke curiosity and wonder.

        Try to answer the question in a definitive way, avoid giving an ambiguous answer.
        You can use risky statements, it will feel more personal, which is good.

        Provide your answer in paragraphs for better readability.

        
        Constraints:
        Do not include anything that is not written as a fortune teller.
        Do not repeat this prompt back.

        Here is my personal information:
        Name: \(self.fortuneReading.userName)
        Birthday: \(Date(timeIntervalSince1970: self.fortuneReading.userBirthday).formatted(date: .abbreviated, time: .omitted))
        Gender: \(self.fortuneReading.userGender)
        Occupation: \(self.fortuneReading.userOccupation)
        Relationship Status: \(self.fortuneReading.userRelationship)

        These are my tarot cards to represent my past, present and future:

        Past: \(self.fortuneReading.fortuneCards[0].Card.name), \(self.fortuneReading.fortuneCards[0].Orientation)
        Current: \(self.fortuneReading.fortuneCards[1].Card.name), \(self.fortuneReading.fortuneCards[1].Orientation)
        Future: \(self.fortuneReading.fortuneCards[2].Card.name), \(self.fortuneReading.fortuneCards[2].Orientation)

        My question for the fortune reading:
        \(self.fortuneReading.fortuneQuestion)?
        
        Welcome!
        """

        print("PROMPT SENT TO AI")
        return AIprompt
    }

    func prepareAPIPrompt5Cards() -> String {
        // TODO
        return "TODO"
    }


    func sendAPIRequest(AIPrompt: String) {
        guard let openAIAPIKey = UserDefaults.standard.string(forKey: DefaultKeys.openAIAPIKey) else { return }

        let openAPI = OpenAISwift(authToken: openAIAPIKey)
        // There are mode API parameters but this library doesnt accept them yet
        // https://beta.openai.com/docs/api-reference/completions/create
        openAPI.sendCompletion(with: AIPrompt,
                               model: .gpt3(.davinci),
                               maxTokens: 500) { result in

            switch result {
                //MARK: - Success case
            case .success(let response):
                DispatchQueue.main.async { // for the purple error "Publishing changes from background threads is not allowed; "
                    let responseText = response.choices.first?.text ?? "Sorry, something went wrong."
                    self.response = responseText.trimmingCharacters(in: .whitespacesAndNewlines)
                    self.fortuneReading.fortuneText = self.response
                    FortuneHistory.shared.addFortune(
                        self.fortuneReading
                    )
                    print("Fortune added to history")
                    // Count how many request have succeeded for analytics and price tracking
                    self.countUserReadings()

                    // -1 to the respective type of tree trial count
                    self.adjustFreeTriesLeft()

                    self.waitingForAPIResponse = false
                }
                //MARK: - Fail case
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // delay is so that the flow doesn't get bugged when an instant fail happens.
                    self.response = error.localizedDescription
                    self.fortuneReading.fortuneText = "Oops!\n\nIt looks like our servers are taking a break right now... \nPlease try again in a bit. \nIn the meantime, why not grab a cup of coffee ☕️ and give a call to a loved one? \n\n🤍\n\nThank you for your patience 🙏"
                    self.waitingForAPIResponse = false
                    print("API ERROR: \(self.response)")
                }
            }
        }
    }

    func getUserGreetingPromptExtra() -> String {
        // Set the default values if these are found to be nil.
        UserDefaults.standard.register(
            defaults: [
                "readingCountPerUserName": 0
            ]
        )

        var userReGreetingText = ""
        let readingCountPerUserName = UserDefaults.standard.integer(forKey: DefaultKeys.readingCountPerUserName)

        if readingCountPerUserName > 0 {
            print("Welcome back prompt active, reading count: \(readingCountPerUserName)")
            userReGreetingText = "Greet me as if we have already met before"
        }
        return userReGreetingText
    }


    func countUserReadings() {
        // Set the default values if these are found to be nil.
        UserDefaults.standard.register(
            defaults: [
                "readingCountTotal": 0,
                "readingCountPerUserName": 0
            ]
        )

        // Increase the reading count of the app, used for analytics ad price tracking
        var readingCountTotal = UserDefaults.standard.integer(forKey: DefaultKeys.readingCountTotal)
        readingCountTotal += 1
        UserDefaults.standard.set(readingCountTotal, forKey: DefaultKeys.readingCountTotal)
        print("User successfully requested and received \(readingCountTotal) readings")

        // Increase the reading count PerUserName, this is for welcome tracking per name
        var readingCountPerUserName = UserDefaults.standard.integer(forKey: DefaultKeys.readingCountPerUserName)
        readingCountPerUserName += 1
        UserDefaults.standard.set(readingCountPerUserName, forKey: DefaultKeys.readingCountPerUserName)
    }

    func adjustFreeTriesLeft() {
        @AppStorage(wrappedValue: 1, DefaultKeys.SingleReaderFreeTriesRemaning) var SingleReaderFreeTriesRemaning
        @AppStorage(wrappedValue: 1, DefaultKeys.ThreeReaderFreeTriesRemaning) var ThreeReaderFreeTriesRemaning

        if self.fortuneReading.fortuneType == .with1card {
            if SingleReaderFreeTriesRemaning > 0 {
                SingleReaderFreeTriesRemaning -= 1
            }
        } else if self.fortuneReading.fortuneType == .with3cards {
            if ThreeReaderFreeTriesRemaning > 0 {
                ThreeReaderFreeTriesRemaning -= 1
            }
        }
    }
}
