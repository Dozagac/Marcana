//
//  FavoriteFortunesView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 17/02/2023.
//

import SwiftUI

struct FavoriteFortunesView: View {
    @StateObject var fortuneHistory = FortuneHistory.shared


    var body: some View {
        ZStack {
            ImageBackgroundView(imageName: "Vine2")

            if fortuneHistory.favoriteFortunes.isNotEmpty {
                List {
                    Section {
                        ForEach($fortuneHistory.favoriteFortunes) { $favoritedFortune in
                            FortuneHistoryListRowItems(fortune: $favoritedFortune)
                                .listRowBackground(UIValues.listRowBackroundColor)
                        }
                            .onDelete { indexSet in
                            fortuneHistory.deleteFromFortuneArrays(indexSet)
                        }
                    } header: {
                        Text("Favorites")
                    }
                }
                    .scrollContentBackground(.hidden)
                    .toolbar {
                    EditButton()
                }
            } else {
                //MARK: - Empty History View
                VStack(spacing: 24) {
                    //                    Spacer()

                    Image("CuteCat")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 300)
                        .saturation(0)

                    Text("No Favorites yet")
                        .font(.customFontTitle3)
                }
            }
        }
    }
}

struct FavoriteFortunesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteFortunesView()
    }
}
