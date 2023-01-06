//
//  DeckInfoView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 27/11/2022.
//

import SwiftUI

struct DeckInfoView: View {
    @EnvironmentObject var deck: Deck
    @State private var showingSheet = false
    @State var sheetCard: Card? = nil

    @State private var searchedString: String = ""
    @State private var searchFilteredList: [Card] = Deck().allCards // I am not using the nev var deck anymore?

    let columns = [
        GridItem(.flexible(), spacing: 24),
        GridItem(.flexible(), spacing: 24),
        GridItem(.flexible(), spacing: 24)
    ]

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(spacing: 24) {
                //MARK: TEXT FIELD
                ClearableTextField("Card Search", text: $searchedString)
                    .onChange(of: searchedString) { newValue in
                    filterDeck(with: searchedString)
                }

                ScrollView {
                    VStack(spacing: 24) {
                        //MARK: GRID VIEW
                        LazyVGrid (columns: columns, spacing: 24) {
                            ForEach(searchFilteredList) { card in
                                CardItemView(card: card)
                                    .onTapGesture {
                                    self.sheetCard = card
                                    self.showingSheet.toggle()
                                }
                            }
                                .sheet(item: self.$sheetCard) { item in
                                CardDetailView(card: item)
                            }
                        }
                    }
                }
                    .navigationTitle("All Cards")
                    .navigationBarTitleDisplayMode(.inline)
            }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
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
            }
            //MARK: X reset button
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
                .cornerRadius(12)

            Text(card.name)
                .frame(height: 20, alignment: .top)
                .font(.footnote)
                .fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .foregroundColor(.text)
        }
    }
}

struct DeckInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DeckInfoView()
                .environmentObject(Deck())
        }
    }
}
