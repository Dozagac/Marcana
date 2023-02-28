//
//  ContentView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//

// http://www.aquatictarot.de/deck/list_major.html
// https://gist.github.com/ajzeigert/32461d73c17cfd8fd475c0049db451f5

import SwiftUI


struct HomePageView: View {
    @AppStorage(wrappedValue: "", UserDataManager.UserKeys.userName.rawValue) var userName

    // This is so that buttons can launch the same cover sheet with a different parameter value in it
    // which is the fortuneType
    @State var showingFortuneSheet1CardFortune = false
    @State var showingFortuneSheet3CardFortune = false

    @StateObject var musicPlayer = MusicPlayerManager.shared
    @State var isPlaying = false // this is necessary, musicPlayer.player.isPlaying is not working for some reason
    @AppStorage(DefaultKeys.isMusicPlaying) var isMusicPlaying: Bool = false

    @State var userSubscriptionManager = UserSubscriptionManager.shared
    @State var showingPricingExplanationSheet = false

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
                            HStack(spacing: 8) {
                                Image(systemName: "person.fill")
                                    .frame(width: 44, height: 44)
                                    .background(
                                        .ultraThinMaterial
                                )
                                    .cornerRadius(50)
                                    .foregroundColor(.white)
                                    .foregroundColor(.text)

                                // MARK: Greeting title and User Name
                                VStack(alignment: .leading, spacing: -4) {
                                    Text("Greetings")
                                        .font(.custom("Palatino-Bold", size: 24)) // too custom?
                                    .fontWeight(.black)
                                    Text("\(userName)")
                                        .font(.customFontBody)
                                }
                            }

                        }

                        Spacer()

                        //MARK: - Music control button
                        Button {
                            musicPlayer.togglePlayPause()

                        } label: {
                            VStack(spacing: 0) {
                                Image(systemName: isMusicPlaying ? "speaker.wave.2.fill" : "speaker.slash.fill")
                                    .foregroundColor(isMusicPlaying ? .text : .gray)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        .ultraThinMaterial
                                )
                                    .cornerRadius(12)
                                    .foregroundColor(.white)
                            }
                        }

                        //MARK: - Settings button
                        NavigationLink {
                            SettingsView()
                        } label: {
                            VStack(spacing: 0) {
                                Image(systemName: "gearshape.fill")
                                    .foregroundColor(.text)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        .ultraThinMaterial
                                )
                                    .cornerRadius(12)
                                    .foregroundColor(.white)

//                                Text("Settings")
//                                    .font(.customFontCaption)
                            }
                        }
                    }
                        .foregroundColor(.text)
                        .padding(.top)
                        .padding(.horizontal, UIValues.HPadding)



                    if !userSubscriptionManager.subscriptionActive {
                        HStack {
                            Button {
                                showingPricingExplanationSheet = true
                            } label: {
                                HStack {
                                    Image(systemName: "info.circle")
                                    Text("Why is it not free?").bold()
                                }
                                    .font(.customFontBody)
                            }
                                .padding(8)
                                .background(.ultraThinMaterial)
                                .cornerRadius(25)
                                .foregroundColor(.orange)
                                .padding(.vertical, -12)

                            Spacer()
                        }
                            .padding(.horizontal, geo.size.width * 0.1)
                            .sheet(isPresented: $showingPricingExplanationSheet) {
                            PricingExplanationView()
                                .presentationDetents([.height(450)])
                        }
                    }

                    // MARK: - Fortune Selection Buttons
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            FortuneTypeSelectionButton(
                                fortuneType: .with1card,
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
//                            .padding(.vertical, 4)
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
                                        .ultraThinMaterial
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
                                        .ultraThinMaterial
                                )
                                    .cornerRadius(12)
                                    .foregroundColor(.white)
                                    .foregroundColor(.text)
                                Text("History")
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
        }
//        .navigationTitle("")
    }
}


struct FortuneTypeSelectionButton: View {
    @AppStorage(wrappedValue: 1, DefaultKeys.SingleReaderFreeTriesRemaning) var SingleReaderFreeTriesRemaning
    @AppStorage(wrappedValue: 1, DefaultKeys.ThreeReaderFreeTriesRemaning) var ThreeReaderFreeTriesRemaning
    var fortuneType: FortuneType

    var freeTriesRemaning: Int {
        switch fortuneType {
        case .with1card:
            return SingleReaderFreeTriesRemaning
        case .with3cards:
            return ThreeReaderFreeTriesRemaning
        case .with5cards:
            return ThreeReaderFreeTriesRemaning
        }
    }

    @State var userSubscriptionManager = UserSubscriptionManager.shared
    @State var showingPaywall = false

    @Binding var showingFortuneSheet: Bool
    var geoProxy: GeometryProxy

    var body: some View {
        Button {
            // Premium user with entitlement
            if userSubscriptionManager.subscriptionActive {
                showingFortuneSheet.toggle()
            } else {
                // User hasn't paid, may have trial chances
                if freeTriesRemaning > 0 {
                    showingFortuneSheet.toggle()
                } else {
                    // Launch the paywall
                    showingPaywall = true
                }
            }

        } label: {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    Spacer()
                    // MARK: CARD IMAGE
                    Image(fortuneType.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: geoProxy.size.height * 0.3)
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
                                .foregroundColor(.orange)
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
                        .background(userSubscriptionManager.subscriptionActive ? .white : freeTriesRemaning > 0 ? .white : .gray)
                        .foregroundColor(.black)
                        .cornerRadius(50)
                        .padding(.bottom, 24)
                }
                    .frame(width: geoProxy.size.width * 0.8, height: geoProxy.size.height * 0.6)
                    .background(
                    RoundedRectangle(cornerRadius: 24)
                        .tint(.gray.opacity(0.2))
//                        .background(.red.opacity(0.7))
//                        .stroke(Color.text, lineWidth: 0.5)
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
                        .padding(6)
                        .background(.black.opacity(0.5))
                        .cornerRadius(12)
                        .padding()
                }

//                .saturation(0)

            }
        }
            .fullScreenCover(isPresented: $showingPaywall) {
            PaywallView()
        }
        // saturated if user can go ahead. If not, 0
        .saturation(userSubscriptionManager.subscriptionActive ? 1 : freeTriesRemaning > 0 ? 1 : 0)
            .overlay(alignment: .topTrailing) {
            if !userSubscriptionManager.subscriptionActive {
                if freeTriesRemaning > 0 {
                    HStack {
                        Image(systemName: "lock.open.fill")
                        Text("\(freeTriesRemaning) Free Try").bold()
                    }
                        .foregroundColor(.orange)
                        .font(.customFontBody)
                        .cornerRadius(12)
                        .padding()
                } else {
                    HStack {
                        Image(systemName: "lock.fill")
                    }
                        .foregroundColor(.orange)
                        .font(.customFontlargeTitle)
                        .cornerRadius(12)
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
            return "Daily Tarot Reading"
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

    var questionSuggestionCategories: [QuestionSuggestion] {
        switch self {
        case .with1card:
            return [.daily, .love, .career, .personal, .health]
        case .with3cards:
            return [.love, .career, .personal, .health]
        case .with5cards:
            return [.love, .career, .personal, .health]
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




