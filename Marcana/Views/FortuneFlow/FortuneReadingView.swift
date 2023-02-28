//
//  FortuneView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 14/01/2023.
//

import SwiftUI
import AnimateText
import StoreKit


struct FortuneReadingView: View {
    @Binding var showingFortuneSheet: Bool
    @Environment(\.dismiss) var dismiss
    @ObservedObject var fortuneReading: FortuneReading
    @Environment(\.requestReview) var requestReview

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

    @State var animatingViews = false
    var animationDelay = 0.25

    @State private var renderedShareImage: Image?

    @State private var tappedCard: Card? = nil

    var body: some View {
        GeometryReader { geo in
            BackgroundView()

            // MARK: - Page View
            VStack(spacing: 0) {

                // MARK: - Top bar buttons
                HStack {
                    // MARK: - X button
                    Button {
                        showingFortuneSheet = false // this sends us back to the home screen from fortune flow
                        dismiss() // goes back in the navigation from the history view
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.text)
                    }

                    Spacer()
                }
                    .padding([.horizontal, .top], 20)

                // MARK: - Scrollview: Cards + Buttons + Fortune Text Body
                ZStack(alignment: .bottom) {
                    ScrollView(showsIndicators: false) {
                        //MARK: - Cards appear here
                        HStack(alignment: .top, spacing: 8) {
                            ForEach(Array(fortuneReading.fortuneCards.enumerated()), id: \.offset) { index, drawnCard in
                                Button {
                                    self.tappedCard = drawnCard.Card
                                } label: {
                                    VStack(spacing: 0) {
                                        Image(drawnCard.Card.image)
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(8)
                                            .rotationEffect(drawnCard.Orientation == Orientation.upright ? .degrees(0) : .degrees(180))
                                            .padding(.bottom, 4)

                                        Text(drawnCard.Card.name)
                                            .foregroundColor(.text)
                                            .font(.customFontBody.bold())
                                            .minimumScaleFactor(0.5)
                                            .lineLimit(2)

                                        Spacer()

                                        Text(drawnCard.Orientation.rawValue)
                                            .foregroundColor(.text)
                                            .font(.customFontCallout.italic())
                                    }
                                        .frame(width: geo.size.width / 3 * 0.9)
                                        .sheet(item: $tappedCard) { tappedCard in
                                        CardDetailView(card: tappedCard)
                                    }

                                }
                                    .offset(y: animatingViews ? 0 : -100)
                                    .opacity(animatingViews ? 1 : 0)
                                    .animation(.easeOut(duration: 1).delay(Double(index) * animationDelay),
                                               value: animatingViews)
                            }
                        }
                            .padding(.bottom, 4)

                        Divider()
                            .frame(height: 2)
                            .overlay(.thinMaterial)
                            .padding(.vertical, 8)


                        // MARK: - Date info
                        HStack {
                            HStack {
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
                                // MARK: - Share button
                                if let renderedShareImage {
                                    // See end of the video for example
                                    // https://www.youtube.com/watch?v=rM_2i5YobF4
                                    ShareLink(item: renderedShareImage,
                                              subject: Text("My Tarot Fortune - Marcana App"),
                                              message: Text("Check out my Tarot Reading from Marcana App! \n\n ⭐️ \n\n\(fortuneReading.fortuneText)"),
                                              preview: SharePreview("My Tarot Fortune - Marcana App", image: "AppIcon")) { // image doesn't work
                                        // label
                                        Image(systemName: "square.and.arrow.up")
                                            .frame(width: 44, height: 44)
                                            .background(.ultraThinMaterial)
                                            .cornerRadius(12)
                                            .foregroundColor(Color.text)
                                    }

                                }

                                // MARK: - Info button
                                NavigationLink {
                                    FortuneUserInfoView(fortuneReading: fortuneReading)
                                } label: {
                                    Image(systemName: "info.circle")
                                }
                                    .frame(width: 44, height: 44)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(12)
                                    .foregroundColor(Color.text)
                                    .opacity(animatingViews ? 1 : 0)
                                    .animation(.easeOut(duration: 1).delay(animationDelay * 1.5),
                                               value: animatingViews)


                                // MARK: TODO - Favorite button
                                Button {
                                    // this will let the user to like it. IDK what to do with this
                                    fortuneReading.ToggleFavorited()
                                    // Ask for a review when the user likes a reading
                                    ReasonablyRequestAppReview(requestReview)
                                    
                                    print("Favorited: \(fortuneReading.isFavorited)")
                                } label: {
                                    Image(systemName: fortuneReading.isFavorited ? "heart.fill" : "heart")
                                }
                                    .frame(width: 44, height: 44)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(12)
                                    .foregroundColor(fortuneReading.isFavorited ? Color.red : Color.text)
                                    .animation(.linear, value: fortuneReading.isFavorited)
                                    .opacity(animatingViews ? 1 : 0)
                                    .animation(.easeOut(duration: 1).delay(animationDelay * 2),
                                               value: animatingViews)

                            }
                            // TODO: Offset animation does not work but opacity does. for the if let conditioned view...
                            // Also, opacity only works on it if it's here on the parent. So it is put here and the other buttons in the
                            // view are animated with their own modifiers.
//                                .offset(x: animatingViews ? 0 : 100)
                            .opacity(animatingViews ? 1 : 0)
                                .animation(.easeOut(duration: 1).delay(animationDelay),
                                           value: animatingViews)

                        }

                        Divider()
                            .frame(height: 2)
                            .overlay(.thinMaterial)
                            .padding(.vertical, 8)

                        HStack {
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
                            .padding(.bottom, 24) // so the entire text is visible

                        // MARK: Bottom buttons
                        HStack(spacing: 24) {
                            // MARK: - BOTTOM Share button
                            if let renderedShareImage {
                                // See end of the video for example
                                // https://www.youtube.com/watch?v=rM_2i5YobF4
                                ShareLink(
                                    "Share",
                                    item: renderedShareImage,
                                    subject: Text("My Tarot Fortune - Marcana App"),
                                    message: Text("Check out my Tarot Reading from Marcana App! \n\n ⭐️ \n\n\(fortuneReading.fortuneText)"),
                                    preview: SharePreview("My Tarot Fortune - Marcana App", image: "AppIcon")) // image doesn't work
                                .padding()
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(12)
                                    .foregroundColor(Color.text)
                            }


                            // MARK: BOTTOM Favorite button
                            Button {
                                // this will let the user to like it
                                fortuneReading.ToggleFavorited()
                                print("Favorited: \(fortuneReading.isFavorited)")
                                // Ask for a review when the user likes a reading
                                ReasonablyRequestAppReview(requestReview)
                            } label: {
                                Label("Like", systemImage: fortuneReading.isFavorited ? "heart.fill" : "heart")
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(12)
                                    .foregroundColor(fortuneReading.isFavorited ? Color.red : Color.text)
                                    .animation(.linear, value: fortuneReading.isFavorited)
                                    .opacity(animatingViews ? 1 : 0)
                                    .animation(.easeOut(duration: 1).delay(animationDelay * 2),
                                               value: animatingViews)
                            }
                        }
                            .padding(.bottom, 24) // so the entire text is visible

                    }
                        .foregroundColor(.text)
                        .padding(12)

                    ScrollerTextBottomGradientEffectView(effectColor: Color.marcanaBackground)
                }
            }
                .overlay(
                HeartLikePopAnimation(isLiked: $fortuneReading.isFavorited)
            )
                .onAppear {
                // See end of the video for example
                // https://www.youtube.com/watch?v=rM_2i5YobF4
                let renderer = ImageRenderer(content: ShareCardsImageView(fortuneReading: fortuneReading))
                renderer.scale = 1
                if let image = renderer.cgImage {
                    renderedShareImage = Image(decorative: image, scale: 1)
                }
            }
        }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarBackButtonHidden(true)
            .onAppear {
            animatingViews = true
        }
    }
}
    
struct ShareCardsImageView: View {
    // See end of the video for example
    // https://www.youtube.com/watch?v=rM_2i5YobF4
    var fortuneReading: FortuneReading
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            ForEach(Array(fortuneReading.fortuneCards.enumerated()), id: \.offset) { index, card in
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
                    .frame(width: 200)
            }
        }
            .padding(12)
            .background(Color.marcanaBackground)
            .cornerRadius(12)
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


