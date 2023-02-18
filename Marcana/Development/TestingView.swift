//
//  TestingView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 17/02/2023.
//

import SwiftUI

struct TestingView: View {
    var body: some View {
        GeometryReader{ geo in
            HStack {
                HStack{
                    FortuneTypeSelectionButton(
                        fortuneType: .with1card,
            //                                colors: [.marcanaPink, .marcanaPink.opacity(0.7)],
                        showingFortuneSheet: .constant(false),
                        geoProxy: geo
                    )
                }
            }
        }
        
            .frame(width: 400, height: 300)
    }
}

struct TestingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TestingView()
                .navigationTitle("testing")
        }
    }
}
