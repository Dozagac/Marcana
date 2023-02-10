//
//  FortuneHistoryView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 30/01/2023.
//

import SwiftUI

struct FortuneHistoryView: View {
    @StateObject var fortuneHistory = FortuneHistory.shared
    @State private var showingFortuneSheet = false // starts a fortune reading flow

    @State private var tappedFortuneHistoryItem: FortuneReading? = nil // to each history element

    var body: some View {
        ZStack {
            ImageBackgroundView(imageName: "Vine2")

            // COMMENT IN FOR TESTING
            //            if FortuneHistory.dummyFortunes.isNotEmpty {
            if fortuneHistory.fortunes.isNotEmpty {
                List {
                    // COMMENT IN FOR TESTING
                    //                    ForEach(FortuneHistory.dummyFortunes) { fortune in
                    ForEach(fortuneHistory.fortunes) { fortune in
                        Button {
                            tappedFortuneHistoryItem = fortune
                        } label: {
                            HStack(spacing: 8) {
                                Image(fortune.fortuneType.iconName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: fortune.fortuneType == FortuneType.with1card ? 24 : 44,
                                           height: fortune.fortuneType == FortuneType.with1card ? 24 : 44)
                                    .frame(width: 44, height: 44)

                                VStack(alignment: .leading, spacing: 0) {
                                    Text(fortune.userName)
                                    Text(fortune.fortuneQuestion)
                                        .lineLimit(1)
                                }
                                    .font(.customFontSubheadline)

                                Spacer()

                                VStack(spacing: 0) {
                                    Text(fortune.fortuneDate.formatted(date: .abbreviated, time: .omitted))
                                    Text(fortune.fortuneDate.formatted(date: .omitted, time: .shortened))
                                }
                                    .font(.customFontFootnote)
                            }
                                .fullScreenCover(item: $tappedFortuneHistoryItem) { tappedFortuneHistoryItem in
                                FortuneReadingView(showingFortuneSheet: $showingFortuneSheet,
                                                   fortuneReading: tappedFortuneHistoryItem)
                            }
                        }
                    }

                        .onDelete { indexSet in
                        fortuneHistory.fortunes.remove(atOffsets: indexSet)
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

                    Image("EmptyHistoryPageImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 300)
                        .saturation(0)


                    Text("Your history is empty")
                        .font(.customFontTitle3)

                    Button {
                        showingFortuneSheet.toggle()
                    } label: {
                        Text("Read Fortune")
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color.marcanaBlue)
                            .cornerRadius(50)
                            .foregroundColor(.text)
                            .shadow(radius: 8)
                            .padding(.horizontal, UIValues.bigButtonHPadding)
                    }

                }
                    .fullScreenCover(isPresented: $showingFortuneSheet) {
                    // Default selection is the 1 card reader.
                    GetFortuneQuestionView(fortuneType: .with1card,
                                           showingFortuneSheet: $showingFortuneSheet)
                }
            }
        }
            .navigationTitle("History")
    }
}

struct FortuneHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FortuneHistoryView()
                .preferredColorScheme(.dark)
        }
    }
}
