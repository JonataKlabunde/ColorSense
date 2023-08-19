//
//  ContentViewModel.swift
//  ColorSense
//
//  Created by jonata klabunde on 19/08/23.
//

import SwiftUI

final class ContentViewModel: ObservableObject {
    
    @Published var colorName: String = "Preto"
    
    func sayTheName() {
        feedbackImpact(.heavy)
    }
}
