//
//  User.swift
//  Marcana
//
//  Created by Deniz Ozagac on 05/01/2023.
//

import Foundation

// @Published is only needed if we need to make live UI changes
class User: Identifiable, Codable, ObservableObject {
    var id = UUID()
    var name: String = ""
    var gender: String = ""
    var birthday: Date = Date()
    var occupation: String = ""
    var relationship: String = ""

    // Computed properties can be used without violating codable
    var age: Int {
        return Calendar.current.dateComponents([.year], from: Date(), to: birthday).year!
    }
}


class MockUser: Identifiable, Codable, ObservableObject {
    var id = UUID()
    var name: String = "Deniz"
    var gender: String = "Male"
    var birthday: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.date(from: "1993/08/26") ?? Date()
    }
    var occupation: String = "Developler"
    var relationship: String = "In a relationship"

    // Computed properties can be used without violating codable
    var age: Int {
        return Calendar.current.dateComponents([.year], from: Date(), to: birthday).year!
    }
}

// Forget having multiple users for now...
//class Users: ObservableObject {
//    @Published var users = [User]() {
//        didSet {
//            let encoder = JSONEncoder()
//
//            if let encoded = try? encoder.encode(users) {
//                // Save to local user defaults every time items is set.
//                UserDefaults.standard.set(encoded, forKey: LocalDataStrings.users)
//            }
//        }
//    }
//
//    init() {
//        if let savedUsers = UserDefaults.standard.data(forKey: LocalDataStrings.users) {
//            // If we are here, it means we managed to read the data. Now we try to decode it.
//            // .self is mandatory, it indicates that [Expenses] is a type, not a specific instance.
//            if let decodedUsers = try? JSONDecoder().decode([User].self, from: savedUsers) {
//                // We managed to decode it too!
//                users = decodedUsers
//                return
//            }
//        }
//        // If we end up here, we failed either the reading of data of the decoding...
//        users = []
//    }
//}
