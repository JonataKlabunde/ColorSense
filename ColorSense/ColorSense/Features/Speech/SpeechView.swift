//
//  SpeechView.swift
//  ColorSense
//
//  Created by jonata klabunde on 24/08/23.
//

import SwiftUI

struct SpeechView: View {
    
    @ObservedObject var viewModel = SpeechViewModel()
    @ObservedObject var voice: VoiceCommand
    @State private var timer: Timer?
    @State private var microphoneEnable = false
    @State private var scale: CGFloat = 1
    private let animationTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()    
    
    init(onComplete: @escaping (_ command: String)->Void) {
        self.voice = VoiceCommand(commandFinished: onComplete)
    }
    
    var body: some View {
        ZStack {
            
            /// microphone
            VStack {
                Spacer()
                LinearGradient(gradient: Gradient(colors: [Color("Green"), Color("Green"), Color("Blue"), Color("Blue")]), startPoint: .leading, endPoint: .trailing)
                  .mask(
                    Image(systemName: "mic.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color("Green"))
                        .overlay {
                            Circle()
                                .stroke(Color("Blue"), lineWidth: 2)
                                .scaleEffect(scale)
                                .onReceive(animationTimer) { _ in
                                    withAnimation(Animation.linear(duration: 0.5).repeatForever(autoreverses: true)) {
                                        scale = scale == 1 ? 1.3 : 1
                                    }
                                }
                        }
                  )
                  .padding(.top, 30)
            }
            
            /// text
            VStack {
                Text(voice.commandText)
                    .foregroundColor(Color.black)
                    .font(.system(size: 18, weight: .medium))
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear {
            Speaker.shared.say("Pronunciar um comando!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                try? voice.start()
            }
        }
        .onDisappear {
            voice.stop()
        }
    }
}
