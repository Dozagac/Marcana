//
//  FortuneHistory.swift
//  Marcana
//
//  Created by Deniz Ozagac on 30/01/2023.
//

import Foundation
import SwiftUI

class FortuneHistory: ObservableObject {
    @Published var fortunes: [FortuneReading] = [FortuneReading]() {
        didSet{
            saveFortunes()
        }
    }
    
    // make this a set
    @Published var favoriteFortunes: [FortuneReading] = [FortuneReading]() {
        didSet{
            saveFortunes()
        }
    }
    
    func addFortune(_ fortune: FortuneReading) {
        fortunes.insert(fortune, at: 0) // so it appears it correct order in history
    }

    func addToFavoriteFortunes(_ fortune: FortuneReading) {
        favoriteFortunes.insert(fortune, at: 0) // so it appears it correct order in history
    }
    
    func removeFromFavoriteFortunes(_ fortune: FortuneReading) {
        if let index = favoriteFortunes.firstIndex(where: { $0.id == fortune.id }) {
                            favoriteFortunes.remove(at: index)
                        }
        }

    static let dummyFortunes: [FortuneReading] = [
        FortuneReading(fortuneQuestion: "Very long Dummy 1 card question, because why not, you gotta test everything you know?", fortuneText: FortuneRequester.dummyResponse, fortuneType: .with1card, fortuneCards: Deck().DrawCards(n: 1), userName: "Deniz", userGender: GenderPronoun.him.rawValue, userBirthday: 0, userOccupation: "Developer", userRelationship: Relationship.relationship.rawValue),

        FortuneReading(fortuneQuestion: "Very long Dummy 3 card question, because why not, you gotta test everything you know?", fortuneText: FortuneRequester.dummyResponse, fortuneType: .with3cards, fortuneCards: Deck().DrawCards(n: 3), userName: "Deniz", userGender: GenderPronoun.him.rawValue, userBirthday: 0, userOccupation: "Developer", userRelationship: Relationship.relationship.rawValue)
    ]

    static let shared = FortuneHistory()
    private init() {
        loadFortunes()
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
    
    func eraseAllHistory() {
        fortunes = [FortuneReading]()
    }
}
