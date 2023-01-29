//
//  User.swift
//  Marcana
//
//  Created by Deniz Ozagac on 05/01/2023.
//

import Foundation


// @Published is only needed if we need to make live UI changes
// This doesnt even need to be an onbervable object
class UserOO: Identifiable, Codable, ObservableObject {
    var id = UUID()
    var name: String = ""
    var gender: String = ""
    var birthday: Date = Date()
    var occupation: String = ""
    var relationship: String = ""

    // Init that takes all the default values
    init() { }

    // Custom init for dummy
    init(name: String, gender: String, birthday: Date, occupation: String, relationship: String) {
        self.name = name
        self.gender = gender
        self.birthday = birthday
        self.occupation = occupation
        self.relationship = relationship
    }

    // Computed properties can be used without violating codable
    var age: Int {
        return Calendar.current.dateComponents([.year], from: Date(), to: birthday).year!
    }

    func encode() -> Data? {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            return encoded
        } else {
            return nil
        }
    }

    static func decode(userData: Data) -> UserOO? {
        let decoder = JSONDecoder()
        if let user = try? decoder.decode(UserOO.self, from: userData) {
            return user
        } else {
            return nil
        }
    }
}


class MockUserOO: Identifiable, Codable, ObservableObject {
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

//
//// Will implement this multi user style instead of the current single user one
//class Users: ObservableObject {
//    @Published var users = [UserOO]() {
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
//            if let decodedUsers = try? JSONDecoder().decode([UserOO].self, from: savedUsers) {
//                // We managed to decode it too!
//                users = decodedUsers
//                return
//            }
//        }
//        // If we end up here, we failed either the reading of data of the decoding...
//        users = []
//    }
//
//    func getDummy() -> [UserOO] {
//        let dummyUsers = [
//            UserOO(name: "deniz", gender: "male", birthday: Date().removeYears(numberOfYears: 29), occupation: "developer", relationship: "in a relationship"),
//            UserOO(name: "jack", gender: "other", birthday: Date().removeYears(numberOfYears: 50), occupation: "dummy boi", relationship: "single")
//        ]
//
//        return dummyUsers
//    }
//}
