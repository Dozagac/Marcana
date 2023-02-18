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

    @StateObject var alertManager = AlertManager.shared

    var body: some View {

// MARK: - DISABLED UNTIL LOGIN IS ENABLED
//        if loginData.loginStatus {
//// App body with tabview goes here
//        } else {
//            LoginView(loginData: loginData)
//        }

        NavigationStack {
            HomePageView()
        }
        // Internet check and error
        .alert(isPresented: $alertManager.showNoInternetAlert) {
            Alert(title: Text("No Internet Connection"), message: Text("Marcana needs internet connection to function.\nPlease check your internet connection and try again."), dismissButton: .default(Text("OK")))
        }
            .accentColor(.text)
            .preferredColorScheme(.dark)
            .fullScreenCover(isPresented: $doUserInfoFlow
        ) {
            GetUserInfoFlowView()
        }
    }
}

struct LauncherView_Previews: PreviewProvider {
    static var previews: some View {
        LauncherView()
    }
}
