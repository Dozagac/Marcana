//
//  Deck.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//

import Foundation

enum Orientation: String, CaseIterable, Codable {
    case reversed = "Reversed"
    case upright = "Upright"
}

struct DrawnCard: Codable {
    let Card: Card
    let Orientation: Orientation
}

class Deck {
    var allCards: [Card]
    var majorCards: [Card] = []
    var minorCards: [Card] = []
    var cupsCards: [Card] = []
    var pentaclesCards: [Card] = []
    var swordsCards: [Card] = []
    var wandsCards: [Card] = []

    init() {
        let url = Bundle.main.url(forResource: "tarotAI", withExtension: ".json")!
        let data = try! Data(contentsOf: url)
        allCards = try! JSONDecoder().decode([Card].self, from: data)

        self.majorCards = allCards.filter({ $0.suite == .major })
        self.minorCards = allCards.filter({ $0.suite != .major })
        self.cupsCards = allCards.filter({ $0.suite == .cups })
        self.pentaclesCards = allCards.filter({ $0.suite == .pentacles })
        self.swordsCards = allCards.filter({ $0.suite == .swords })
        self.wandsCards = allCards.filter({ $0.suite == .wands })
    }

    // Draws a
    func DrawCards(n: Int) -> [DrawnCard] {
        var drawnCards = [DrawnCard]()
        for i in (0..<n) {
            drawnCards.append(DrawnCard(Card: allCards.shuffled()[i] ,
                                        Orientation: Orientation.allCases.randomElement()!))
        }
        return drawnCards
    }
}


