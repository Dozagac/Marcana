//
//  TestingView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 23/12/2022.
//

import SwiftUI

struct TestingView: View {
    @State private var animating = false

    var body: some View {
        ZStack {
            BackgroundView()
//            AnimatedStrokeStyleExamples()
            ZStack() {
                // animating has to be accessible to an outside view for this to animate... don't know why.
                Color.clear.ignoresSafeArea()
                let strokeStyle = StrokeStyle(
                    lineWidth: animating ? 10 : 2,
                    dash: [20, 10, 5],
                    dashPhase: animating ? 105 : 0
                )

                Circle()
                    .stroke(style: strokeStyle)
                    .stroke(style: strokeStyle)
                    .stroke(lineWidth: 2)
                    .animation(Animation.linear(duration: 5).repeatForever(autoreverses: true),
                               value: animating)
                    .foregroundStyle(LinearGradient(colors: [.yellow, .icon],
                                                    startPoint: .topLeading, endPoint: .bottomTrailing))
                // or use padding, it si a pushout view.
                    .frame(width: 100, height: 100)
            }.onAppear{
                animating.toggle()
            }
        }
    }
}

struct AnimatedStrokeStyleExample: View {
    @State private var animating = true
    var body: some View {
        ZStack() {
            // animating has to be accessible to an outside view for this to animate... don't know why.
            Color.clear.ignoresSafeArea()
            let strokeStyle = StrokeStyle(
                lineWidth: animating ? 10 : 2,
                dash: [20, 10, 5],
                dashPhase: animating ? 105 : 0
            )

            Circle()
                .stroke(style: strokeStyle)
                .stroke(style: strokeStyle)
                .stroke(lineWidth: 2)
                .animation(Animation.linear(duration: 5).repeatForever(autoreverses: true),
                           value: animating)
                .foregroundStyle(LinearGradient(colors: [.yellow, .icon],
                                                startPoint: .topLeading, endPoint: .bottomTrailing))
            // or use padding, it si a pushout view.
                .frame(width: 100, height: 100)
        }
    }
}




struct AnimatedStrokeStyleExampleOriginal: View {
    @State private var animating = true
    var body: some View {
        ZStack() {
            Color.clear.ignoresSafeArea()
            let strokeStyle = StrokeStyle(
                lineWidth: animating ? 10 : 2,
                dash: [20, 10, 5],
                dashPhase: animating ? 105 : 0
            )

            Circle()
                .stroke(style: strokeStyle)
                .stroke(style: strokeStyle)
                .stroke(lineWidth: 2)
                .animation(Animation.linear(duration: 5).repeatForever(autoreverses: true),
                           value: animating)
                .foregroundStyle(LinearGradient(colors: [.red, .purple],
                                                startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()

        }
    }
}

struct TestingView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
    }
}
