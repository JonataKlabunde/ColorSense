//
//  HomeViewModel.swift
//  ColorSense
//
//  Created by jonata klabunde on 24/08/23.
//

import SwiftUI
import Speech

final class HomeViewModel: ObservableObject {
    
    @Published var voicerIsVisible: Bool = false
    @Published var colorRecognizerIsVisible: Bool = false
    var errorCount: Int = 0
    
    func runCommand(_ command: String) {
        let command = command.lowercased()
        voicerIsVisible = false
        
        /// comandos
        if command.contains("comando") || command.contains("comandos") {
            commandInstructions()
            return
        }
        
        /// cor
        if command.contains("cor") {
            Speaker.shared.say("Abrindo leitor de cor")
            colorRecognizerIsVisible = true
            return
        }
        
        /// not found
        Speaker.shared.say("\(command) não reconhecido")
        errorCount > 1
            ? commandInstructions()
            : tryCommandAgain()
    }
    
    func tryCommandAgain() {
        errorCount += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.voicerIsVisible = true
        }
    }
    
    private func commandInstructions() {
        errorCount = 0
        Speaker.shared.say("Você pode usar os seguintes comandos!")
        Speaker.shared.say("Abrindo leitor de cor", delay: 2.0)
        Speaker.shared.say("Leitor de documentos", delay: 2.0)
        Speaker.shared.say("Medidor de distância", delay: 2.0)
    }

}
