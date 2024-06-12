//
//  TouchLocatingView.swift
//  Escape from Mystic Manor
//
//  Created by Kevin Mullins on 10/27/21.
//  Based on: https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-the-location-of-a-tap-inside-a-view
//

#if canImport(UIKit)
import Foundation
import UIKit
import SwiftUI

// Our UIKit to SwiftUI wrapper view
public struct TouchLocatingView: UIViewRepresentable {
    
    // MARK: - Subclases
    // The types of touches users want to be notified about.
    public struct TouchType: OptionSet {
        
        // MARK: - Static Properties
        /// Has the touch started?
        public nonisolated(unsafe) static let started = TouchType(rawValue: 1 << 0)
        
        /// Has the touch moved?
        public nonisolated(unsafe) static let moved = TouchType(rawValue: 1 << 1)
        
        /// Has the Touch Ended?
        public nonisolated(unsafe) static let ended = TouchType(rawValue: 1 << 2)
        
        /// Holds all of the different touch types.
        public nonisolated(unsafe) static let all: TouchType = [.started, .moved, .ended]
        
        // MARK: - Properties
        /// The raw `Int` value.
        public let rawValue: Int
        
        // MARK: - Initializers
        /// Creates a new instance.
        /// - Parameter rawValue: The initial raw value.
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
    
    // The internal UIView responsible for catching taps
    public class TouchLocatingUIView: UIView {
        
        // MARK: - Properties
        /// Handles the touch being updated.
        public var onUpdate: ((CGPoint) -> Void)?
        
        /// The types of touches to respond to.
        public var touchTypes: TouchLocatingView.TouchType = .all
        
        /// If `true`, the touches are limited to the bounds of the `View`.
        public var limitToBounds = true

        // MARK: - Initializers
        // Our main initializer, making sure interaction is enabled.
        public override init(frame: CGRect) {
            super.init(frame: frame)
            isUserInteractionEnabled = true
        }

        // Just in case you're using storyboards!
        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            isUserInteractionEnabled = true
        }

        // MARK: - Functions
        // Triggered when a touch starts.
        public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            send(location, forEvent: .started)
        }

        // Triggered when an existing touch moves.
        public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            send(location, forEvent: .moved)
        }

        // Triggered when the user lifts a finger.
        public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            send(location, forEvent: .ended)
        }

        // Triggered when the user's touch is interrupted, e.g. by a low battery alert.
        public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            send(location, forEvent: .ended)
        }

        // Send a touch location only if the user asked for it
        public func send(_ location: CGPoint, forEvent event: TouchLocatingView.TouchType) {
            guard touchTypes.contains(event) else {
                return
            }

            if limitToBounds == false || bounds.contains(location) {
                onUpdate?(CGPoint(x: round(location.x), y: round(location.y)))
            }
        }
    }

    // MARK: - Properties
    // A closer to call when touch data has arrived
    public var onUpdate: (CGPoint) -> Void

    // The list of touch types to be notified of
    public var types = TouchType.all

    // Whether touch information should continue after the user's finger has left the view
    public var limitToBounds = true
    
    // MARK: - Initializers
    /// Creates a new instance of the `View`.
    /// - Parameters:
    ///   - types: The types of touches to respond to.
    ///   - limitToBounds: if `true`, limit to the bounds of the view.
    ///   - onUpdate: The action to take when a touch is updated.
    public init(types: TouchType = TouchType.all, limitToBounds: Bool = true, onUpdate: @escaping (CGPoint) -> Void) {
        self.onUpdate = onUpdate
        self.types = types
        self.limitToBounds = limitToBounds
    }

    // MARK: - Functions
    /// Constructs the new `View`.
    /// - Parameter context: The context to build the view for.
    /// - Returns: A new `TouchLocatingUIView`.
    public func makeUIView(context: Context) -> TouchLocatingUIView {
        // Create the underlying UIView, passing in our configuration
        let view = TouchLocatingUIView()
        view.onUpdate = onUpdate
        view.touchTypes = types
        view.limitToBounds = limitToBounds
        return view
    }
    
    /// Handle the view being updated.
    /// - Parameters:
    ///   - uiView: The view being updated.
    ///   - context: The context of the update.
    public func updateUIView(_ uiView: TouchLocatingUIView, context: Context) {
    }
}

// A custom SwiftUI view modifier that overlays a view with our UIView subclass.
public struct TouchLocater: ViewModifier {
    // MARK: - Properties
    /// The type of touch to respond to.
    public var type: TouchLocatingView.TouchType = .all
    
    /// If `true`, limit touch to inside the bounds of the view.
    public var limitToBounds = true
    
    /// The action to take when touched.
    public let perform: (CGPoint) -> Void
    
    // MARK: - Initializers
    /// Creates a new instance.
    /// - Parameters:
    ///   - type: The type of touch to respond to.
    ///   - limitToBounds: If `true`, limit touch to inside the bounds of the view.
    ///   - perform: The action to take when touched.
    public init(type: TouchLocatingView.TouchType = .all, limitToBounds: Bool = true, perform: @escaping (CGPoint) -> Void) {
        self.type = type
        self.limitToBounds = limitToBounds
        self.perform = perform
    }

    // MARK: - Main Contents
    /// The main contents of the view.
    public func body(content: Content) -> some View {
        content
            .overlay(
                TouchLocatingView( types: type, limitToBounds: limitToBounds, onUpdate: perform)
            )
    }
}

// A new method on View that makes it easier to apply our touch locater view.
public extension View {
    /// Handles the user touching the view.
    /// - Parameters:
    ///   - type: The type of touch to respond to.
    ///   - limitToBounds: If `true`, limit to the bounds of the view.
    ///   - perform: The action to preform when touched.
    /// - Returns: The contents of the `View`.
    func onTouch(type: TouchLocatingView.TouchType = .all, limitToBounds: Bool = true, perform: @escaping (CGPoint) -> Void) -> some View {
        self.modifier(TouchLocater(type: type, limitToBounds: limitToBounds, perform: perform))
    }
}
#endif
