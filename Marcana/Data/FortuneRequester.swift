//
//  FortuneRequester.swift
//  Marcana
//
//  Created by Deniz Ozagac on 28/01/2023.
//

import Foundation
import OpenAISwift

class FortuneRequester: ObservableObject {
    private let openAPI = OpenAISwift(authToken: "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")
    @Published var waitingForAPIResponse = false
    @Published private(set) var response = ""
    
    
    // read data from userdefaults/appstorag
    let userName = UserDefaults.standard.string(forKey: "userName")
    let userGender = UserDefaults.standard.string(forKey: "userGender")
    let userBirthday = UserDefaults.standard.double(forKey: "userBirthday")
    let userOccupation = UserDefaults.standard.string(forKey: "userOccupation")
    let userRelationship = UserDefaults.standard.string(forKey: "userRelationship")


    let dummyResponse = """
For your past card, Death is a powerful card that symbolizes endings and new beginnings. It could mean that in the past you had to go through some difficult changes or losses which were necessary for growth and transformation. This card suggests that although it was hard at first, these changes ultimately allowed you to move forward in life with more clarity and purpose than before.

The High Priestess represents your current state of being; this card often indicates inner wisdom, intuition and spiritual connection. You may be feeling connected to yourself on a deeper level right now as well as understanding yourself better than ever before - this will lead to greater self-confidence moving forward! Additionally, it can also signify an upcoming opportunity or decision where you must use both logic and intuition together in order for success - trust yourself!

Finally we come to the 7 of Cups which signifies your future path ahead. This card often appears when there are multiple options available but not all will bring desired results; take time to really think about what each option brings before making any decisions as they can have long lasting effects on your life going forward. In addition, it could also indicate that love is coming into play soon - if Hugo loves you then he may appear again in due course so keep an open heart ready for him! As for whether Hugo loves you specifically: my advice would be to look within yourself first - do YOU love him? That answer lies deep within...
"""

    func prepareAPIPrompt(chosenCards: [Card], chosenQuestion: String) -> String {
        print("PROMPT SENT TO AI")

        let AIprompt = """
        Act as a mystical fortune teller named Marcana that uses tarot cards to tell a personalized fortune.
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
        Name: \(userName ?? "")
        Birthday: \(Date(timeIntervalSince1970: userBirthday).formatted(date: .abbreviated, time: .omitted))
        Gender: \(userGender ?? "")
        Occupation: \(userOccupation ?? "")
        Relationship Status: \(userRelationship ?? "")

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
                DispatchQueue.main.async{
                    let responseText = response.choices.first?.text ?? "Sorry, something went wrong."
                    self.response = responseText.trimmingCharacters(in: .whitespacesAndNewlines)
                    print("response")
                    self.waitingForAPIResponse = false
                 }
            case .failure(let error):
                print(error)
                self.response = error.localizedDescription
            }
        }
    }
}
