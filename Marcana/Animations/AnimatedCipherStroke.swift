//
//  SwiftUIView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 13/01/2023.
//

import SwiftUI

struct AnimatedCipherStroke: View {
    @State private var animating = false

    var duration: CGFloat = 8
    var minSize: CGFloat = 300
    var maxSize: CGFloat = 330

    var body: some View {
        ZStack {
            // animating has to be accessible to an outside view for this to animate... don't know why.
            Color.clear.ignoresSafeArea()
            let strokeStyle = StrokeStyle(
                lineWidth: animating ? 10 : 2,
                lineCap: .butt,
                dash: [20, 10, 5],
                dashPhase: animating ? 105 : 0
            )

            Circle()
                .stroke(style: strokeStyle)
                .stroke(style: strokeStyle)
                .stroke(lineWidth: 2)
            // or use padding, it is a pushout view.
            .frame(width: animating ? maxSize : minSize)
                .animation(Animation.linear(duration: duration).repeatForever(autoreverses: true),
                           value: animating)
                .foregroundStyle(LinearGradient(colors: [.green, .yellow],
                                                startPoint: .topLeading, endPoint: .bottomTrailing))
        }

            .onAppear {
            animating.toggle()
        }
    }
}



struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedCipherStroke()
            .preferredColorScheme(.dark)
    }
}
