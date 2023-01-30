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


    var body: some View {
        ZStack {
            BackgroundView()

            if fortuneHistory.fortunes.isNotEmpty {
                List {
                    ForEach(fortuneHistory.fortunes) { fortune in
                        NavigationLink {
                            ScrollView(showsIndicators: false) {
                                Text(fortune.fortuneText)
                                    .font(.mediumLargeFont)
                            }
                                .padding(.horizontal)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(fortune.userName)
                                    Text(fortune.fortuneQuestion)
                                }
                                    .font(.mediumFont)

                                Spacer()

                                VStack(spacing: 0) {
                                    Text(fortune.fortuneDate.formatted(date: .abbreviated, time: .omitted))
                                    Text(fortune.fortuneDate.formatted(date: .omitted, time: .shortened))
                                }
                                    .font(.mediumSmallFont)
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
                VStack(spacing: 12) {
                    Image("EmptyHistoryImage")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 400, maxHeight: 400)
                        .saturation(0)
                        .opacity(1)

                    Text("Your history is empty")
                        .font(.largeFont3)
                    Button {
                        showingFortuneSheet.toggle()
                    } label: {
                        Text("Read Fortune")
                            .frame(width: 250, height: 50)
                            .background(Color.marcanaBlue)
                            .cornerRadius(12)
                            .foregroundColor(.text)
                    }
                }
                .fullScreenCover(isPresented: $showingFortuneSheet) {
                GetFortuneQuestionView()
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
