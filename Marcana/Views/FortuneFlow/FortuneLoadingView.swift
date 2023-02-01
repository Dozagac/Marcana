//
//  FortuneLoadingView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 01/02/2023.
//

import SwiftUI
import AnimateText

struct FortuneLoadingView: View {
    @Binding var showingFortuneSheet: Bool
    @Environment(\.dismiss) var dismiss
    @ObservedObject var fortuneRequester: FortuneRequester

    let loadingTexts: [String] = ["...Harnessing Mystic Powers...",
                                  "...Consulting the Cards...",
                                  "...Unlocking Secrets...",
                                  "...Scrying the Unknown...",
                                  "...Exploring the Unseen...",
                                  "...Uncovering Mysteries...",
                                  "...Unveiling the Unknown..."]

    @State var loadingText: String = ""

    var body: some View {
        ZStack {
            BackgroundView()

            // MARK: - Loading Animation
            ZStack(alignment: .center) {
//                AnimatedCipherStroke(minSize: 300, maxSize: 330)
//                    .padding()
//                AnimateText<ATOpacityEffect>($loadingText, type: .letters, userInfo: nil)
//                    .font(.customFontHeadline)
//                    .onAppear {
//                    loadingText = loadingTexts.randomElement()!
//                    Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
//                        loadingText = loadingTexts.randomElement()!
//                    }
//                }
                                FlowerView()
                                    .padding(24)
                
                //MARK: - Invisible NavigationLink that is programmatically triggered
                NavigationLink(destination: FortuneReadingView(
                    showingFortuneSheet: $showingFortuneSheet,
                    fortuneReading: fortuneRequester.fortuneReading
                ),
                               isActive: !$fortuneRequester.waitingForAPIResponse, label: {
                                   EmptyView()
                               })
            }

            // TODO: here
// Trigger navigation once the animation completes
//            if fortuneRequester.waitingForAPIResponse
//            // MARK: - Page View
//            FortuneReadingView()

        }
            .navigationBarBackButtonHidden(true)
    }
}

struct FortuneLoadingView_Previews: PreviewProvider {
    static let randomFortuneCards = [
        Deck().allCards.randomElement()!,
        Deck().allCards.randomElement()!,
        Deck().allCards.randomElement()!
    ]
    
    static var previews: some View {
        FortuneLoadingView(
            showingFortuneSheet: .constant(true),
            fortuneRequester: FortuneRequester(
                fortuneQuestion: "dummy question",
                fortuneType: .with3cards,
                fortuneCards: randomFortuneCards
            )
        )
        .preferredColorScheme(.dark)
    }
}
