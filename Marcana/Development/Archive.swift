//
//  Archive.swift
//  Marcana
//
//  Created by Deniz Ozagac on 17/02/2023.
//

import Foundation
import SwiftUI

//struct MusicVolumeControlView: View {
//    // https://www.donnywals.com/presenting-a-partially-visible-bottom-sheet-in-swiftui-on-ios-16/
//    @AppStorage("backgroundMusicVolume") var musicVolume: Double = 0.5
//    let geoProxy: GeometryProxy
//    var body: some View {
//        ZStack {
//            HStack {
//                Image(systemName: "speaker.wave.1")
//                Slider(value: $musicVolume, in: 0...1)
//                    .onReceive([self.musicVolume].publisher.first()) { value in
//                    MusicPlayer.shared.player.volume = Float(value)
//                }
//                    .frame(width: geoProxy.size.width * 0.6)
//                    .accentColor(.marcanaBlue)
//                Image(systemName: "speaker.wave.3")
//            }
//                .frame(maxWidth: .infinity, maxHeight: .infinity) // needs this volume for backgroun blur effect
//
//                .background(BackgroundBlurView())
//        }
//    }
//}
