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
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack {
                    //MARK: TEXT FIELD
                    ClearableTextField("Card Search", text: $searchedString)
                        .onChange(of: searchedString) { newValue in
                        filterDeck(with: searchedString)
                    }
                        .padding(.bottom, 10)
                    //MARK: GRID VIEW
                    LazyVGrid (columns: columns, spacing: 0) {
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
                .padding()
                .padding([.top, .bottom], 1) // this is to make scrollview ignore safe area, a bug.
            .navigationTitle("All Cards")
                .navigationBarTitleDisplayMode(.inline)
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
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField(title, text: $text, prompt: prompt)
            }
            if text.isNotEmpty {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
                    .onTapGesture {
                    text = ""
                }
                    .padding(.trailing, 4)
            }
        }
            .padding(8) // provides seach bar size
        .background(Color.gray.opacity(0.4))
            .cornerRadius(8)
    }
}

struct CardItemView: View {
    var card: Card

    var body: some View {
        VStack {
            Image(card.image)
                .resizable()
                .aspectRatio(3 / 4, contentMode: .fill)
                .cornerRadius(8)

            Text(card.name)
                .frame(height: 40, alignment: .top)
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
