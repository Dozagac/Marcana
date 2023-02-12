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
        didSet{
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
        print("PROMPT SENT TO AI")

        let AIprompt = """
        Act as a mystical fortune teller named Marcana that uses tarot cards to tell highly personalized fortune tellings.
        
        I will give you general information about myself and the 1 tarot card I have chosen.
        I will also ask a personal question that you should provide a fortune reading for.
        Interpret the tarot in the context of the question that I ask.
        Try to answer the question in a definitive way, avoid giving an ambiguous answer.
        Try to reference the general information I give about myself in the answer you give.
        For example, you can connect the card interpretations to my occupation, relationship status, or my astrological star sign.
        Use the cards I pick to make interpretations and create fortune tellings for my daily fortune reading.
            
        As a part of your fortune reading, ask at least one question that will make the reader curious.
        Don't just tell the meaning of the cards, make it personal to the reader by connecting card interpretations to the asked question.
        Provide the answer in the tone of a mystical and spiritually attuned fortune teller.
        Give answers that provoke curiosity, wonder, and mystery.
        Prioritize using words that convey emotion and feelings.
        You can use risky statements, it will feel more personal, which is good.
        
        Provide at least one paragraph per 3 card and the questions answer.
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

        I picked this tarot card: \(self.fortuneReading.fortuneCards[0].Card.name), \(self.fortuneReading.fortuneCards[0].Orientation)

        My question for the fortune reading:
        \(self.fortuneReading.fortuneQuestion)?
        
        Welcome!
        """
        return AIprompt
    }

    func prepareAPIPrompt3Cards() -> String {
        print("PROMPT SENT TO AI")

        let AIprompt = """
        Act as a mystical fortune teller named Marcana that uses tarot cards to tell highly personalized fortune tellings.
        
        I will give you general information about myself and the 3 tarot cards I have chosen.
        I will also ask a personal question for which you should provide a fortune reading.
        Interpret the tarot in the context of the question that I ask.
        Try to answer the question in a definitive way, and avoid giving an ambiguous answer.
        Try to reference the general information I give about myself in the answer you give.
        For example, you can connect the card interpretations to my occupation, relationship status, or my astrological star sign.
        Use the cards I pick to make interpretations and create fortune tellings for my past, present, and future.

        As a part of your fortune reading, ask at least one question that will make the reader curious.
        Don't just tell the meaning of the cards, make it personal to the reader by connecting card interpretations to the asked question.
        Provide the answer in the tone of a mystical and spiritually attuned fortune teller.
        Give answers that provoke curiosity, wonder, and mystery.
        Prioritize using words that convey emotion and feelings.
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

        return AIprompt
    }

    func prepareAPIPrompt5Cards() -> String {
        // TODO
        return "TODO"
    }


    func sendAPIRequest(AIPrompt: String) {
        let openAPI = OpenAISwift(authToken: RemoteConfigManager.shared.getApiKey())
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
                    self.waitingForAPIResponse = false
                }
                //MARK: - Fail case
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // delay is so that the flow doesn't get bugged when an instant fail happens.
                    self.response = error.localizedDescription
                    self.fortuneReading.fortuneText = "Oops!\n\nIt looks like our servers are taking a break right now. \nPlease try again in a bit. In the meantime, grab a cup of coffee and enjoy the moment ☕️. \n\nThank you for your patience 🤍. \n\nError: \(self.response)"
                    self.waitingForAPIResponse = false
                }
            }
        }
    }
}
