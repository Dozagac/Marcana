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


