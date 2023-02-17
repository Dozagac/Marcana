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

class MusicPlayer: ObservableObject {
    static let shared = MusicPlayer()

    @Published var player: AVAudioPlayer

    private init() {
        
        // read the volume @AppStorage("backgroundMusicVolume") var musicVolume: Double = 0.5 in the initialization
        
        let path = Bundle.main.path(forResource: "MysticMusic.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)

        do {
            player = try! AVAudioPlayer(contentsOf: url)  //  MysticMusic.mp3 has to exist.
            player.numberOfLoops = -1 // infinite loop
//            player.prepareToPlay()
            
            // so it plays in silent mode as well
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print("Could not create AVAudioPlayer:", error)
        }
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }
    
    func restart() {
        player.currentTime = 0
        player.play()
    }

    func togglePlayPause() {
        if player.isPlaying == true {
            player.pause()
        } else {
            player.play()
        }
    }
}
