//
//  ColorRecognizerView.swift
//  ColorSense
//
//  Created by jonata klabunde on 19/08/23.
//

import SwiftUI

struct ColorRecognizerView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = ColorRecognizerViewModel()
    @State private var timer: Timer?
    @State private var longPressEnable = false
    
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
            point()
        }
        .ignoresSafeArea()
        .background(Color.gray)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in
                timer?.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    /// long press
                    if longPressEnable == false {
                        longPressEnable = true
                        viewModel.feedbackImpact(.rigid)
                        Speaker.shared.say("Fechando leitor de cor")
                        dismiss()
                    }
                }
            }
            .onEnded { _ in
                timer?.invalidate()
                if longPressEnable {
                    longPressEnable = false
                    /// long press finish
                    viewModel.feedbackImpact(.rigid)
                } else {
                    /// touch
                    viewModel.sayTheName()
                }
            }
        )
        .onAppear {
            Speaker.shared.say("Leitor de cor aberto")
            Speaker.shared.say("Para fechar toque por três segundos na tela", delay: 1.0)
        }
    }
    
    
    @ViewBuilder
    func point() -> some View {
        ZStack {
            Rectangle()
                .fill(.black)
                .frame(width: 2, height: 40)
            Rectangle()
                .fill(.black)
                .frame(width: 40, height: 2)
            Circle()
                .fill(.white)
                .frame(width: 7, height: 7)
            Circle()
                .fill(.black)
                .frame(width: 5, height: 5)
        }
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
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ColorRecognizerView()
    }
}
