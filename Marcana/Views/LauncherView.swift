//
//  LauncherView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 06/01/2023.
//

import SwiftUI

struct LauncherView: View {
    // Last step of the onboarding sets this to false
    @AppStorage("doOnboarding") var doOnboarding = true
    
    var body: some View {
        ZStack{
            if doOnboarding{
                GetUserNameView()
            } else {
                GetUserQuestionView()
            }
        }
    }
}

struct LauncherView_Previews: PreviewProvider {
    static var previews: some View {
        LauncherView()
    }
}
