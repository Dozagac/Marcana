//
//  FortuneHistory.swift
//  Marcana
//
//  Created by Deniz Ozagac on 30/01/2023.
//

import Foundation
import SwiftUI

enum FortuneType: String, Codable {
    case with1card, with3cards, with5cards

    var icon: String {
        switch self {
        case .with1card:
            return "Icon1Card"
        case .with3cards:
            return "Icon3Cards"
        case .with5cards:
            return "Icon5Cards"
        }
    }
}

struct FortuneReading: Codable, Identifiable {
    var id = UUID()
    var fortuneDate = Date()
    var fortuneQuestion: String
    var fortuneText: String
    var fortuneType: FortuneType
    var fortuneCards: [Card]

    var userName: String
    var userGender: String
    var userBirthday: Double
    var userOccupation: String
    var userRelationship: String
}


class FortuneHistory: ObservableObject {
    @Published var fortunes: [FortuneReading] = [FortuneReading]()

    static let dummyFortunes: [FortuneReading] = [
        FortuneReading(fortuneQuestion: "Dummy 1 card question", fortuneText: FortuneRequester.dummyResponse, fortuneType: .with1card, fortuneCards: [Deck().allCards[0]], userName: "Deniz", userGender: GenderPronoun.him.rawValue, userBirthday: 0, userOccupation: "Developer", userRelationship: Relationship.relationship.rawValue),

        FortuneReading(fortuneQuestion: "Dummy 3 card question", fortuneText: FortuneRequester.dummyResponse, fortuneType: .with3cards, fortuneCards: [Deck().allCards[0], Deck().allCards[1], Deck().allCards[2]], userName: "Deniz", userGender: GenderPronoun.him.rawValue, userBirthday: 0, userOccupation: "Developer", userRelationship: Relationship.relationship.rawValue)
    ]

    init() {
        loadFortunes()
    }


    func addFortune(_ fortune: FortuneReading) {
        fortunes.append(fortune)
        saveFortunes()
    }

    func saveFortunes() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(fortunes) {
            UserDefaults.standard.set(encoded, forKey: "fortunes")
            print("Saving fortune")
        }
    }

    func loadFortunes() {
        if let fortunesData = UserDefaults.standard.data(forKey: "fortunes") {
            let decoder = JSONDecoder()
            if let decodedFortunes = try? decoder.decode([FortuneReading].self, from: fortunesData) {
                fortunes = decodedFortunes
            }
        }
    }
}
