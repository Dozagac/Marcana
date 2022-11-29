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
        VStack {
            NavigationLink(destination: SingleReaderView(), label: {
                ChooseReaderButtonView(buttonInfo: startButton(
                    title: "Read 1 card",
                    subtitle: "Read the vibe of the day",
                    imageName: "threeReader"))
            })

            Spacer().frame(height: 24)

            NavigationLink(destination: ThreeReaderView(), label: {
                ChooseReaderButtonView(buttonInfo: startButton(
                    title: "Read 3 cards",
                    subtitle: "Seek answers to a question",
                    imageName: "singleReader"))
            })
        }
            .navigationBarTitle("Start Screen")
    }
}


struct startButton {
    let title: String
    let subtitle: String
    let imageName: String

    static let example = startButton(
        title: "Read 1 card",
        subtitle: "seek answers to a question",
        imageName: "threeReader")
}


struct ChooseReaderButtonView: View {
    let buttonInfo: startButton

    var body: some View {
        VStack(alignment: .leading) {
            Image(buttonInfo.imageName)
                .resizable()
                .frame(width: 200, height: 200)
                .scaledToFit()

            cardText
                .padding(.horizontal, 8)
        }
            .frame(width: 200)
            .background()
            .clipShape(RoundedRectangle(cornerRadius: 24.0))
            .shadow(color: .cyan, radius: 8)
    }

    var cardText: some View {
        VStack (alignment: .leading) {
            Text(buttonInfo.title)
                .font(.headline)
                .foregroundColor(.primary)
                .minimumScaleFactor(0.5)

            Text(buttonInfo.subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }.padding(.bottom, 12)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



