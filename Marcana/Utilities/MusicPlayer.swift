//
//  MusicPlayer.swift
//  Marcana
//
//  Created by Deniz Ozagac on 09/02/2023.
//

import AVFoundation


//@AppStorage(wrappedValue: true, "playBackgroundMusic") var playBackgroundMusic
//if playBackgroundMusic {
//    // Start the music
//    MusicPlayer.shared.restart()
//}

class MusicPlayer {
    static let shared = MusicPlayer()

    var player: AVAudioPlayer?

    private init() {
        let path = Bundle.main.path(forResource: "MysticMusic.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.prepareToPlay()
        } catch {
            print("Could not create AVAudioPlayer:", error)
        }
    }

    func play() {
        player?.play()
    }

    func pause() {
        player?.pause()
    }
    
    func restart() {
        player?.currentTime = 0
        player?.play()
    }

    func togglePlayPause() {
        if player?.isPlaying == true {
            player?.pause()
        } else {
            player?.play()
        }
    }
}
