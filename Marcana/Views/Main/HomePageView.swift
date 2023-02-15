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
    @AppStorage(wrappedValue: true, "doUserInfoFlow") var doUserInfoFlow

    // This is so that buttons can launch the same cover sheet with a different parameter value in it
    // which is the fortuneType
    @State var showingFortuneSheet1CardFortune = false
    @State var showingFortuneSheet3CardFortune = false

    @State var showingVolumeControlSheet = false

    var userDataManager = UserDataManager()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ImageBackgroundView(imageName: "Vine4")

                VStack(spacing: 24) {

                    // MARK: - Welcome text
                    HStack {
                        CustomLargeNavTitleText(text: "Welcome \(userName)")

                        Spacer()

                        //MARK: - Music control button
                        Button {
                            showingVolumeControlSheet = true
                        } label: {
                            VStack(spacing: 0) {
                                Image("IconMusicNote")
                                    .foregroundColor(.text)
                                    .frame(width: 44, height: 44)
                                    
                                    .background(
                                    Color.clear
                                        .blurEffect() // from SwiftUIVisualEffects, looks better than ultrathin
                                )

                                    .cornerRadius(12)
                                    .foregroundColor(.white)

                                Text("Music")
                                    .font(.customFontCaption)
                                    .foregroundColor(.text)
                            }
                        }
                    }
                        .padding(.top)
                        .padding(.horizontal, UIValues.HPadding)
                        .sheet(isPresented: $showingVolumeControlSheet) {
                        MusicVolumeControlView(geoProxy: geo)
                            .presentationDetents([.fraction(0.15), .fraction(0.15)])
                    }

                    Spacer()

                    VStack(spacing: 24) {
                        FortuneTypeSelectionButton(
                            fortuneType: .with1card,
                            colors: [.marcanaPink, .marcanaPink.opacity(0.7)],
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
                            colors: [.marcanaBlue, .marcanaBlue.opacity(0.7)],
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

                    Spacer()
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
                .onAppear {
                // Make sure that there is no missing user data for the fortune flow
                if userDataManager.thereIsMissingData {
                    doUserInfoFlow = true
                }
            }
                .onFirstAppear {
                MusicPlayer.shared.play()
            }
        }
    }
}


struct FortuneTypeSelectionButton: View {
    var fortuneType: FortuneType
    var colors: [Color]
    @Binding var showingFortuneSheet: Bool
    var geoProxy: GeometryProxy

    var body: some View {
        Button {
            showingFortuneSheet.toggle()
        } label: {
            ZStack {
                VStack(spacing: 0) {
                    // MARK: CARD IMAGE
                    Image(fortuneType.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .shadow(radius: 5)
                    VStack(alignment: .center, spacing: 0) {
                        //MARK: CARD TITLE
                        Text(fortuneType.title)
                            .font(.customFontHeadline.bold())
                            .foregroundColor(.text)
                            .minimumScaleFactor(0.5)
                            .foregroundStyle(.ultraThinMaterial)
                        //MARK: CARD SUBTITLE
                        Text(fortuneType.subtitle)
                            .font(.customFontCallout.bold())
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)

                        //MARK: - Complexity Text
                        HStack(alignment: .top, spacing: 0) {
                            Text("Detail Level: ")

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
                }
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal, UIValues.HPadding)
                    .shadow(color: .black.opacity(0.5), radius: 5)
                    .overlay {
                    ZStack {
                        VStack {
                            Spacer()
                            HStack {
                                HStack(spacing: 2) {
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
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 36)
                                        .preferredColorScheme(.light)

                                    Spacer()
                                }

                                Spacer()
                            }

                        }
                    }
                }
            }
        }
    }
}


struct MusicVolumeControlView: View {
    // https://www.donnywals.com/presenting-a-partially-visible-bottom-sheet-in-swiftui-on-ios-16/
    @AppStorage("backgroundMusicVolume") var musicVolume: Double = 0.5
    let geoProxy: GeometryProxy
    var body: some View {
        ZStack {
            HStack {
                Image(systemName: "speaker.wave.1")
                Slider(value: $musicVolume, in: 0...1)
                    .onReceive([self.musicVolume].publisher.first()) { value in
                    MusicPlayer.shared.player?.volume = Float(value)
                }
                    .frame(width: geoProxy.size.width * 0.6)
                    .accentColor(.marcanaBlue)
                Image(systemName: "speaker.wave.3")
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // needs this volume for backgroun blur effect

                .background(BackgroundBlurView())
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

struct CustomLargeNavTitleText: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.custom("Palatino-Bold", size: 34)) // too custom?
        .fontWeight(.black)
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




