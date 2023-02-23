//
//  Utilities.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/02/2023.
//

import Foundation
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
