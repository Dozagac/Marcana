//
//  LauncherView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 06/01/2023.
//

import SwiftUI

struct LauncherView: View {

    @AppStorage(wrappedValue: true, "doUserInfoFlow") var doUserInfoFlow
    // Last step of the userInfoFlow should this to false
    @StateObject var loginData = LoginViewOO()
    @StateObject var fortuneHistory = FortuneHistory.shared

    @State private var selectedTab = 0
    
    @StateObject var alertManager = AlertManager.shared

    var body: some View {

// MARK: - DISABLED UNTIL LOGIN IS ENABLED
//        if loginData.loginStatus {
//// App body with tabview goes here
//        } else {
//            LoginView(loginData: loginData)
//        }

        TabView(selection: $selectedTab) {
            //MARK: TAB 1
            NavigationStack {
                HomePageView()
            }
                .tabItem {
                Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled.fill")
                Text("Fortune")
            }
                .tag(0)

            //MARK: TAB 2
            NavigationStack {
                FortuneHistoryView()
            }
                .tabItem {
                Image(systemName: "book.fill")
                Text("History")
            }
                .tag(1)


            //MARK: TAB 3
            NavigationStack {
                SettingsView(selectedTab: $selectedTab)
            }
                .tabItem {
                Image(systemName: "gearshape.fill")
                Text("Settings")
            }
                .tag(2)
        }
        // Internet check and error
        .alert(isPresented: $alertManager.showNoInternetAlert) {
            Alert(title: Text("No Internet Connection"), message: Text("Marcana needs internet connection to function.\nPlease check your internet connection and try again."), dismissButton: .default(Text("OK")))
        }
            .onAppear {
            // view book pg 415, customizing tab bar
            let appearance = UITabBarAppearance()
//                appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
//                appearance.backgroundColor = UIColor(Color.marcanaBackground.opacity(0.2))
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
            .onChange(of: selectedTab, perform: { _ in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        })
            .accentColor(.text)
            .preferredColorScheme(.dark)
            .animation(.easeOut(duration: 0.2), value: selectedTab)
            .fullScreenCover(// Launch user info flow conditionally
        isPresented: $doUserInfoFlow,
                             content: GetUserInfoFlowView.init // init is necessary
        )
    }
}

struct LauncherView_Previews: PreviewProvider {
    static var previews: some View {
        LauncherView()
    }
}
