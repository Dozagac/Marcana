//
//  MusicPlayer.swift
//  Marcana
//
//  Created by Deniz Ozagac on 09/02/2023.
//

import AVFoundation
import SwiftUI

//@AppStorage(wrappedValue: true, "playBackgroundMusic") var playBackgroundMusic
//if playBackgroundMusic {
//    // Start the music
//    MusicPlayer.shared.restart()
//}

class MusicPlayerManager: ObservableObject {
    static let shared = MusicPlayerManager()

    @Published var player: AVAudioPlayer
    @AppStorage(DefaultKeys.isMusicPlaying) var isMusicPlaying: Bool = false // add user defaults to store the music player state

    private init() {
        let path = Bundle.main.path(forResource: "MysticMusic.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)

        do {
            player = try! AVAudioPlayer(contentsOf: url)  //  MysticMusic.mp3 has to exist.
            player.numberOfLoops = -1 // infinite loop
            player.prepareToPlay()
            
            print("isMusicPlaying: \(isMusicPlaying)")
            // set the initial player state based on the user defaults
            if isMusicPlaying {
                player.play()
            } else {
                player.pause()
            }
            
            // so it plays in silent mode as well
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print("Could not create AVAudioPlayer:", error)
        }
    }

    func play() {
        player.play()
        isMusicPlaying = true // update user defaults
        print("isMusicPlaying: \(isMusicPlaying)")
    }

    func pause() {
        player.pause()
        isMusicPlaying = false // update user defaults
        print("isMusicPlaying: \(isMusicPlaying)")
    }
    
    func restart() {
        player.currentTime = 0
        self.play()
        isMusicPlaying = true // update user defaults
    }

    func togglePlayPause() {
        if player.isPlaying {
            self.pause()
            AnalyticsManager.shared.logEvent(eventName: AnalyticsKeys.homepageMusicTapped , properties: [AnalyticsAmplitudeEventPropertyKeys.musicPlaying : false])
        } else {
            self.play()
            AnalyticsManager.shared.logEvent(eventName: AnalyticsKeys.homepageMusicTapped , properties: [AnalyticsAmplitudeEventPropertyKeys.musicPlaying : true])
        }
    }
}
