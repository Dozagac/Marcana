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
    
    @State var animating = false

    var body: some View {
        ZStack {
            BackgroundView()
                .onAppear{
                    animating = true
                }

            // MARK: - Loading Animation
            ZStack(alignment: .center) {
//                AnimatedCipherStroke(minSize: 300, maxSize: 330)
//                    .padding()
                VStack(spacing: 24){
                    FlowerView()
                        .padding(24)
                        .frame(width: 250,height: 250)
                    AnimateText<ATOpacityEffect>($loadingText, type: .letters, userInfo: nil)
                        .font(.customFontBody)
                        .onAppear {
                        loadingText = loadingTexts.randomElement()!
                        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
                            loadingText = loadingTexts.randomElement()!
                        }
                    }
                }

            }
            .opacity(animating ? 1 : 0)
            .animation(.easeOut(duration: 1).delay(1), value: animating)

            .navigationDestination(isPresented: !$fortuneRequester.waitingForAPIResponse){
                FortuneReadingView(
                    showingFortuneSheet: $showingFortuneSheet,
                    fortuneReading: fortuneRequester.fortuneReading
                )
            }
        }
            .navigationBarBackButtonHidden(true)
    }
}

struct FortuneLoadingView_Previews: PreviewProvider {
    static let randomFortuneCards = Deck().DrawCards(n: 3)

    
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
