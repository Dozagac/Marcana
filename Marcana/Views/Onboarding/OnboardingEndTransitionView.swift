//
//  OnboardingEndTransitionView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 22/02/2023.
//

import SwiftUI

struct OnboardingEndTransitionView: View {
//    @Environment(\.showingPaywall) var showingPaywall: Binding<Bool>
    @State var showingPaywall = false
    @State private var animatingViews = false
    let animationDelay = 1.0
    
    @State private var progress = 0.0
    
    var progressInterval: ClosedRange<Date> {
        let start = Date()
        let end = start.addingTimeInterval(9)
        return start...end
    }
    
    var body: some View {

        ZStack{
            BackgroundView()
            
            ProgressView(timerInterval: progressInterval, countsDown: false, label: { EmptyView() }, currentValueLabel: { EmptyView() })
                .tint(.white)
                .frame(width: 200, height: 200)
                .opacity(animatingViews ? 1 : 0)
                .animation(.easeOut(duration: 1).delay(1),
                           value: animatingViews)
                .opacity(animatingViews ? 0 : 1)
                .animation(.easeOut(duration: 1).delay(10.5),
                           value: animatingViews)
            
            Text("You are doing great!")
                .offset(y: animatingViews ? 50 : 130)
                .opacity(animatingViews ? 1 : 0)
                .animation(.easeOut(duration: 1).delay(1),
                           value: animatingViews)
                .opacity(animatingViews ? 0 : 1)
                .animation(.easeOut(duration: 1).delay(3),
                           value: animatingViews)
            
            Text("Finalizing...")
                .offset(y: animatingViews ? 50 : 130)
                .opacity(animatingViews ? 1 : 0)
                .animation(.easeOut(duration: 1).delay(4),
                           value: animatingViews)
                .opacity(animatingViews ? 0 : 1)
                .animation(.easeOut(duration: 1).delay(7),
                           value: animatingViews)

            Text("Ready!")
                .offset(y: animatingViews ? 50 : 130)
                .opacity(animatingViews ? 1 : 0)
                .animation(.easeOut(duration: 1).delay(8),
                           value: animatingViews)
                .opacity(animatingViews ? 0 : 1)
                .animation(.easeOut(duration: 1).delay(10.5),
                           value: animatingViews)
        }
        .font(.customFontBody)
        .navigationBarBackButtonHidden(true)
        .onAppear{
            animatingViews = true
            // Transition to paywall after animations complete
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.5) {
                AnalyticsManager.shared.logEvent(eventName: AnalyticsKeys.paywallPageview, properties: [AnalyticsAmplitudeEventPropertyKeys.paywallSource : PaywallSource.onboardingView.rawValue])
                showingPaywall = true
            }
            AnalyticsManager.shared.logEvent(eventName: AnalyticsKeys.onboardingTransitionPageview)
        }
        .fullScreenCover(isPresented: $showingPaywall){
            PaywallView()
        }
    }
}

struct OnboardingEndTransitionView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingEndTransitionView()
    }
}
