//
//  UserDataManager.swift
//  Marcana
//
//  Created by Deniz Ozagac on 08/02/2023.
//  https://stackoverflow.com/questions/73207435/how-can-i-reset-appstorage-data-when-an-app-storage-variable-is-0

import Foundation
import SwiftUI



// usage: UserDefaults.standard.resetUser()
extension UserDefaults {
    func resetUser() {
        UserDataManager.UserKeys.allCases.forEach {
            removeObject(forKey: $0.rawValue)
        }
    }
}

struct UserDataManager {
    static let userNameDefault = ""
    static let userGenderDefault = ""
    static let userBirthdayDefault = 0.0
    static let userOccupationDefault = ""
    static let userRelationshipDefault = ""

    @AppStorage(wrappedValue: userNameDefault, UserKeys.userName.rawValue) var userName
    @AppStorage(wrappedValue: userGenderDefault, UserKeys.userGender.rawValue) var userGender
    @AppStorage(wrappedValue: userBirthdayDefault, UserKeys.userBirthday.rawValue) var userBirthday
    @AppStorage(wrappedValue: userOccupationDefault, UserKeys.userOccupation.rawValue) var userOccupation
    @AppStorage(wrappedValue: userRelationshipDefault, UserKeys.userRelationship.rawValue) var userRelationship

    enum UserKeys: String, CaseIterable {
        case userName = "userName"
        case userGender = "userGender"
        case userBirthday = "userBirthday"
        case userOccupation = "userOccupation"
        case userRelationship = "userRelationship"
    }

    var thereIsMissingData: Bool {
        if userName == UserDataManager.userNameDefault ||
            userGender == UserDataManager.userGenderDefault ||
            userName == UserDataManager.userNameDefault ||
            userOccupation == UserDataManager.userOccupationDefault ||
            userRelationship == UserDataManager.userRelationshipDefault {
            
            print("Missing data: true")
            return true
        } else {
            print("Missing data: false")
            return false
        }
    }
}




