//
//  TestingView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 10/01/2023.
//

import SwiftUI
import AnimateText

//fullName.components(separatedBy: " ")

struct TestingView: View {
    @State private var currentPage = 0

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                Text("Page 1")
                    .tabItem {
//                    Image(systemName: "1.circle")
                    Text("Page 1")
                }
                    .tag(0)
                Text("Page 2")
                    .tabItem {
//                    Image(systemName: "2.circle")
                    Text("Page 2")
                }
                    .tag(1)
                Text("Page 3")
                    .tabItem {
//                    Image(systemName: "3.circle")
                    Text("Page 3")
                }
                    .tag(2)
            }
                .tabViewStyle(.page)
                .animation(.spring(), value:currentPage)

            Button(action: {
                if self.currentPage + 1 < 3 {
                    self.currentPage += 1
                }
            }) {
                Text("Continue")
            }
        }
    }
}


struct TestingView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
            .preferredColorScheme(.dark)
    }
}


//struct FortuneTypeSelectionButtonOLD: View {
//    let title: String
//    let subtitle: String
//    let imageName: String
//
//    var body: some View {
//        NavigationLink(destination: GetFortuneQuestionView(), label: {
//            VStack() {
//                // MARK: CARD IMAGE
//                Image(imageName)
//                    .resizable()
//                    .scaledToFill()
//                VStack(alignment: .leading) {
//                    //MARK: CARD TITLE
//                    Text(title)
//                        .font(.mediumLargeFont)
//                        .foregroundColor(.primary)
//                        .minimumScaleFactor(0.5)
//                    //MARK: CARD SUBTITLE
//                    Text(subtitle)
//                        .font(.mediumFont)
//                        .foregroundColor(.secondary)
//                        .lineLimit(1)
//                        .minimumScaleFactor(0.5)
//                }
//                    .padding(.horizontal, 8)
//                Spacer()
//            }
//                .frame(width: 300, height: 500)
//                .background()
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .shadow(color: .icon.opacity(0.5), radius: 5)
//        })
//    }
//}
