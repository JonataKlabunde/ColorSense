//
//  SpeechViewModel.swift
//  ColorSense
//
//  Created by jonata klabunde on 24/08/23.
//

import SwiftUI

final class SpeechViewModel: ObservableObject {
    
    @Published var commandText: String = "Pronuncie um comando!"    
}
