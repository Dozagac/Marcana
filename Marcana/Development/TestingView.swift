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
    @State var response = ""

    var dummyText = """
            The figure calls for no special description the face is rather dark, suggesting also courage, but somewhat lethar
            """

    @State var loadingText: String = ""
    @State var type: ATUnitType = .letters // The type used to split text.
    @State var userInfo: Any? = nil // Custom user info for the effect.


    var body: some View {
        VStack {
            AnimateText<ATOpacityEffect>($response, type: type, userInfo: userInfo)

            HStack {
                Button("text1") {
                    response = dummyText
                }
                    .frame(width: 100, height: 50)
                    .background(.green)

                Button("text2") {
                    response = "testin testin"
                }
                    .frame(width: 100, height: 50)
                    .background(.red)
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
//        NavigationLink(destination: GetUserQuestionView(), label: {
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
