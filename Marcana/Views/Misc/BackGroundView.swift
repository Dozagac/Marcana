//
//  BackGroundView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 07/12/2022.
//

import Foundation
import SwiftUI
import AVKit


struct VideoBackgroundView: View {
    @State private var player = AVPlayer()
    var videoFileName: String // "candleVideo", "tarotTableVideo"
    var playRate: Float = 1
    var myOpacity: Double = 0.5
    var myBlur: Double = 2
    var body: some View {
        ZStack {
            GeometryReader { geo in
                PlayerView(forResource: videoFileName, withExtension: "mp4" , playRate: playRate)
//                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width, height: geo.size.height + 100)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(Color.black.opacity(myOpacity))
                    .blur(radius: myBlur)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .ignoresSafeArea(.all)
    }
}


struct BackgroundView: View {
    var body: some View {
        ZStack {
            Color.marcanaBackground
        }
        .ignoresSafeArea()
    }
}



struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
//        VideoBackgroundView(videoFileName: "candleVideo", playRate: 0.8)
        BackgroundView()
    }
}

