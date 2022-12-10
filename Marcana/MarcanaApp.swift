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
                    SingleReaderView()

                }
                .accentColor(.primary)
                .tabItem{
                    selectedTab == 0 ? Image(systemName: "rectangle.roundedtop") : Image(systemName: "rectangle.roundedbottom")
                    Text("Reading")
                }.tag(0)
                NavigationView {
                    DeckInfoView()
                }
                .accentColor(.primary)
                .tabItem{
                    selectedTab == 1 ? Image(systemName: "info.bubble") : Image(systemName: "info.circle")
                    Text("Deck")
                }.tag(1)
            }
            .accentColor(.cyan)
            .environmentObject(deck)
        }
    }
}
