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
        let defaultValues = [
            RemoteConfigKeys.OpenAIAPIKeyKey: "" as NSObject,
            RemoteConfigKeys.PaywallButtonText: "" as NSObject
        ]
        remoteConfig.setDefaults(defaultValues)
    }

    // fetch the new value from remote config
    func fetchRemoteConfig() {
        // 0 means it will be fetched every time..
        let expirationDuration = 0.0
        remoteConfig.fetch(withExpirationDuration: expirationDuration) { [unowned self] (status, error) in
            guard error == nil else { return }
            remoteConfig.activate()
        }
    }
    
    func saveRemoteConfigValuesToUserDefaults() {
        // Pre Setup
        setupRemoteConfigDefaults()
        fetchRemoteConfig()
        //MARK: Set Values to UserDefaults
        // OPENAI api key
        UserDefaults.standard.set(RemoteConfigManager.shared.remoteConfig.configValue(forKey: RemoteConfigKeys.OpenAIAPIKeyKey).stringValue ?? "", forKey: DefaultKeys.openAIAPIKey)
        // Paywall Continue Button
        UserDefaults.standard.set(RemoteConfigManager.shared.remoteConfig.configValue(forKey: RemoteConfigKeys.PaywallButtonText).stringValue ?? "", forKey: DefaultKeys.paywallButtonText)
    }

//    func getOpenAIApiKey() -> String {
//        setupRemoteConfigDefaults()
//        fetchRemoteConfig()
//        let api_key = remoteConfig.configValue(forKey: RemoteConfigKeys.OpenAIAPIKeyKey).stringValue ?? ""
//        return api_key
//    }

}



struct RemoteConfigKeys{
    static let OpenAIAPIKeyKey = "api_key"
    static let PaywallButtonText = "paywall_button_text"
}
