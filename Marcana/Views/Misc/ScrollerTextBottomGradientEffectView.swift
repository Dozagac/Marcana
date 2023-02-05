//
//  SwiftUIView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 01/02/2023.
//

import SwiftUI


struct ScrollerTextBottomGradientEffectView: View {
    var effectColor: Color
    var body: some View {
        Group{
            // Put a Zstack with bottom alignment over a scrollview and put this below the scrollview in the ZStack
            // ZStack should also have the modifier: .edgesIgnoringSafeArea(.bottom)
            effectColor
                .frame(height: 70)
                .padding(-15) /// expand the effect a bit to cover the edges
                .mask(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .black, location: 0),
                        .init(color: .clear, location: 1)
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                ))
        }
    }
}

struct ScrollerTextBottomGradientEffectView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollerTextBottomGradientEffectView(effectColor: .red)
    }
}
