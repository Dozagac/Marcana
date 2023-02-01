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
    
    // This is so that buttons can launch the same cover sheet with a different parameter value in it
    // which is the fortuneType
    @State var showingFortuneSheet1CardFortune = false
    @State var showingFortuneSheet3CardFortune = false

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(spacing: 24) {
                FortuneTypeSelectionButton(
                    title: "Daily Fortune",
                    subtitle: "Pick a card",
                    imageName: "singleCardReader",
                    colors: [.marcanaPink, .marcanaPink.opacity(0.5)],
                    showingFortuneSheet: $showingFortuneSheet1CardFortune
                )
                .fullScreenCover(isPresented: $showingFortuneSheet1CardFortune) {
                GetFortuneQuestionView(
                    fortuneType: .with1card,
                    showingFortuneSheet: $showingFortuneSheet1CardFortune
                )
            }



                FortuneTypeSelectionButton(
                    title: "Past - Present - Future",
                    subtitle: "Pick 3 cards",
                    imageName: "threeCardReader",
                    colors: [.marcanaBlue, .marcanaBlue.opacity(0.5)],
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
    var title: String
    var subtitle: String
    var imageName: String
    var colors: [Color]
    @Binding var showingFortuneSheet: Bool


    var body: some View {
        Button {
            showingFortuneSheet.toggle()
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
                        .font(.customFontHeadline)
                        .foregroundColor(.text)
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(.ultraThinMaterial)
                    //MARK: CARD SUBTITLE
                    Text(subtitle)
                        .font(.customFontSubheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5) }
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






