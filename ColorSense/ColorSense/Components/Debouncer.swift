//
//  Debouncer.swift
//  ColorSense
//
//  Created by jonata klabunde on 25/08/23.
//

import Combine
import Foundation

/**
 This function will be executed after an interval is reached, executing only once, avoiding multiple calls
 
 EXAMPLE OFF CALL:
 Debouncer.shared.runOneTimeAfter(interval: 0.3) {
     print("Executing the debounced function.")
 }
 */
final class Debouncer {
    
    static let shared = Debouncer()
    private init() {}
    private var subject = PassthroughSubject<Void, Never>()
    private var cancellable: AnyCancellable?

    func runOneTimeAfter(interval: TimeInterval, action: @escaping () -> Void) {
        cancellable?.cancel()
        cancellable = subject
            .debounce(for: .milliseconds(Int(interval * 1000)), scheduler: RunLoop.main)
            .sink { _ in
                action()
            }
        subject.send()
    }
}
