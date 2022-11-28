//
//  Deck.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//

import Foundation

class Deck: ObservableObject {
    let allCards: [Card]
    var majorCards: [Card] = []
    var minorCards: [Card] = []
    var cupsCards: [Card] = []
    var pentaclesCards: [Card] = []
    var swordsCards: [Card] = []
    var wandsCards: [Card] = []

    
    init() {
        let url = Bundle.main.url(forResource: "tarot", withExtension: ".json")!
        let data = try! Data(contentsOf: url)
        allCards = try! JSONDecoder().decode([Card].self, from: data)

        for card in allCards {
            switch(card.suite) {
            case .major:
                majorCards.append(card)
            case .wands:
                wandsCards.append(card)
                minorCards.append(card)
            case .pentacles:
                pentaclesCards.append(card)
                minorCards.append(card)
            case .swords:
                swordsCards.append(card)
                minorCards.append(card)
            case .cups:
                cupsCards.append(card)
                minorCards.append(card)
            }
        }
    }
}

