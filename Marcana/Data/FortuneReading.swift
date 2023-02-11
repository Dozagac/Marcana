//
//  FortuneReading.swift
//  Marcana
//
//  Created by Deniz Ozagac on 05/02/2023.
//

import Foundation

class FortuneReading: ObservableObject, Codable, Identifiable {
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
    
    @Published var isFavorited = false
    
    func ToggleFavorited() {
        self.isFavorited.toggle()
        FortuneHistory.shared.saveFortunes() // can't put his in didSet for some reason
    }
    
    init(fortuneQuestion: String, fortuneText: String, fortuneType: FortuneType, fortuneCards: [DrawnCard], userName: String, userGender: String, userBirthday: Double, userOccupation: String, userRelationship: String) {
        self.fortuneQuestion = fortuneQuestion
        self.fortuneText = fortuneText
        self.fortuneType = fortuneType
        self.fortuneCards = fortuneCards
        self.userName = userName
        self.userGender = userGender
        self.userBirthday = userBirthday
        self.userOccupation = userOccupation
        self.userRelationship = userRelationship
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        fortuneDate = try container.decode(Date.self, forKey: .fortuneDate)
        fortuneQuestion = try container.decode(String.self, forKey: .fortuneQuestion)
        fortuneText = try container.decode(String.self, forKey: .fortuneText)
        fortuneType = try container.decode(FortuneType.self, forKey: .fortuneType)
        fortuneCards = try container.decode([DrawnCard].self, forKey: .fortuneCards)
        userName = try container.decode(String.self, forKey: .userName)
        userGender = try container.decode(String.self, forKey: .userGender)
        userBirthday = try container.decode(Double.self, forKey: .userBirthday)
        userOccupation = try container.decode(String.self, forKey: .userOccupation)
        userRelationship = try container.decode(String.self, forKey: .userRelationship)
        isFavorited = try container.decode(Bool.self, forKey: .isFavorited)
    }

    enum CodingKeys:CodingKey {
        case id
        case fortuneDate
        case fortuneQuestion
        case fortuneText
        case fortuneType
        case fortuneCards
        case userName
        case userGender
        case userBirthday
        case userOccupation
        case userRelationship
        case isFavorited
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(fortuneDate, forKey: .fortuneDate)
        try container.encode(fortuneQuestion, forKey: .fortuneQuestion)
        try container.encode(fortuneText, forKey: .fortuneText)
        try container.encode(fortuneType, forKey: .fortuneType)
        try container.encode(fortuneCards, forKey: .fortuneCards)
        try container.encode(userName, forKey: .userName)
        try container.encode(userGender, forKey: .userGender)
        try container.encode(userBirthday, forKey: .userBirthday)
        try container.encode(userOccupation, forKey: .userOccupation)
        try container.encode(userRelationship, forKey: .userRelationship)
        try container.encode(isFavorited, forKey: .isFavorited)
    }
}


