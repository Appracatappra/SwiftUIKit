//
//  SwiftUITimer.swift
//  Escape from Mystic Manor
//
//  Created by Kevin Mullins on 11/16/21.
//

import Foundation
import SwiftUI
import SwiftletUtilities

/// A swift UI specific timer that can execute a tick method after a given amount of time.
open class SwiftUITimer {
    // MARK: - Events
    /// Handle a give tick expiring.
    public typealias tickHandler = () -> Void
    
    // MARK: - Properties
    /// The time that does the work in the background.
    public var timer:Timer? = nil
    
    /// The inverval between the ticks.
    public var interval:Double = 1.0
    
    /// Handle a give tick expiring.
    public var onTick:tickHandler? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    /// - Parameters:
    ///   - interval: The inverval between the ticks.
    ///   - onTick: Handle a give tick expiring.
    public init(interval:Double = 1.0, onTick:@escaping tickHandler) {
        self.interval = interval
        self.onTick = onTick
    }
    
    // MARK: - Functions
    /// Starts the timer.
    public func start() {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) {timer in
            if let onTick = self.onTick {
                Execute.onMain {
                    onTick()
                }
            }
        }
    }
    
    /// Stops the timer.
    public func stop() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
    }
}
