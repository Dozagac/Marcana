//
//  MarcanaApp.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//

import SwiftUI

@main
struct MarcanaApp: App {
    @State private var selectedTab = 0
    @StateObject var deck = Deck()
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                NavigationView {
                    GetUserNameView()
                }
                .accentColor(.primary)
                .tabItem{
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled.fill")
                    Text("Fortune")
                }.tag(0)
                NavigationView {
                    DeckInfoView()
                }
                .accentColor(.primary)
                .tabItem{
                    Image(systemName: "book.fill")
                    Text("Deck")
                }.tag(1)
            }
            .accentColor(.white)
            .environmentObject(deck)
        }
    }
}
