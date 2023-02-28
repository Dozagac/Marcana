//
//  MarcanaApp.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//

import SwiftUI
import Firebase
import RevenueCat

@main
struct MarcanaApp: App {
    // Calling Delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage(wrappedValue: true, DefaultKeys.doOnboarding) var doOnboarding
    @AppStorage(wrappedValue: true, DefaultKeys.doUserInfoFlow) var doUserInfoFlow
    

    var userDataManager = UserDataManager()

    //MARK: - Custom Navigation title font for the whole app
    init () {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Palatino-Bold", size: 34)!]

        Purchases.logLevel = .warn // .debug just to see more informative messages
        Purchases.configure(
            with:
                Configuration.Builder(withAPIKey: RevCatConstants.apiKey)
                .with(usesStoreKit2IfAvailable: true)
                .build()
        )

        // So the app can react to the changes in the RevenueCat server
        Purchases.shared.delegate = PurchasesDelegateHandler.shared
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if doOnboarding {
//                if true {
//                    PaywallView()
                    NavigationStack {
                        OnboardingViewWelcome()
                    }
                } else {
                    // Make sure that there is no missing user data for the fortune flow
                    if userDataManager.thereIsMissingData && doUserInfoFlow {
                        GetUserInfoFlowView()
                    } else {
                        LauncherView()
                            .onAppear {
                            // Make sure that there is no missing user data for the fortune flow (in case they quit while editing for example)
                            if userDataManager.thereIsMissingData {
                                doUserInfoFlow = true
                            }
                        }
                    }
                }
            }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification), perform: { _ in
                // This is triggered when app is opened, when it was at the background, or opened for the first time etc..
                let notificationManager = NotificationManager.shared
                // turn off notification badges when app is opened
                notificationManager.resetNotificationBadges()

                // Get the most recent remote config values from remote config
                RemoteConfigManager.shared.saveRemoteConfigValuesToUserDefaults()
            })
                .preferredColorScheme(.dark)
                .task { // get Packages info from RevenueCat
                do {
                    UserSubscriptionManager.shared.offerings = try await Purchases.shared.offerings()
                    print("Got the offerings \(String(describing: UserSubscriptionManager.shared.offerings?.debugDescription))")
                } catch {
                    print("Error fetching the offerings \(error)")
                }
            }
        }
    }
}


// Initializing Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()

        saveDownloadVersion()

        // Set the api key from remote config
        RemoteConfigManager.shared.saveRemoteConfigValuesToUserDefaults()

//        remoteConfig.configValue(forKey: RemoteConfigKeys.OpenAIAPIKeyKey).stringValue ?? ""

        // initialize this so the private init triggers
        let _ = MusicPlayerManager.shared

        return true
    }
}
