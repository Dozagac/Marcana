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
    @AppStorage(wrappedValue: "", "userName") var userName
    let appearance = UINavigationBarAppearance()

    //MARK: - Custom title font
    init () {
//        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: FontsManager.NanumMyeongjo.extraBold, size: 34)!]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Palatino-Bold", size: 34)!]
    }

    var body: some View {
        ZStack {
            BackgroundView() // this way the Vstack shtill respects the safe area
            VStack(spacing: 24) {


                    FortuneTypeSelectionButton(
                        title: "Daily Fortune",
                        subtitle: "Pick a card",
                        imageName: "singleCardReader",
                        colors: [.marcanaPink, .marcanaPink.opacity(0.5)]
                    )
        

                    FortuneTypeSelectionButton(
                        title: "Past - Present - Future",
                        subtitle: "Pick 3 cards",
                        imageName: "threeCardReader",
                        colors: [.marcanaBlue, .marcanaBlue.opacity(0.5)]
                    )

            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .navigationTitle("Home")
            .navigationTitle("Welcome \(userName)")
        }
    }
}

struct FortuneTypeSelectionButton: View {
    var title: String //= "Daily Fortune"
    var subtitle: String //= "Pick a card"
    var imageName: String// = "threeCardReader"
    var colors: [Color]// = [.foreground,.foreground.opacity(0.5)]

    var body: some View {
        NavigationLink {
            GetFortuneQuestionView()
        } label: {
            VStack(spacing: 0) {
                // MARK: CARD IMAGE
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                VStack(alignment: .center, spacing: 0) {
                    //MARK: CARD TITLE
                    Text(title)
                        .font(.mediumLargeFont)
                        .foregroundColor(.text)
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(.ultraThinMaterial)
                    //MARK: CARD SUBTITLE
                    Text(subtitle)
                        .font(.mediumFont)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)                }
Spacer()
            }
                .frame(width: 300, height: 200)
                .background(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.5), radius: 5)
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






