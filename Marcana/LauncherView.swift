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

    var body: some View {
        ZStack{
            if loginStatus{
                ZStack {
                    NavigationView{
                        HomePageView()
                            .fullScreenCover(
                            isPresented: $doOnboarding,
                            content: OnboardingView.init // init is necessary
                        )
                    }
                }
                    .environmentObject(user)
                    .accentColor(.text)
                    .preferredColorScheme(.dark)
            } else {
                LoginView()
            }
        }
    }
}

struct LauncherView_Previews: PreviewProvider {
    static var previews: some View {
        LauncherView()
    }
}
