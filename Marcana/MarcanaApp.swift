//
//  MarcanaApp.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//

import SwiftUI
import Firebase

@main
struct MarcanaApp: App {
    // Calling Delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage(wrappedValue: true, "doOnboarding") var doOnboarding
    @State private var showingPaywall = false
    
    //MARK: - Custom Navigation title font for the whole app
    init () {
//        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: FontsManager.NanumMyeongjo.extraBold, size: 34)!]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Palatino-Bold", size: 34)!]
//        doOnboarding = true
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                if doOnboarding{
                    OnboardingView(showingPaywall: $showingPaywall)
                        .preferredColorScheme(.dark)
                } else {
                    LauncherView()
                        .preferredColorScheme(.dark)
                }
            }
            .fullScreenCover(isPresented: $showingPaywall){
                PaywallView(showingPaywall: $showingPaywall)
            }
        }
    }
}


// Initializing Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
