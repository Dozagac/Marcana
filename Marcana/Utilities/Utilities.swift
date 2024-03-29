//
//  Utilities.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/02/2023.
//

import Foundation
import StoreKit
import SwiftUI


func saveDownloadVersion() {
    // Check if the app version has already been saved in UserDefaults
    let versionKey = DefaultKeys.downloadVersion
    let defaults = UserDefaults.standard
    if defaults.object(forKey: versionKey) == nil {
        // Save the app version in UserDefaults
        if let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            defaults.set(appVersion, forKey: versionKey)
            print("Download version is \(appVersion)")
        }
    }
}


func ReasonablyRequestAppReview(_ requestReview: RequestReviewAction) {
    var lastReviewAskTime = UserDefaults.standard.object(forKey: DefaultKeys.lastReviewAskTime) as? Double // optional
    guard var lastReviewAskTime = lastReviewAskTime else {
        // This is the first time the function has been called, save the current time and ask for the review, then return
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            requestReview()
        }
        lastReviewAskTime = Date().timeIntervalSince1970
        UserDefaults.standard.set(lastReviewAskTime, forKey: DefaultKeys.lastReviewAskTime)
        return
    }

    // Calculate the time interval since the last call
    let timeInterval = Date().timeIntervalSince1970 - lastReviewAskTime
    let minutesSinceLastCall = Double(timeInterval / 60.0)

    if minutesSinceLastCall >= 5.0 {
        print("Minutes since last review request: \(minutesSinceLastCall)")
        // It's been more than 5 minutes since the last call, so ask the user for an app review
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            requestReview()
        }

        // Save the current time as the last call time
        lastReviewAskTime = Date().timeIntervalSince1970
        UserDefaults.standard.set(lastReviewAskTime, forKey: DefaultKeys.lastReviewAskTime)
    }
}
