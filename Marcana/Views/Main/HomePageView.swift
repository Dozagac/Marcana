//
//  ContentView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//

// http://www.aquatictarot.de/deck/list_major.html
// https://gist.github.com/ajzeigert/32461d73c17cfd8fd475c0049db451f5

import SwiftUI

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
    
    var title:String{
        switch self {
        case .with1card:
            return "Daily Fortune"
        case .with3cards:
            return "Past - Present - Future"
        case .with5cards:
            return "Full Spread???"
        }
    }
    
    var subtitle: String{
        switch self {
        case .with1card:
            return "Pick a card"
        case .with3cards:
            return "Pick 3 cards"
        case .with5cards:
            return "Pick 5 cards"
        }
    }
    
    var durationText: String{
        switch self {
        case .with1card:
            return "1 min"
        case .with3cards:
            return "2 min"
        case .with5cards:
            return "5 min"
        }
    }
}

struct HomePageView: View {
    @AppStorage(wrappedValue: "", "userName") var userName
    let appearance = UINavigationBarAppearance()

    // This is so that buttons can launch the same cover sheet with a different parameter value in it
    // which is the fortuneType
    @State var showingFortuneSheet1CardFortune = false
    @State var showingFortuneSheet3CardFortune = false

    var body: some View {
        ZStack {
//            BackgroundView()
            Image("purpleVineBackground")
                .resizable()
                .scaledToFill()
                .opacity(0.2)
                .ignoresSafeArea(.all)

            VStack(spacing: 24) {
                FortuneTypeSelectionButton(
                    fortuneType: .with1card,
                    colors: [.marcanaPink, .marcanaPink.opacity(0.8)],
                    showingFortuneSheet: $showingFortuneSheet1CardFortune
                )
                    .fullScreenCover(isPresented: $showingFortuneSheet1CardFortune) {
                    GetFortuneQuestionView(
                        fortuneType: .with1card,
                        showingFortuneSheet: $showingFortuneSheet1CardFortune
                    )
                }

                FortuneTypeSelectionButton(
                    fortuneType: .with3cards,
                    colors: [.marcanaBlue, .marcanaBlue.opacity(0.8)],
                    showingFortuneSheet: $showingFortuneSheet3CardFortune
                )
                    .fullScreenCover(isPresented: $showingFortuneSheet3CardFortune) {
                    GetFortuneQuestionView(
                        fortuneType: .with3cards,
                        showingFortuneSheet: $showingFortuneSheet3CardFortune
                    )
                }


            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Welcome \(userName)")

        }
    }
}

struct FortuneTypeSelectionButton: View {
    var fortuneType: FortuneType
    var colors: [Color]
    @Binding var showingFortuneSheet: Bool


    var body: some View {
        Button {
            showingFortuneSheet.toggle()
        } label: {
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
                        .minimumScaleFactor(0.5) }
                Spacer()
            }
                .frame(width: 300, height: 200)
                .background(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.5), radius: 5)
                .overlay{
                    Text(fortuneType.durationText)
                        .foregroundColor(.text)
                        .font(.customFontCaption)
                        .padding(2)
                        .background(.ultraThinMaterial)
                }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                HomePageView()
                    .environmentObject(UserOO())
                    .preferredColorScheme(.dark)
            }
        }
    }
}






