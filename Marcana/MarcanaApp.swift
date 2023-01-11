//
//  MarcanaApp.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//

import SwiftUI

@main
struct MarcanaApp: App {
    // Last step of the onboarding should this to false
    @AppStorage("doOnboarding") var doOnboarding = true
    @State private var selectedTab = 0
    @StateObject var newUser = User()
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                //MARK: Launch onboarding or main page depending on onboarding state
                if doOnboarding {
                    NavigationView {
                        GetUserNameView()
                    }
                    .accentColor(.primary)
                    .tabItem{
                        Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled.fill")
                        Text("Fortune")
                    }.tag(0)
                } else {
                    NavigationView {
                        ReaderChoiceView()
                    }
                    .accentColor(.primary)
                    .tabItem{
                        Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled.fill")
                        Text("Fortune")
                    }.tag(0)
                }

                NavigationView {
                    DeckInfoView()
                }
                .accentColor(.primary)
                .tabItem{
                    Image(systemName: "book.fill")
                    Text("Deck")
                }.tag(1)
            }
            .environmentObject(newUser)
            .accentColor(.white)
            .preferredColorScheme(.dark)
        }
    }
}
