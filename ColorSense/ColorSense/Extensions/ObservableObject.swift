//
//  ObservableObject.swift
//  ColorSense
//
//  Created by jonata klabunde on 19/08/23.
//

import SwiftUI

extension ObservableObject {
    
    func feedbackNotification(_ type: UINotificationFeedbackGenerator.FeedbackType = .success) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
    
    func feedbackSelect() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    func feedbackImpact(_ type: UIImpactFeedbackGenerator.FeedbackStyle = .soft) {
        UIImpactFeedbackGenerator(style: type).impactOccurred()
    }
}
