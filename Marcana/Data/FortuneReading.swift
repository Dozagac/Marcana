//
//  FortuneReading.swift
//  Marcana
//
//  Created by Deniz Ozagac on 05/02/2023.
//

import Foundation

struct FortuneReading: Codable, Identifiable {
    var id = UUID()
    var fortuneDate = Date()
    var fortuneQuestion: String
    var fortuneText: String
    var fortuneType: FortuneType
    var fortuneCards: [DrawnCard]

    var userName: String
    var userGender: String
    var userBirthday: Double
    var userOccupation: String
    var userRelationship: String
    
    var isFavorited = false
    
    // This whole thing may need to be a class because I need it as an ObservableObject for the fortune view's like button
//    mutating func ToggleFavorited() {
//        self.isFavorited.toggle()
//    }
}

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


