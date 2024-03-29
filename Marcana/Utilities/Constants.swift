//
//  Constants.swift
//  Marcana
//
//  Created by Deniz Ozagac on 21/02/2023.
//

import Foundation
import SwiftUI

struct UIValues {
    static let HPadding: CGFloat = 16
    static let bigButtonHPadding: CGFloat = 24
    static let listRowBackroundColor: Color = Color.marcanaLicorice.opacity(0.75)
    static let listElementVerticalPadding: CGFloat = 8
    static let onboardingScreenTopPadding: CGFloat = 65
    static let onboardingContinueButtonBottomPadding: CGFloat = 40
}


struct Constants {
    // which image to use for card backs
    // TODO when this is usedfor card selection in the future, init this from user defaults
    static let cardBackImage = "facedownCard3"
    static let isInDevelopmentMode = true
}


// Shared keys for AppStorage and user Defaults
struct DefaultKeys {
    static let readingCountTotal = "readingCountTotal"
    static let readingCountPerUserName = "readingCountPerUserName"
    static let doOnboarding = "doOnboarding"
    static let loginStatus = "loginStatus"
    static let doUserInfoFlow = "doUserInfoFlow"
    static let openAIAPIKey = "openAIAPIKey"
    static let paywallButtonText = "PaywallButtonText"
    static let downloadVersion = "downloadVersion"
    static let isMusicPlaying = "isMusicPlaying"
    static let userGoals = "userGoals"
    static let userTarotExperience = "userTarotExperience"
    static let dailyReminderNotificationHour = "dailyReminderNotificationHour"
    static let dailyReminderNotificationMinute = "dailyReminderNotificationMinute"
    
    static let SingleReaderFreeTriesRemaning = "SingleReaderFreeTriesRemaning"
    static let ThreeReaderFreeTriesRemaning = "ThreeReaderFreeTriesRemaning"
    
    static let lastReviewAskTime = "lastReviewAskTime"
}


struct NotificationKeys {
    static let dailyReminder = "FortuneReminder"
}
