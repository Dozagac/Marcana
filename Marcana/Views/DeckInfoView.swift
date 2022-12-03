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

    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            ClearableTextField("Card Search", text: $searchedString, prompt: Text("Search..."))
                .padding(8) // this sets the size
                .background(Color.icon.opacity(0.2))
                .cornerRadius(20)
                .padding(.horizontal) // this sets the outer padding
                .onChange(of: searchedString) { newValue in
                    print(searchedString)
                    filterDeck(with: searchedString)
                }
                .padding(.bottom)
            
               

            LazyVGrid (columns: columns) {
                ForEach(searchFilteredList) { card in
                    ListItem(card: card)
                        .onTapGesture {
                        self.sheetCard = card
                        self.showingSheet.toggle()
                    }
                }

                    .listStyle(.insetGrouped)
                    .sheet(item: self.$sheetCard) { item in
                    CardDetailView(card: item)
                }
            }
        }
            .padding()

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

    init(_ title: String, text: Binding<String>, prompt: Text) {
        self.title = title
        self.prompt = prompt
        _text = text
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            TextField(title, text: $text, prompt: prompt)
            Image(systemName: "xmark.circle")
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(.secondary)
            .onTapGesture {
                text = ""
            }
            .padding(.trailing, 4)
        }
    }
}

struct ListItem: View {
    var card: Card

    var body: some View {
        VStack {
            Image(card.image)
                .resizable()
                .scaledToFit()
                .frame(height: 140.0)
                .cornerRadius(4)
                .shadow(color: Color.gray, radius: 4, x: 0, y: 4)



            Text(card.name)
                .frame(height: 40, alignment: .top)
                .font(.footnote)
                .fontWeight(.semibold)
                .lineLimit(2)
                .minimumScaleFactor(0.4)

        }
            .frame(width: 100, height: 180)
            .navigationTitle("Cards")
            .navigationBarTitleDisplayMode(.automatic)
    }
}

struct DeckInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DeckInfoView()
            .environmentObject(Deck())
    }
}
