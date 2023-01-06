//
//  User.swift
//  Marcana
//
//  Created by Deniz Ozagac on 05/01/2023.
//

import Foundation

// UNUSED UNTIL USER FLOW IS SET
class UserInfo: Identifiable, Codable {
    var id = UUID()
    let name: String
    let gender: String
    let birthdate: Date
    let occupation: String
    let relationship: String
}
