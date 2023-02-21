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
    @State private var showingPaywall = false

    //MARK: - Custom Navigation title font for the whole app
    init () {
//        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: FontsManager.NanumMyeongjo.extraBold, size: 34)!]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Palatino-Bold", size: 34)!]

        Purchases.logLevel = .warn // just to see more informative messages
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
                    OnboardingView(showingPaywall: $showingPaywall)
                        .preferredColorScheme(.dark)
                } else {
                    LauncherView()
                        .preferredColorScheme(.dark)
                }
            }
            .preferredColorScheme(.dark )
                .fullScreenCover(isPresented: $showingPaywall) {
                PaywallView(showingPaywall: $showingPaywall)
            }
                .task { // get Packages info from RevenueCat
                    do{
                        UserSubscriptionManager.shared.offerings = try await Purchases.shared.offerings()
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
        return true
    }
}
