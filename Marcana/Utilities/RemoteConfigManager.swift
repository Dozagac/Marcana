//
//  FireBaseRemoteConfigManager.swift
//  Marcana
//
//  Created by Deniz Ozagac on 12/02/2023.
// https://www.youtube.com/watch?v=Y_MKeWB8QmM&list=PPSV

import Foundation
import FirebaseRemoteConfig

@MainActor class RemoteConfigManager {
    static let shared = RemoteConfigManager()
    
    var remoteConfig = RemoteConfig.remoteConfig()

    // set default value for
    func setupRemoteConfigDefaults() {
        let defaultValue = ["api_key": "" as NSObject]
        remoteConfig.setDefaults(defaultValue)
    }

    // fetch the new value from remote config
    func fetchRemoteConfig() {
        // 0 means it will be fetched every time..
        let expirationDuration = 0.0
        remoteConfig.fetch(withExpirationDuration: expirationDuration) { [unowned self] (status, error) in
            guard error == nil else { return }
            remoteConfig.activate()
        } }


    func getOpenAIApiKey() -> String {
        setupRemoteConfigDefaults()
        fetchRemoteConfig()
        let api_key = remoteConfig.configValue(forKey: "api_key").stringValue ?? ""
        return api_key
    }
}

