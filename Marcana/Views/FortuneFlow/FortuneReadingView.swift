//
//  FortuneView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 14/01/2023.
//

import SwiftUI
import AnimateText
import SimpleToast


struct FortuneReadingView: View {
    @Binding var showingFortuneSheet: Bool
    @Environment(\.dismiss) var dismiss
    var fortuneReading: FortuneReading

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

    @State var showingSheet = false
    
    @StateObject var toastManager = ToastManager()

    @State var animatingViews = false
    var animationDelay = 0.25


    var body: some View {
        GeometryReader { geo in
            BackgroundView()

            // MARK: - Page View
            VStack(spacing: 0) {
                // MARK: - X button
                HStack {
                    Button {
                        showingFortuneSheet.toggle() // this sends us back to the home screen from fortune flow
                        dismiss() // goes back in the navigation from the history view
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.text)
                            
                    }
                    Spacer()
                }
                .padding([.leading, .top], 20)
                


                // MARK: - Scrollview: Cards + Buttons + Fortune Text Body
                ZStack(alignment: .bottom) {
                    ScrollView(showsIndicators: false) {
                        //MARK: - Cards appear here
                        HStack(alignment: .top, spacing: 8) {
                            ForEach(Array(fortuneReading.fortuneCards.enumerated()), id: \.offset) { index, card in
                                Button {
                                    showingSheet.toggle()
                                } label: {
                                    VStack(spacing: 0) {
                                        Image(card.Card.image)
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(8)
                                            .rotationEffect(card.Orientation == Orientation.upright ? .degrees(0) : .degrees(180))
                                            .padding(.bottom, 4)

                                        Text(card.Card.name)
                                            .foregroundColor(.text)
                                            .font(.customFontBody.bold())
                                            .minimumScaleFactor(0.5)
                                            .lineLimit(2)

                                        Spacer()

                                        Text(card.Orientation.rawValue)
                                            .foregroundColor(.text)
                                            .font(.customFontCallout.italic())

                                    }
                                    .frame(width: geo.size.width/3 * 0.9)

                                }
                                    .offset(y: animatingViews ? 0 : -100)
                                    .opacity(animatingViews ? 1 : 0)
                                    .animation(.easeOut(duration: 1).delay(Double(index) * animationDelay),
                                               value: animatingViews)
                                    .sheet(isPresented: $showingSheet) {
                                    CardDetailView(card: card.Card)
                                }
                            }
                        }
                            .padding(.bottom, 4)


                        Divider()
                            .frame(height: 2)
                            .overlay(.thinMaterial)
                            .padding(.vertical, 8)


                        // MARK: - Date info
                        HStack {
                            HStack{
                                Image(systemName: "calendar")
                                Text(fortuneReading.fortuneDate.formatted())
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                            }
                                .font(.customFontHeadline)
//
                                .cornerRadius(12)
                                .offset(x: animatingViews ? 0 : -100)
                                .opacity(animatingViews ? 1 : 0)
                                .animation(.easeOut(duration: 1).delay(animationDelay),
                                           value: animatingViews)
                            Spacer()
                            // MARK: - Action Buttons
                            HStack {
                                NavigationLink {
                                    FortuneUserInfoView(fortuneReading: fortuneReading)
                                } label: {
                                    Image(systemName: "info.circle")
                                }
                                    .frame(width: 44, height: 44)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(12)
                                    .foregroundColor(Color.text)

                                // MARK: TODO - Favorite button
                                Button {
                                    // this will let the user to like it. IDK what to do with this
                                } label: {
                                    Image(systemName: "heart")
                                }
                                    .frame(width: 44, height: 44)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(12)
                                    .foregroundColor(Color.text)

                                // MARK: Copy to clipboard button
                                Button {
                                    UIPasteboard.general.string = fortuneReading.fortuneText
                                    toastManager.showingToast = true
                                } label: {
                                    Image(systemName: "doc.on.doc")
                                }
                                    .frame(width: 44, height: 44)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(12)
                                    .foregroundColor(Color.text)
                            }
                                .offset(x: animatingViews ? 0 : 100)
                                .opacity(animatingViews ? 1 : 0)
                                .animation(.easeOut(duration: 1).delay(animationDelay),
                                           value: animatingViews)
                        }

                        Divider()
                            .frame(height: 2)
                            .overlay(.thinMaterial)
                            .padding(.vertical, 8)
                        
                        HStack{
                            Image(systemName: "questionmark.bubble.fill")
                                .frame(width: 24, height: 24)
                            Text(fortuneReading.fortuneQuestion)
                            Spacer()
                        }
                        .font(.customFontBody)
                        .offset(x: animatingViews ? 0 : 200)
                        .opacity(animatingViews ? 1 : 0)
                        .animation(.easeOut(duration: 1).delay(animationDelay),
                                   value: animatingViews)
                        
                        Divider()
                            .frame(height: 2)
                            .overlay(.thinMaterial)
                            .padding(.vertical, 8)

                        // MARK: - Main Text Body
                        Text(fortuneReading.fortuneText)
                            .font(.customFontHeadline)
                            .offset(y: animatingViews ? 0 : 200)
                            .opacity(animatingViews ? 1 : 0)
                            .animation(.easeOut(duration: 1).delay(animationDelay),
                                       value: animatingViews)
                            .padding(.bottom, 45) // so the entire text is visible
                        // This doesn't work in multiline and I can't fix it...
                        // AnimateText<ATOpacityEffect>($response, type: type, userInfo: userInfo)

                    }
                        .foregroundColor(.text)
                        .padding(12)

                    ScrollerTextBottomGradientEffectView(effectColor: Color.marcanaBackground)
                }
            }
        }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarBackButtonHidden(true)
            .onAppear {
            animatingViews = true
        }
            .simpleToast(isPresented: $toastManager.showingToast,
                         options: toastManager.toastOptions) {
            Text("Text Copied")
                .foregroundColor(.text)
                .font(.customFontBody)
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
        }
    }
}


struct FortuneReadingView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationStack {
            FortuneReadingView(
                showingFortuneSheet: .constant(true),
                fortuneReading: FortuneHistory.dummyFortunes[1]
            )
                .preferredColorScheme(.dark)
        }
    }
}


