//
//  CardDetailView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 27/11/2022.
//

import SwiftUI

struct CardDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var card: Card

    var body: some View {
        ZStack(alignment: .top) {
//            BlurBackgroundView()  // doesnt work with sheet :(

            Rectangle()
                .frame(width:90, height: 2)
                .cornerRadius(10)
                .padding(.top)

            
            VStack{
                //MARK: Dismiss Button
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    VStack {
                        HStack {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .padding(24)
                                .foregroundColor(.text)
                            Spacer()
                        }
                    }
                    .background(.clear)
                }
                
                ScrollView(showsIndicators: false) {
                    // MARK: Card Image
                    ZStack{
                        CardDisplayImageView(image: "facedownCard")
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
                    
                        
                        CardDisplayImageView(image: "facedownCard")
                            .shadow(color: Color.gray, radius: 4, x: 0, y: 0)
                            .padding(.top, 30)
                            .padding(.bottom, 16)
                            .offset(x: 50, y: 0)
                            .opacity(0.5)
                            .zIndex(0)
                    }

                    // MARK: Title
                    Text(card.name)
                        .font(.title)
                        .padding(16)

                    // MARK: Card keywords, interpretation
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Upright")
                                .font(.headline)
                            Text(card.interpretation.upright)
                                .font(.footnote.italic())
                            //                    KeyWordPillsView(words: card.interpretation.uprightWordList)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Reversed")
                                .font(.headline)
                            Text(card.interpretation.reversed)
                                .font(.footnote.italic())
                            //                    KeyWordPillsView(words: card.interpretation.uprightWordList)
                        }
                    }
                        .frame(maxWidth: .infinity, alignment: .leading) // this is needed for proper indentation
                        .padding(.bottom, 10)

                    
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 0.1)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)

                    // MARK: Description
                    Text(card.description)
                        .lineLimit(nil)
                }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .foregroundColor(.text)
                    .onAppear {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                }
            }
        }
        .background(.clear)
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

