//
//  TabViewExample.swift
//  Marcana
//
//  Created by Deniz Ozagac on 14/01/2023.
//

import Foundation
import SwiftUI

//@State private var selectedTab = 0
//
//TabView(selection: $selectedTab) {
//    //MARK: TAB 1
//    NavigationView {
//        HomePageView()
//    }
//        .accentColor(.primary)
//        .tabItem {
//        Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled.fill")
//        Text("Fortune")
//    }.tag(0)
//
//    //MARK: TAB 2
//    NavigationView {
//        DeckInfoView()
//    }
//        .accentColor(.primary)
//        .tabItem {
//        Image(systemName: "book.fill")
//        Text("Deck")
//    }.tag(1)
//}

struct tabViewAnimationExample: View {
    @State private var selection: Int = 1
    var body: some View {
        TabView(selection: $selection,
                content:  {
                    ItemView(text:"1")
                        .tabItem { Text("tab1") }.tag(1)
                    ItemView(text: "2")
                        .tabItem { Text("tab2") }.tag(2)
                })
        
    }
}

struct tabViewAnimationExample_Previews: PreviewProvider {
    static var previews: some View {
        tabViewAnimationExample()
    }
}


struct ItemView: View {
    let text: String
    @State var hidden = true
    
    var body: some View {
        VStack {
            if !hidden {
                Text("Tab Content " + text)
                    .transition(.opacity)
            }
        }
        .onAppear() { withAnimation {
            hidden = false
        }}
        .onDisappear(){hidden = true}
        
    }
}
