//
//  FortuneView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 14/01/2023.
//

import SwiftUI
import AnimateText


struct FortuneView: View {
    @ObservedObject var fortuneRequester: FortuneRequester

//    @Binding var response: String
//    @Binding var waitingForAPIResponse: Bool

    let loadingTexts: [String] = ["...Harnessing Mystic Powers...",
                                  "...Consulting the Cards...",
                                  "...Unlocking Secrets...",
                                  "...Scrying the Unknown...",
                                  "...Exploring the Unseen...",
                                  "...Uncovering Mysteries...",
                                  "...Unveiling the Unknown..."]

    @State var loadingText: String = ""
    @State var type: ATUnitType = .letters // The type used to split text.
    @State var userInfo: Any? = nil // Custom user info for the effect.


    var body: some View {
        ZStack {
            BackgroundView()
            
            // MARK: - Loading Animation
            ZStack {
                AnimatedCipherStroke()
                    .padding()
                AnimateText<ATOpacityEffect>($loadingText, type: type, userInfo: userInfo)
                    .onAppear {
                    loadingText = loadingTexts.randomElement()!
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                        loadingText = loadingTexts.randomElement()!
                    }
                }
            }.opacity(fortuneRequester.waitingForAPIResponse ? 1 : 0)

            // MARK: - Fortune view
            VStack {
                Label("1 min read...", systemImage: "timer")

                ScrollView(showsIndicators: false) {
                    Text(fortuneRequester.response)
                    // This doesn't work in multiline and I can't fix it...
                    // AnimateText<ATOpacityEffect>($response, type: type, userInfo: userInfo)
                }
                    .foregroundColor(.text)
                    .frame(height: fortuneRequester.waitingForAPIResponse ? 0 : 700)
                //                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(24)
                    .background(.ultraThinMaterial)
                    .cornerRadius(24)
                HStack {
                    Button {
                        UIPasteboard.general.string = fortuneRequester.dummyResponse
                    } label: {
                        Image(systemName: "heart")
                    }
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .foregroundColor(Color.text)
                    
                    
                    Button {
                        // this will let the user to like it. IDK what to do with this
                    } label: {
                        Image(systemName: "clipboard.fill")
                    }
                    .frame(width: 44,height: 44)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .foregroundColor(Color.text)
                }
            }
            .opacity(fortuneRequester.waitingForAPIResponse ? 0 : 1)
            .animation(.easeOut(duration: 2), value: fortuneRequester.waitingForAPIResponse)
            .padding(.bottom)
        }
    }
}

struct FortuneView_Previews: PreviewProvider {
    @State static var waitingForAPIResponse = true
    @State static private var response = ""

    static var previews: some View {
        FortuneView(fortuneRequester: FortuneRequester())
            .preferredColorScheme(.dark)
    }
}

