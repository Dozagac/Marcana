//
//  ContentView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//

// http://www.aquatictarot.de/deck/list_major.html
// https://gist.github.com/ajzeigert/32461d73c17cfd8fd475c0049db451f5

import SwiftUI


struct ContentView: View {
    var body: some View {
        ZStack {
            BackgroundView() // this way the Vstack still respects the safe area
            VStack {

                NavigationLink(destination: ThreeCardSelectionView(), label: {
                    SelectionCardView(
                        title: "Read 1 card",
                        subtitle: "Read the vibe of the day",
                        imageName: "threeReader")
                })

            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Welcome")
        }
    }
}


struct SelectionCardView: View {
    let title: String
    let subtitle: String
    let imageName: String

    var body: some View {
        HStack() {
            // MARK: CARD IMAGE
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 140)
            VStack(alignment: .leading) {
                //MARK: CARD TITLE
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.5)
                //MARK: CARD SUBTITLE
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
                .padding(.horizontal, 8)
            Spacer()
        }
            .frame(width: 300, height: 140)
            .background()
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .icon, radius: 10)
            .padding(40)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ContentView()
            }

            NavigationView {
                ContentView()
            }.preferredColorScheme(.dark)
        }
    }
}






