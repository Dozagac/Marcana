//
//  LauncherView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 06/01/2023.
//

import SwiftUI

struct LauncherView: View {
    // Last step of the onboarding should this to false
    @AppStorage(wrappedValue: true, "doOnboarding") var doOnboarding
    @AppStorage(wrappedValue: false, "loginStatus") var loginStatus
    @StateObject var user = UserOO()


    @State private var selectedTab = 0

    var body: some View {
        if loginStatus {

            TabView(selection: $selectedTab) {
                //MARK: TAB 1
                NavigationView {
                    HomePageView()
                }
                    .accentColor(.primary)
                    .tabItem {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled.fill")
                    Text("Fortune")
                }
                    .tag(0)


                //MARK: TAB 2
                NavigationView {
                    FortuneHistoryView()
                }
                    .accentColor(.primary)
                    .tabItem {
                    Image(systemName: "book.fill")
                    Text("History")
                }
                    .tag(1)


                //MARK: TAB 3
                NavigationView {
                    SettingsView()
                }
                    .accentColor(.primary)
                    .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                    .tag(2)
            }
                .onChange(of: selectedTab, perform: { _ in
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            })
                .environmentObject(user)
                .accentColor(.text)
                .preferredColorScheme(.dark)
                .animation(.easeOut(duration: 0.2), value: selectedTab)
                .fullScreenCover(
                isPresented: $doOnboarding,
                content: OnboardingView.init // init is necessary
            )
        } else {
            LoginView()
        }

    }
}

struct LauncherView_Previews: PreviewProvider {
    static var previews: some View {
        LauncherView()
    }
}
