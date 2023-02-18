//
//  CardDetailView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 27/11/2022.
//

import SwiftUI

struct CardDetailView: View {
    @Environment(\.dismiss) var dismiss
    var card: Card

    var body: some View {
        ZStack(alignment: .top) {

            VStack {
                //MARK: Dismiss Button
                Button {
                    dismiss()
                } label: {
                    VStack {
                        HStack {
                            Image(systemName: "xmark")
                                .font(.title3)
                                .foregroundColor(.text)
                            Spacer()
                        }
                    }
                        .padding([.leading, .top], 20)
                        .background(.clear)
                }

                ZStack(alignment: .bottom) {
                    ScrollView(showsIndicators: false) {
                        // MARK: Card Image
                        ZStack {
                            CardDisplayImageView(image: "facedownCard2")
                                .shadow(color: Color.gray, radius: 4, x: 0, y: 0)
                                .padding(.top, 30)
                                .padding(.bottom, 16)
                                .offset(x: -50, y: 0)
                                .opacity(0.5)
                                .zIndex(0)

                            CardDisplayImageView(image: card.image)
                                .shadow(color: Color.gray, radius: 4, x: 0, y: 0)
                                .padding(.top, 30)
                                .padding(.bottom, 16)
                                .zIndex(1)

                            CardDisplayImageView(image: "facedownCard2")
                                .shadow(color: Color.gray, radius: 4, x: 0, y: 0)
                                .padding(.top, 30)
                                .padding(.bottom, 16)
                                .offset(x: 50, y: 0)
                                .opacity(0.5)
                                .zIndex(0)
                        }

                        // MARK: Title
                        Text(card.name)
                            .font(.customFontTitle2)
                            .padding(16)

                        // MARK: Card keywords, interpretation
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Upright")
                                    .font(.customFontBody.bold())
                                Text(card.interpretation.upright)
                                    .font(.customFontCallout.italic())
                                //                    KeyWordPillsView(words: card.interpretation.uprightWordList)
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Reversed")
                                    .font(.customFontHeadline.bold())
                                Text(card.interpretation.reversed)
                                    .font(.customFontCallout.italic())
                                //                    KeyWordPillsView(words: card.interpretation.uprightWordList)
                            }
                        }
                            .frame(maxWidth: .infinity, alignment: .leading) // this is needed for proper indentation
                        .padding(.bottom, 10)


                        Divider()
                            .padding(.vertical, 12)

                        // MARK: Description
                        Text(card.description)
                            .font(.customFontBody)
                            .lineLimit(nil)
                            .padding(.bottom, 45) // so the entire text is visible
                    }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .foregroundColor(.text)
                        .onAppear {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    }

                    ScrollerTextBottomGradientEffectView(effectColor: Color.black)
                }
            }
        }
            .background(BackgroundBlurView())
            .edgesIgnoringSafeArea(.bottom)
            .modifier(customNavBackModifier())
    }
}


struct CardDisplayImageView: View {
    var image: String

    var body: some View {
        Image(image)
            .resizable()
            .scaledToFill()
            .cornerRadius(10)
            .frame(width: 200, height: 300)
    }
}

struct CardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CardDetailView(card: Deck().allCards[0])
            .preferredColorScheme(.dark)
    }
}

