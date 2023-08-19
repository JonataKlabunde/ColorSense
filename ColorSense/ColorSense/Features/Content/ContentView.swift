//
//  ContentView.swift
//  ColorSense
//
//  Created by jonata klabunde on 19/08/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            
            ViewfinderView(image: $viewModel.viewfinderImage)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)

    
            colorName()
        }
        .task {
            await viewModel.camera.start()
        }
        .ignoresSafeArea()
        .background(Color.gray)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    func colorName() -> some View {
        VStack(spacing: 0) {
            Spacer()
            VStack {
                Text(viewModel.colorName)
                    .foregroundColor(.black)
                    .font(.system(size: 30, weight: .heavy))
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .padding(.horizontal, 20)
            .padding(.bottom, 60)
            .onTapGesture {
                viewModel.sayTheName()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ViewfinderView: View {
    @Binding var image: Image?
    
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

struct ViewfinderView_Previews: PreviewProvider {
    static var previews: some View {
        ViewfinderView(image: .constant(Image(systemName: "pencil")))
    }
}
