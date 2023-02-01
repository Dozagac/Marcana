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
    @State var showingToast = false
    private let toastOptions = SimpleToastOptions(
        alignment: .bottom,
        hideAfter: 1,
        backdrop: Color.black.opacity(0.2),
        animation: .default,
        modifierType: .slide
    )

    @State var animatingViews = false
    var animationDelay = 0.25


    var body: some View {
        ZStack {
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
                            .font(.title2.bold())
                            .foregroundColor(.text)
                            .padding(.leading, 8)
                    }
                    Spacer()
                }
                    .padding(.horizontal, 12)


                // MARK: - Scrollview: Cards + Fortune Text Body
                ZStack(alignment: .bottom) {
                    ScrollView(showsIndicators: false) {
                        //MARK: - Cards appear here
                        HStack(spacing: 8) {
                            ForEach(Array(fortuneReading.fortuneCards.enumerated()), id: \.offset) { index, card in
                                Button {
                                    showingSheet.toggle()
                                } label: {
                                    Image(card.image)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(8)
                                        .offset(y: animatingViews ? 0 : -100)
                                        .opacity(animatingViews ? 1 : 0)
                                }
                                    .animation(.easeInOut(duration: 1).delay(Double(index) * animationDelay),
                                               value: animatingViews)
                                    .sheet(isPresented: $showingSheet) {
                                    CardDetailView(card: card)
                                }
                            }
                        }
                            .frame(height: 200)
                            .padding(.bottom, 4)

                        Divider()
                            .padding(.vertical, 8)

                        // MARK: - Date info
                        HStack {
                            Label(fortuneReading.fortuneDate.formatted(), systemImage: "calendar")
                                .font(.customFontHeadline)
                                .padding(10) // for size
                            .background(.ultraThinMaterial)
                                .cornerRadius(12)
                                .offset(x: animatingViews ? 0 : -100)
                                .opacity(animatingViews ? 1 : 0)
                                .animation(.easeInOut(duration: 1).delay(animationDelay),
                                           value: animatingViews)
                            Spacer()
                            // MARK: - Action Buttons
                            HStack {
                                NavigationLink {
                                    UserInfoView(fortuneReading: fortuneReading)
                                } label: {
                                    Image(systemName: "person.fill")
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
                                    showingToast = true
                                } label: {
                                    Image(systemName: "doc.on.doc.fill")
                                }
                                    .frame(width: 44, height: 44)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(12)
                                    .foregroundColor(Color.text)
                            }
                                .offset(x: animatingViews ? 0 : 100)
                                .opacity(animatingViews ? 1 : 0)
                                .animation(.easeInOut(duration: 1).delay(animationDelay),
                                           value: animatingViews)
                        }

                        Divider()
                            .padding(.vertical, 8)

                        // MARK: - Main Text Body
                        Text(fortuneReading.fortuneText)
                            .font(.customFontHeadline)
                            .offset(y: animatingViews ? 0 : 200)
                            .opacity(animatingViews ? 1 : 0)
                            .animation(.easeInOut(duration: 1).delay(animationDelay),
                                       value: animatingViews)
                        // This doesn't work in multiline and I can't fix it...
                        // AnimateText<ATOpacityEffect>($response, type: type, userInfo: userInfo)
                    }
                        .foregroundColor(.text)
                        .padding(12)
                    //                    .background(.ultraThinMaterial)
                    .cornerRadius(24)

                    // MARK: - Fadeout gradient at the bottom
                    Color.marcanaBackground
                        .frame(height: 100)
                        .padding(-10) /// expand the blur a bit to cover the edges
                    .mask(LinearGradient(
                        gradient: Gradient(stops: [
                                .init(color: .black, location: 0.5),
                                .init(color: .clear, location: 1)
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    )) /// mask the blurred image using the gradient's alpha values
                }
                    .edgesIgnoringSafeArea(.bottom)

            }
            // this should be an onappear animation
//            .animation(.easeOut(duration: 2), value: fortuneRequester.waitingForAPIResponse)
            .padding(.bottom)

        }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarBackButtonHidden(true)
            .onAppear {
            animatingViews = true
        }
            .simpleToast(isPresented: $showingToast,
                         options: toastOptions) {
            Text("Text Copied")
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
        }
    }
}


struct FortuneReadingView_Previews: PreviewProvider {

//    static let randomFortuneCards = [
//        Deck().allCards.randomElement()!,
//        Deck().allCards.randomElement()!,
//        Deck().allCards.randomElement()!
//    ]
    static let randomFortuneCards = [
        Deck().allCards.randomElement()!
    ]

    static var previews: some View {
        NavigationView {
            FortuneReadingView(
                showingFortuneSheet: .constant(true),
                fortuneReading: FortuneHistory.dummyFortunes[0]
            )
                .preferredColorScheme(.dark)
        }
    }
}
