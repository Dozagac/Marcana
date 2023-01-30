//
//  FortuneHistory.swift
//  Marcana
//
//  Created by Deniz Ozagac on 30/01/2023.
//

import Foundation
import SwiftUI

struct FortuneReading: Codable, Identifiable {
    var id = UUID()
    var fortuneDate = Date()
    var fortuneQuestion: String
    var fortuneText: String
    var userName: String
    var userGender: String
    var userBirthday: Double
    var userOccupation: String
    var userRelationship: String
}


class FortuneHistory: ObservableObject {
    @Published var fortunes: [FortuneReading] = [FortuneReading]()
    
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
