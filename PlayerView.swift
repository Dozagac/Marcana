//
//  PlayerView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 12/01/2023.
//

import Foundation
import AVKit
import AVFoundation
import SwiftUI


// https://betterprogramming.pub/how-to-create-a-looping-video-background-in-swiftui-3-0-b4844553880d
// Things in this file are used for a looping video background that has no video controllers
struct PlayerView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }

    func makeUIView(context: Context) -> UIView {
        return LoopingPlayerUIView(frame: .zero)
    }
}


class LoopingPlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Load the resource -> h
        let fileUrl = Bundle.main.url(forResource: "spaceBackground", withExtension: "mp4")!
        let asset = AVAsset(url: fileUrl)
        let item = AVPlayerItem(asset: asset)
        // Setup the player
        let player = AVQueuePlayer()
        // Mute the video
        player.isMuted = true
        
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        // Create a new player looper with the queue player and template item
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
        // Start the movie
        player.play()
        // Slow down the video
        player.rate = 0.3
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
