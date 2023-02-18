//
//  HeartLikePopAnimation.swift
//  Marcana
//
//  Created by Deniz Ozagac on 12/02/2023.
//

// KavSoft: https://www.youtube.com/watch?v=GL7rOveSAKk

import SwiftUI


struct HeartLikeExampleView: View {

    @State private var liked = false
    var body: some View {
        Button {
            liked.toggle()
        } label: {
            Image("facedownCard2")
                .resizable()
                .frame(width: 200, height: 300)
        }
            .overlay(
            HeartLikePopAnimation(isLiked: $liked)
        )
    }

}


struct HeartLikePopAnimation: View {

    // Animation Properites....
    @Binding var isLiked: Bool {
        willSet { // has to be willSet
            if isLiked {
                liked()
            }
        }
    }

    @State var startAnimation = false
    @State var bgAnimation = false
    // Resetting Bg....
    @State var resetBG = false
    @State var fireworkAnimation = false

    @State var animationEnded = false

    // To Avoid Taps during Animation...
    @State var tapComplete = false

    var body: some View {

        // Heart Like Animation....
        Image(systemName: resetBG ? "heart.fill" : "heart")
            .font(.system(size: 45))
            .foregroundColor(resetBG ? .red : .gray)
        // Scaling...
        .scaleEffect(startAnimation && !resetBG ? 0 : 1)
            .opacity(startAnimation && !animationEnded ? 1 : 0)
        // BG...
        .background(
            ZStack {

                CustomShape(radius: resetBG ? 29 : 0)
                    .fill(Color.red) // was purple
                .clipShape(Circle())
                // Fixed Size...
                .frame(width: 50, height: 50)
                    .scaleEffect(bgAnimation ? 2.2 : 0)

                ZStack {

                    // random Colors..
//                        let colors: [Color] = [.red,.purple,.green,.yellow,.pink]
                    let colors: [Color] = [.red, .red, .red, .red, .red]

                    ForEach(1...6, id: \.self) { index in

                        Circle()
                            .fill(colors.randomElement()!)
                            .frame(width: 12, height: 12)
                            .offset(x: fireworkAnimation ? 80 : 40)
                            .rotationEffect(.init(degrees: Double(index) * 60))
                    }

                    ForEach(1...6, id: \.self) { index in

                        Circle()
                            .fill(colors.randomElement()!)
                            .frame(width: 8, height: 8)
                            .offset(x: fireworkAnimation ? 64 : 24)
                            .rotationEffect(.init(degrees: Double(index) * 60))
                            .rotationEffect(.init(degrees: -45))
                    }
                }
                    .opacity(resetBG ? 1 : 0)
                    .opacity(animationEnded ? 0 : 1)
            }
        )
            .contentShape(Rectangle())
            .onChange(of: isLiked) { newValue in
            if isLiked && !startAnimation {
                // setting everything to true...
                updateFields(value: true)
            }

            if !isLiked {
                updateFields(value: false)
            }
        }
    }

    func liked() {
        if tapComplete {

            updateFields(value: false)
            // resetting back...
            return
        }


        if startAnimation {
            return
        }

        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {

            startAnimation = true
        }

        // Sequnce Animation...
        // Chain Animation...
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {

            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)) {

                bgAnimation = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {

                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {

                    resetBG = true
                }

                // Fireworks...
                withAnimation(.spring()) {
                    fireworkAnimation = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {

                    withAnimation(.easeOut(duration: 0.4)) {
                        animationEnded = true
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        tapComplete = true
                    }
                }
            }
        }
    }

    func updateFields(value: Bool) {

        startAnimation = value
        bgAnimation = value
        resetBG = value
        fireworkAnimation = value
        animationEnded = value
        tapComplete = value
        isLiked = value
    }
}

// Custom Shape
// For Resetting from center...
struct CustomShape: Shape {

    // value...
    var radius: CGFloat

    // animating Path...
    var animatableData: CGFloat {
        get { return radius }
        set { radius = newValue }
    }

    // Animatable path wont work on previews....

    func path(in rect: CGRect) -> Path {

        return Path { path in

            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))

            // adding Center Circle....
            let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
            path.move(to: center)
            path.addArc(center: center, radius: radius, startAngle: .zero, endAngle: .init(degrees: 360), clockwise: false)
        }
    }
}


struct HeartLikeExampleView_Previews: PreviewProvider {
    static var previews: some View {
        HeartLikeExampleView()
    }
}
