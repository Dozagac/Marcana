//
//  FortuneView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 14/01/2023.
//

import SwiftUI
import AnimateText


struct FortuneView: View {
    @Binding var response: String
    @Binding var waitingForAPIResponse: Bool

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
            ZStack{
                AnimatedCipherStroke()
                    .padding()
                        AnimateText<ATOpacityEffect>($loadingText, type: type, userInfo: userInfo)
                            .onAppear {
                                loadingText = loadingTexts.randomElement()!
                            Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                                loadingText = loadingTexts.randomElement()!
                            }
                        }
            }.opacity(waitingForAPIResponse ? 1 : 0)
            
            
            ScrollView(showsIndicators: false) {
                Text(response)
            // This doesn't work in multiline and I can't fix it...
            // AnimateText<ATOpacityEffect>($response, type: type, userInfo: userInfo)
            }
                .foregroundColor(.text)
                .frame(height: waitingForAPIResponse ? 0 : 700)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(24)
                .background(.ultraThinMaterial)
                .cornerRadius(24)
                .opacity(waitingForAPIResponse ? 0 : 1)
                .animation(.easeOut(duration: 2), value: waitingForAPIResponse)
        }
//            if response.isNotEmpty && !waitingForAPIResponse {
    }
}

struct FortuneView_Previews: PreviewProvider {
    @State static var waitingForAPIResponse = true
    @State static private var response = ""

    static var previews: some View {
        FortuneView(response: $response, waitingForAPIResponse: $waitingForAPIResponse)
            .preferredColorScheme(.dark)

    }
}

