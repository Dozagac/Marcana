//
//  PersistentDataManager.swift
//  Marcana
//
//  Created by Deniz Ozagac on 13/01/2023.
//

import Foundation

struct User: Identifiable, Codable{
    var id = UUID()
    var name: String = ""
    var gender: String = ""
    var birthday: Date = Date()
    var occupation: String = ""
    var relationship: String = ""
}

class PersistentDataManager {
    // ne zaman notification atilmasi gerektigi gibi her sey burada durabilir

    var user: User

    static let shared: PersistentDataManager = PersistentDataManager()

    private init() {
        if let savedUser = UserDefaults.standard.data(forKey: "user"),
            let decodedUser = try? JSONDecoder().decode(User.self, from: savedUser) {
            // If we are here, it means we managed to read and decode the data. Now we try to decode it.
            // .self is mandatory, it indicates that UserOO is a type, not a specific instance.
            user = decodedUser
        } else {
            // Data doesn't exist of could not be decoded
            // If we end up here, we failed either the reading of data of the decoding...
            user = User()
        }
    }
    
    func saveUserToLocal() {
        let encoder = JSONEncoder()

        if let encoded = try? encoder.encode(user) {
            // Save to local user defaults every time items is set.
            UserDefaults.standard.set(encoded, forKey: "user")
        }
    }
}
