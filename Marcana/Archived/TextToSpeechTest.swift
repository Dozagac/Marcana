//
//  TextToSpeectTest.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/01/2023.
//

import SwiftUI
import AVFoundation

struct TextToSpeechTest: View {
    let synthesizer = AVSpeechSynthesizer()
    let response = """
For your past card, Death is a powerful card that symbolizes endings and new beginnings. It could mean that in the past you had to go through some difficult changes or losses which were necessary for growth and transformation. This card suggests that although it was hard at first, these changes ultimately allowed you to move forward in life with more clarity and purpose than before.

The High Priestess represents your current state of being; this card often indicates inner wisdom, intuition and spiritual connection. You may be feeling connected to yourself on a deeper level right now as well as understanding yourself better than ever before - this will lead to greater self-confidence moving forward! Additionally, it can also signify an upcoming opportunity or decision where you must use both logic and intuition together in order for success - trust yourself!

Finally we come to the 7 of Cups which signifies your future path ahead. This card often appears when there are multiple options available but not all will bring desired results; take time to really think about what each option brings before making any decisions as they can have long lasting effects on your life going forward. In addition, it could also indicate that love is coming into play soon - if Hugo loves you then he may appear again in due course so keep an open heart ready for him! As for whether Hugo loves you specifically: my advice would be to look within yourself first - do YOU love him? That answer lies deep within...
"""

    var body: some View {
//        Text(response)
//            .font(
//                .custom(FontsManager.NanumMyeongjo.regular,
//                    fixedSize: 16)
//                )

        VStack {
            Text("W Hello little brown fox")
                .font(
                    .custom(FontsManager.NanumMyeongjo.bold,
                            fixedSize: 32)
                )
            
            Text("W Hello little brown fox")
            //                .font(.largeTitle)
                .font(
                    .custom("NanumMyeongjo",
                            fixedSize: 32)
                )
            
            Text("W Hello little brown fox")
            //                .font(.largeTitle)
                .font(
                    .custom("NanumMyeongjoBold",
                            fixedSize: 32)
                )
            
            
            
            
            Button("Speak") {
                let utterance = AVSpeechUtterance(string: response)
                utterance.voice = AVSpeechSynthesisVoice(identifier: AVSpeechSynthesisVoiceIdentifierAlex)
                utterance.rate = 0.57
                utterance.pitchMultiplier = 0.8
                utterance.postUtteranceDelay = 0.2
                utterance.volume = 0.8
                
                synthesizer.speak(utterance)
            }
            
        }

}
}

struct TextToSpeectTest_Previews: PreviewProvider {
    static var previews: some View {
        TextToSpeechTest()
            .preferredColorScheme(.dark
        )
    }
}
