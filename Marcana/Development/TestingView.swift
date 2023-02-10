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
            Image(Deck().allCards[0].image)
                .resizable()
//                .scaledToFill()
                .frame(width: 200, height: 300)
        }
    }
}


struct TestingView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
            .preferredColorScheme(.light)
    }
}
