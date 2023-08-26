//
//  VoiceCommand.swift
//  ColorSense
//
//  Created by jonata klabunde on 23/08/23.
//

import SwiftUI
import Speech
import AVFoundation

class VoiceCommand: ObservableObject {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "pt-BR"))
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    @Published var isRecording = false
    @Published var commandText: String = "Pronunciar um comando!" {
        didSet {
            Debouncer.shared.runOneTimeAfter(interval: 1.0) {
                self.stop()
                self.commandFinished(self.commandText)
            }
        }
    }
    var commandFinished: (_ command: String)->Void
    
    init(commandFinished: @escaping (_ command: String)->Void) {
        self.commandFinished = commandFinished
        requestAuthorization()
    }
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .authorized:
                print("Autorizado")
            default:
                print("Não autorizado")
            }
        }
    }
    
    func start() throws {
        isRecording = true
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Não foi possível criar o objeto SFSpeechAudioBufferRecognitionRequest.") }

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                self.commandText = result.bestTranscription.formattedString
            } else if let error = error {
                print("Houve um erro: \(error.localizedDescription)")
            }
        }
        
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: audioEngine.inputNode.outputFormat(forBus: 0)) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func stop() {
        isRecording = false
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
    }
}
