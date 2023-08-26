//
//  ContentView.swift
//  ColorSense
//
//  Created by jonata klabunde on 19/08/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ContentViewModel()
    @ObservedObject var voice = VoiceCommand()
    @State private var timer: Timer?
    @State private var microphoneEnable = false
    @State private var scale: CGFloat = 1
    private let animationTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {            
            /// camera view
            CameraView(image: $viewModel.image)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .task {
                    await viewModel.camera.start()
                }
            
            textBox()
        }
        .ignoresSafeArea()
        .background(Color.gray)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in
                timer?.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    if microphoneEnable == false {
                        microphoneEnable = true
                        viewModel.feedbackImpact(.rigid)
                        /// long press                        
                    }
                }
            }
            .onEnded { _ in
                timer?.invalidate()
                if microphoneEnable {
                    microphoneEnable = false
                    /// long press finish
                    viewModel.feedbackImpact(.rigid)
                } else {
                    /// touch
                    viewModel.sayTheName()
                }
            }
        )
    }
    
    @ViewBuilder
    func textBox() -> some View {
        VStack(spacing: 0) {
            VStack {
                Text(viewModel.colorName)
                    .foregroundColor(.black)
                    .font(.system(size: 30, weight: .heavy))
                    .padding(.vertical, 10)
            }
            .frame(minHeight: 100)
            .frame(maxWidth: .infinity)
            .background(viewModel.color)
            .cornerRadius(20)
            .padding(.horizontal, 20)
            .padding(.top, 60)
            Spacer()
        }
    }
    
//    @ViewBuilder
//    func microfoneIcon() -> some View {
//        VStack {
//            Spacer()
//            Image(systemName: "mic.circle.fill")
//                .resizable()
//                .scaledToFill()
//                .frame(width: 100, height: 100)
//                .foregroundColor(.white.opacity(microphoneEnable ? 1.0 : 0.4))
//                .animation(.easeInOut(duration: 0.3), value: microphoneEnable)
////                .overlay {
////                    if microphoneEnable {
////                        Circle()
////                            .stroke(.white.opacity(0.2), lineWidth: 2)
////                            .scaleEffect(scale)
////                            .onReceive(animationTimer) { _ in
////                                withAnimation(Animation.linear(duration: 0.5).repeatForever(autoreverses: true)) {
////                                    scale = scale == 1 ? 1.3 : 1
////                                }
////                            }
////                    }
////                }
//                .padding(.bottom, 80)
//        }
//    }

    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
