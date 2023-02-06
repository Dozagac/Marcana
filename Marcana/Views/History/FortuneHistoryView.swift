//
//  FortuneHistoryView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 30/01/2023.
//

import SwiftUI

struct FortuneHistoryView: View {
    @StateObject var fortuneHistory = FortuneHistory()
    @State private var showingFortuneSheet = false
    @State private var showingFortuneHistoryItem = false

    var body: some View {
        ZStack {
            BackgroundView()

            // ONLY FOR TESTING
//            if fortuneHistory.fortunes.isNotEmpty {
            if FortuneHistory.dummyFortunes.isNotEmpty {
                List {
                    // ONLY FOR TESTING
                    ForEach(FortuneHistory.dummyFortunes) { fortune in
//                    ForEach(fortuneHistory.fortunes) { fortune in
                        Button {
                            showingFortuneHistoryItem = true
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
                            .fullScreenCover(isPresented: $showingFortuneHistoryItem){
                                FortuneReadingView(showingFortuneSheet: $showingFortuneHistoryItem,
                                                   fortuneReading: fortune)
                            }
                        }
                    }

                        .onDelete { indexSet in
                        fortuneHistory.fortunes.remove(atOffsets: indexSet)
                    }
                }
                    .toolbar {
                    EditButton()
                }
            } else {
                VStack(spacing: 24) {
                    Image("EmptyHistoryPageImage")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 400, maxHeight: 400)
                        .saturation(0)
                        .opacity(1)

                    Text("Your history is empty")
                        .font(.customFontTitle3)
                    Button {
                        showingFortuneSheet.toggle()
                    } label: {
                        Text("Read Fortune")
                            .frame(width: 250, height: 50)
                            .background(Color.marcanaBlue)
                            .cornerRadius(12)
                            .foregroundColor(.text)
                            .shadow(radius: 8)
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
        NavigationView {
            FortuneHistoryView()
                .preferredColorScheme(.dark)
        }
    }
}
