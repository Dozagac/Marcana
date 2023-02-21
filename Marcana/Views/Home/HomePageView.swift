//
//  ContentView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//

// http://www.aquatictarot.de/deck/list_major.html
// https://gist.github.com/ajzeigert/32461d73c17cfd8fd475c0049db451f5

import SwiftUI
import SwiftUIVisualEffects


struct HomePageView: View {
    @AppStorage(wrappedValue: "", UserDataManager.UserKeys.userName.rawValue) var userName
    @AppStorage(wrappedValue: true, DefaultKeys.doUserInfoFlow) var doUserInfoFlow

    // This is so that buttons can launch the same cover sheet with a different parameter value in it
    // which is the fortuneType
    @State var showingFortuneSheet1CardFortune = false
    @State var showingFortuneSheet3CardFortune = false

    var userDataManager = UserDataManager()

    @StateObject var musicPlayer = MusicPlayer.shared
    @State var isPlaying = false // this is necessary, musicPlayer.player.isPlaying is not working for some reason

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ImageBackgroundView(imageName: "Vine4")

                VStack(spacing: 24) {

                    // MARK: - Welcome text
                    HStack(alignment: .top) {

                        // MARK: - Profile Button
                        NavigationLink {
                            UserProfileView()
                                .transition(.move(edge: .bottom))
                        } label: {
                            VStack(spacing: 2) {
                                Image(systemName: "person.fill")
                                    .frame(width: 44, height: 44)
                                    .background(
                                    Color.clear
                                        .blurEffect() // from SwiftUIVisualEffects, looks better than ultrathin
                                )
                                    .cornerRadius(50)
                                    .foregroundColor(.white)
                                    .foregroundColor(.text)
                            }

                        }

                        VStack(alignment: .leading, spacing: -4) {
                            Text("Greetings")
                                .font(.custom("Palatino-Bold", size: 24)) // too custom?
                            .fontWeight(.black)
                            Text("\(userName)")
                                .font(.customFontBody)
                        }

                        Spacer()


                        //MARK: - Settings button
                        NavigationLink {
                            SettingsView()
                        } label: {
                            VStack(spacing: 0) {
                                Image(systemName: "gearshape.fill")
                                    .foregroundColor(.text)
                                    .frame(width: 44, height: 44)
                                    .background(
                                    Color.clear
                                        .blurEffect() // from SwiftUIVisualEffects, looks better than ultrathin
                                )
                                    .cornerRadius(12)
                                    .foregroundColor(.white)

                                Text("Settings")
                                    .font(.customFontCaption)
                            }
                        }
                    }
                        .foregroundColor(.text)
                        .padding(.top)
                        .padding(.horizontal, UIValues.HPadding)

                    Spacer()

                    // MARK: - Fortune Selection Buttons
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            FortuneTypeSelectionButton(
                                fortuneType: .with1card,
//                                colors: [.marcanaPink, .marcanaPink.opacity(0.7)],
                                showingFortuneSheet: $showingFortuneSheet1CardFortune,
                                geoProxy: geo
                            )
                                .fullScreenCover(isPresented: $showingFortuneSheet1CardFortune) {
                                GetFortuneQuestionView(
                                    fortuneType: .with1card,
                                    showingFortuneSheet: $showingFortuneSheet1CardFortune
                                )
                            }

                            FortuneTypeSelectionButton(
                                fortuneType: .with3cards,
//                                colors: [.marcanaBlue, .marcanaBlue.opacity(0.7)],
                                showingFortuneSheet: $showingFortuneSheet3CardFortune,
                                geoProxy: geo
                            )
                                .fullScreenCover(isPresented: $showingFortuneSheet3CardFortune) {
                                GetFortuneQuestionView(
                                    fortuneType: .with3cards,
                                    showingFortuneSheet: $showingFortuneSheet3CardFortune
                                )
                            }
                        }
                            .padding(.vertical, 4)
                            .padding(.horizontal, geo.size.width * 0.1)
                    }
                    HStack(spacing: 24) {
                        // MARK: - Deck Button
                        NavigationLink {
                            DeckInfoView()
                        } label: {
                            VStack(spacing: 2) {
                                Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled.fill")
                                    .frame(width: 44, height: 44)
                                    .background(
                                    Color.clear
                                        .blurEffect() // from SwiftUIVisualEffects, looks better than ultrathin
                                )
                                    .cornerRadius(12)
                                    .foregroundColor(.white)
                                    .foregroundColor(.text)
                                Text("Deck")
                                    .font(.customFontCaption)
                            }
                        }

                        // MARK: - History Button
                        NavigationLink {
                            FortuneHistoryView()
                        } label: {
                            VStack(spacing: 2) {
                                Image(systemName: "book.fill")
                                    .frame(width: 44, height: 44)
                                    .background(
                                    Color.clear
                                        .blurEffect() // from SwiftUIVisualEffects, looks better than ultrathin
                                )
                                    .cornerRadius(12)
                                    .foregroundColor(.white)
                                    .foregroundColor(.text)
                                Text("History")
                                    .font(.customFontCaption)
                            }
                        }

                        //MARK: - Music control button
                        Button {
                            musicPlayer.togglePlayPause()
                            isPlaying = musicPlayer.player.isPlaying
                        } label: {
                            VStack(spacing: 0) {
                                Image(systemName: isPlaying ? "speaker.wave.2.fill" : "speaker.slash.fill")
                                    .foregroundColor(isPlaying ? .text : .gray)
                                    .frame(width: 44, height: 44)
                                    .background(
                                    Color.clear
                                        .blurEffect() // from SwiftUIVisualEffects, looks better than ultrathin
                                )
                                    .cornerRadius(12)
                                    .foregroundColor(.white)

                                Text("Music")
                                    .font(.customFontCaption)
                            }
                        }

                    }
                        .foregroundColor(.text)
                        .padding(.horizontal, UIValues.HPadding)
                        .padding(.bottom, 40)
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
                .onAppear {
                // Make sure that there is no missing user data for the fortune flow
                if userDataManager.thereIsMissingData {
                    doUserInfoFlow = true
                }
            }
        }
//        .navigationTitle("")
    }
}


struct FortuneTypeSelectionButton: View {
    var fortuneType: FortuneType
//    var colors: [Color]
    @Binding var showingFortuneSheet: Bool
    var geoProxy: GeometryProxy

    var body: some View {
        Button {
            showingFortuneSheet.toggle()
        } label: {
            ZStack {
                VStack(spacing: 12) {
                    Spacer()
                    // MARK: CARD IMAGE
                    Image(fortuneType.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .shadow(radius: 5)

                    VStack(alignment: .center, spacing: 0) {
                        //MARK: CARD TITLE
                        Text(fortuneType.title)
                            .font(.customFontTitle3.bold())
                            .foregroundColor(.text)
                            .minimumScaleFactor(0.5)
                            .foregroundStyle(.ultraThinMaterial)

                        //MARK: CARD SUBTITLE
                        Text(fortuneType.subtitle)
                            .font(.customFontBody.bold())
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)

                        //MARK: - Complexity Text
                        HStack(alignment: .top, spacing: 0) {
                            Text("Detail Level: ")
                                .font(.customFontBody)
                            ForEach(1..<fortuneType.detailLevel) { _ in
                                Image(systemName: "star.fill")

                            }
                                .foregroundColor(.yellow)

                        }
                            .font(.customFontCallout)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }

                    Spacer()

                    //MARK: CTA Button
                    Text("Start")
                        .font(.customFontBody.bold())
                        .padding()
                        .frame(width: 250)
                        .background(.white)
                        .foregroundColor(.black)
                        .cornerRadius(50)
                        .padding(.bottom, 24)

                }


                    .frame(width: geoProxy.size.width * 0.8, height: 500)
                    .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.text, lineWidth: 2)
                )

                //MARK: - Fortune time indicator overlay
                .overlay(alignment: .topLeading) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text(fortuneType.durationText)
                            .fontWeight(.bold)
                    }
                        .foregroundColor(.text)
                        .font(.customFontCaption2)
                        .padding(2)
                        .background(.black.opacity(0.2))
                        .cornerRadius(4)
                        .padding()
                }
            }
        }
    }
}


enum FortuneType: String, Codable {
    case with1card, with3cards, with5cards

    var iconName: String {
        switch self {
        case .with1card:
            return "Icon1Card"
        case .with3cards:
            return "Icon3Cards"
        case .with5cards:
            return "Icon5Cards"
        }
    }

    var imageName: String {
        switch self {
        case .with1card:
            return "singleCardReader"
        case .with3cards:
            return "threeCardReader"
        case .with5cards:
            return "fiveCardReader"
        }
    }

    var title: String {
        switch self {
        case .with1card:
            return "Daily Fortune"
        case .with3cards:
            return "Past - Present - Future"
        case .with5cards:
            return "5 - Card Spread"
        }
    }

    var subtitle: String {
        switch self {
        case .with1card:
            return "Pick a card"
        case .with3cards:
            return "Pick 3 cards"
        case .with5cards:
            return "Pick 5 cards"
        }
    }

    var detailLevel: Int {
        switch self {
        case .with1card:
            return 1 + 1
        case .with3cards:
            return 2 + 1
        case .with5cards:
            return 3 // update these when implementing 5 card reader
        }
    }

    var durationText: String {
        switch self {
        case .with1card:
            return "1 MIN"
        case .with3cards:
            return "2 MIN"
        case .with5cards:
            return "5 MIN"
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                HomePageView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}




