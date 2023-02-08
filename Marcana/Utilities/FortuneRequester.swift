//
//  FortuneRequester.swift
//  Marcana
//
//  Created by Deniz Ozagac on 28/01/2023.
//

import Foundation
import OpenAISwift

class FortuneRequester: ObservableObject {
    init(fortuneQuestion: String, fortuneType: FortuneType, fortuneCards: [DrawnCard]) {
        // read data from userdefaults/appstorage
        self.fortuneReading = FortuneReading(
            fortuneQuestion: fortuneQuestion,
            fortuneText: "", //self.response,
            fortuneType: fortuneType,
            fortuneCards: fortuneCards,
            userName: UserDefaults.standard.string(forKey: "userName") ?? "",
            userGender: UserDefaults.standard.string(forKey: "userGender") ?? "",
            userBirthday: UserDefaults.standard.double(forKey: "userBirthday"),
            userOccupation: UserDefaults.standard.string(forKey: "userOccupation") ?? "",
            userRelationship: UserDefaults.standard.string(forKey: "userRelationship") ?? ""
        )
    }

    private let openAPI = OpenAISwift(authToken: "")
    
    @Published var fortuneReading : FortuneReading
    var fortuneHistory = FortuneHistory()
    

    @Published var waitingForAPIResponse = false
//    @Published private(set) var response = ""
    @Published private(set) var response = """
For your past card, Death is a powerful card that symbolizes endings and new beginnings. It could mean that in the past you had to go through some difficult changes or losses which were necessary for growth and transformation. This card suggests that although it was hard at first, these changes ultimately allowed you to move forward in life with more clarity and purpose than before.

The High Priestess represents your current state of being; this card often indicates inner wisdom, intuition and spiritual connection. You may be feeling connected to yourself on a deeper level right now as well as understanding yourself better than ever before - this will lead to greater self-confidence moving forward! Additionally, it can also signify an upcoming opportunity or decision where you must use both logic and intuition together in order for success - trust yourself!

Finally we come to the 7 of Cups which signifies your future path ahead. This card often appears when there are multiple options available but not all will bring desired results; take time to really think about what each option brings before making any decisions as they can have long lasting effects on your life going forward. In addition, it could also indicate that love is coming into play soon - if Hugo loves you then he may appear again in due course so keep an open heart ready for him! As for whether Hugo loves you specifically: my advice would be to look within yourself first - do YOU love him? That answer lies deep within...
"""

    static let dummyResponse = """
For your past card, Death is a powerful card that symbolizes endings and new beginnings. It could mean that in the past you had to go through some difficult changes or losses which were necessary for growth and transformation. This card suggests that although it was hard at first, these changes ultimately allowed you to move forward in life with more clarity and purpose than before.

The High Priestess represents your current state of being; this card often indicates inner wisdom, intuition and spiritual connection. You may be feeling connected to yourself on a deeper level right now as well as understanding yourself better than ever before - this will lead to greater self-confidence moving forward! Additionally, it can also signify an upcoming opportunity or decision where you must use both logic and intuition together in order for success - trust yourself!

Finally we come to the 7 of Cups which signifies your future path ahead. This card often appears when there are multiple options available but not all will bring desired results; take time to really think about what each option brings before making any decisions as they can have long lasting effects on your life going forward. In addition, it could also indicate that love is coming into play soon - if Hugo loves you then he may appear again in due course so keep an open heart ready for him! As for whether Hugo loves you specifically: my advice would be to look within yourself first - do YOU love him? That answer lies deep within...
"""
    
    func prepareAPIPrompt5Cards() -> String {
        // TODO
        return "TODO"
    }

    func prepareAPIPrompt3Cards() -> String {
        print("PROMPT SENT TO AI")

        let AIprompt = """
        Act as a mystical fortune teller named Marcana that has lifetime experience in using tarot cards to tell personalised fortune readings.
        I will give you general information about myself and pick 3 tarot cards at random.
        Try to make references to the general information I give about myself in the answer you give.
        You can also make references to my star sign, which you know from my birthday.
        Use the cards I chose to make interpretations and create fortune tellings for my past, present and future.
        I will also ask a personal question that you should provide a fortune reading for.
        Don't just tell the meaning of the cards, make it personal to the reader by connecting their meaning to the asked question.
        Give answers that provoke curiosity, wonder and mystery.
        The answer should be customized to the person so they don't feel like you say the same interpretations to everyone.

        Inform the user about the structure of the answer you provide, in case they feel impatient to see the answer to their question.

        Here is my personal information:
        Name: \(self.fortuneReading.userName)
        Birthday: \(Date(timeIntervalSince1970: self.fortuneReading.userBirthday).formatted(date: .abbreviated, time: .omitted))
        Gender: \(self.fortuneReading.userGender)
        Occupation: \(self.fortuneReading.userOccupation)
        Relationship Status: \(self.fortuneReading.userRelationship)

        I picked these tarot cards to represent my past, present and future:

        Past: \(self.fortuneReading.fortuneCards[0].Card.name), \(self.fortuneReading.fortuneCards[0].Orientation)
        Current: \(self.fortuneReading.fortuneCards[1].Card.name), \(self.fortuneReading.fortuneCards[1].Orientation)
        Future: \(self.fortuneReading.fortuneCards[2].Card.name), \(self.fortuneReading.fortuneCards[2].Orientation)

        My question for the fortune reading:
        \(self.fortuneReading.fortuneQuestion)?
        
        Constraints:
        Do not include anything that is not written as a fortune teller.
        Do not repeat this prompt back.
        """
        
        return AIprompt
    }
    
    func prepareAPIPrompt1Card() -> String {
        print("PROMPT SENT TO AI")

        let AIprompt = """
        Act as a mystical fortune teller named Marcana that uses tarot cards to tell my personalized fortune.
        I will give you general information about myself and pick 1 tarot card at random.
        Try to use the general information that I give about myself in the answer you give.
        Use the card I chose to make interpretations and create a fortune telling.
        I will also ask a personal question that you should provide a fortune reading for.
        As a part of your fortune reading, ask at least one question that will make the reader curious.
        Don't just tell the meaning of the cards, make it personal to the reader.
        Give answers that provoke curiosity, wonder and mystery.
        Provide at least one paragraph per card and the questions answer.
        Provide the answer in the tone of a mystical and spiritually attuned fortune teller.

        Here is my personal information:
        Name: \(self.fortuneReading.userName)
        Birthday: \(Date(timeIntervalSince1970: self.fortuneReading.userBirthday).formatted(date: .abbreviated, time: .omitted))
        Gender: \(self.fortuneReading.userGender)
        Occupation: \(self.fortuneReading.userOccupation)
        Relationship Status: \(self.fortuneReading.userRelationship)

        I picked this tarot card: \(self.fortuneReading.fortuneCards[0].Card.name), \(self.fortuneReading.fortuneCards[0].Orientation)

        My question for the fortune reading:
        \(self.fortuneReading.fortuneQuestion)?
        
        Constraints:
        Do not include anything that is not written as a fortune teller.
        Do not repeat this prompt back.
        If my question doesn't sound like a question, it is my mistake, explain you don't understand the question.
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
                //MARK: - Success case
            case .success(let response):
                DispatchQueue.main.async {
                    let responseText = response.choices.first?.text ?? "Sorry, something went wrong."
                    self.response = responseText.trimmingCharacters(in: .whitespacesAndNewlines)
                    self.fortuneReading.fortuneText = self.response
                    self.fortuneHistory.addFortune(
                        self.fortuneReading
                    )
                    print("Fortune added to history")
                    self.waitingForAPIResponse = false
                }
                //MARK: - Fail case
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async { // for the purple error "Publishing changes from background threads is not allowed; "
                    self.response = error.localizedDescription as String
                    print(self.response)
                    self.waitingForAPIResponse = false
                }
            }
        }
    }
}
