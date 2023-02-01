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
    
    //MARK: - Custom Navigation title font for the whole app
    init () {
//        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: FontsManager.NanumMyeongjo.extraBold, size: 34)!]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Palatino-Bold", size: 34)!]
    }
    
    var body: some Scene {
        WindowGroup {
            LauncherView()
                .preferredColorScheme(.dark)
                .onAppear{
                    // Show all available font names, for Debugging
                    for family in UIFont.familyNames.sorted() {
                        let names = UIFont.fontNames(forFamilyName: family)
                        print("Family: \(family) Font names: \(names)")
                    }
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
