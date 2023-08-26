//
//  HomeView.swift
//  ColorSense
//
//  Created by jonata klabunde on 24/08/23.
//

import SwiftUI
import AVFoundation

struct HomeView: View {
    
    @ObservedObject var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .cornerRadius(30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .sheet(isPresented: $viewModel.voicerIsVisible) {
            SpeechView(onComplete: { command in
                viewModel.runCommand(command)
            })
            .presentationDetents([.height(200)])
        }
        .onTapGesture {
            viewModel.voicerIsVisible = true
        }
        .onAppear {
            viewModel.voicerIsVisible = true
        }
    }
    
}
