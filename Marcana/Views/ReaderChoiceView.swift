//
//  ContentView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//

// http://www.aquatictarot.de/deck/list_major.html
// https://gist.github.com/ajzeigert/32461d73c17cfd8fd475c0049db451f5

import SwiftUI


struct ReaderChoiceView: View {
    @EnvironmentObject var newUser: User

    var body: some View {
        ZStack {
            BackgroundView() // this way the Vstack still respects the safe area
            VStack {

                VStack {
                    Text(newUser.name)
                    Text(newUser.relationship)
                }

                NavigationLink(destination: GetUserQuestionView(), label: {
                    GetFortuneButton(
                        title: "Get Fortune Reading",
                        subtitle: "Ask a question to Aurelion",
                        imageName: "threeReader")
                })

            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Welcome")
        }
    }
}


struct GetFortuneButton: View {
    let title: String
    let subtitle: String
    let imageName: String

    var body: some View {
        NavigationLink(destination: GetUserQuestionView(), label: {
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
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ReaderChoiceView()
                    .environmentObject(User())
                    .preferredColorScheme(.dark)
            }
        }
    }
}






