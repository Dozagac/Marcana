//
//  DeckInfoView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 27/11/2022.
//

import SwiftUI

struct DeckInfoView: View {
    fileprivate var deck = Deck()
    @State private var sheetCard: Card? = nil

    @State private var searchedString: String = ""
    @State private var searchFilteredList: [Card] = Deck().allCards // I am not using the nev var deck anymore?

    @State var shouldScrollToTop: Bool = false

    let columns = [
        GridItem(.flexible(), spacing: 24),
        GridItem(.flexible(), spacing: 24),
        GridItem(.flexible(), spacing: 24)
    ]
    
    private static let topId = "topIdHere"

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ImageBackgroundView(imageName: "Vine1")

                VStack(spacing: 24) {
                    ScrollViewReader { reader in
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 24) {
                                //MARK: TEXT FIELD
                                ClearableTextField("Card Search", text: $searchedString)
                                    .onChange(of: searchedString) { newValue in
                                    filterDeck(with: searchedString)
                                }
                                    .id(Self.topId)
                                //MARK: GRID VIEW
                                LazyVGrid (columns: columns, spacing: 24) {
                                    ForEach(searchFilteredList) { card in
                                        CardItemView(card: card)
                                            .onTapGesture {
                                            self.sheetCard = card
                                        }
                                    }
                                        .sheet(item: $sheetCard) { card in
                                        CardDetailView(card: card)
                                    }
                                }
                            }
                        }
                        .onChange(of: shouldScrollToTop) { _ in
                            withAnimation { // add animation for scroll to top
                                reader.scrollTo(Self.topId, anchor: .top) // scroll
                            }
                        }
                    }
                }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
            }
            .navigationTitle("All Cards")
//            .navigationBarTitleDisplayMode(.large)
        }
    }

    func filterDeck(with input: String) -> Void {
        print(input)
        if input == "" {
            searchFilteredList = deck.allCards
        } else {
            searchFilteredList = deck.allCards.filter { $0.name.lowercased().contains(input.lowercased()) }
        }
    }
}

struct ClearableTextField: View {
    var prompt: Text
    var title: String
    @Binding var text: String

    init(_ title: String, text: Binding<String>, prompt: Text = Text("Search...").foregroundColor(.secondary)) {
        self.title = title
        self.prompt = prompt
        _text = text
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            HStack(spacing: 4) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .padding(.leading, 12)
                TextField(title, text: $text, prompt: prompt)
                    .font(.customFontBody)
                    .foregroundColor(.text)
            }
            //MARK: X reset button for the search bar
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.black.opacity(0.4))
                .padding(.trailing, 12) // Search bar X button padding
            .onTapGesture {
                text = ""
            }
        }
            .frame(height: 40)
            .background(Color.gray.opacity(0.7))
            .cornerRadius(12)
    }
}

struct CardItemView: View {
    var card: Card

    var body: some View {
        VStack(spacing: 4) {
            Image(card.image)
                .resizable()
                .aspectRatio(2 / 3, contentMode: .fill)
                .cornerRadius(4)
            Text(card.name)
                .frame(height: 20, alignment: .top)
                .font(.footnote.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .foregroundColor(.text)
        }
    }
}

struct DeckInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DeckInfoView()
                .preferredColorScheme(.dark)
        }
    }
}
