//
//  MarcanaApp.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//

import SwiftUI

@main
struct MarcanaApp: App {
    
//    @StateObject var deck = Deck()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    ContentView()
                }
                .tabItem{
                    Image(systemName: "camera.metering.unknown")
                    Text("Reading")
                }
                NavigationView {
                    DeckInfoView()
                }
                .tabItem{
                    Image(systemName: "info.circle")
                    Text("Deck")
                }
            }
//            .environmentObject(deck)
        }
    }
}
