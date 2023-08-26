//
//  Speaker.swift
//  ColorSense
//
//  Created by jonata klabunde on 24/08/23.
//

import SwiftUI
import AVFoundation

final class Speaker {
    
    static var shared = Speaker()
    private let synthesizer = AVSpeechSynthesizer()
    
    func say(_ text: String, delay: Double = 0.0) {
        /// Start audio session
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
                try audioSession.setMode(AVAudioSession.Mode.default)
                try audioSession.setActive(true)
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            } catch { return }
            
            /// Speaker
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
            utterance.rate = AVSpeechUtteranceDefaultSpeechRate
            utterance.pitchMultiplier = 1
            utterance.volume = 2
            self.synthesizer.speak(utterance)
        }
    }
    
}


