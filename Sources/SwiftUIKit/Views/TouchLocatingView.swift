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
    // The types of touches users want to be notified about
    public struct TouchType: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let started = TouchType(rawValue: 1 << 0)
        public static let moved = TouchType(rawValue: 1 << 1)
        public static let ended = TouchType(rawValue: 1 << 2)
        public static let all: TouchType = [.started, .moved, .ended]
    }

    // A closer to call when touch data has arrived
    public var onUpdate: (CGPoint) -> Void

    // The list of touch types to be notified of
    public var types = TouchType.all

    // Whether touch information should continue after the user's finger has left the view
    public var limitToBounds = true

    public func makeUIView(context: Context) -> TouchLocatingUIView {
        // Create the underlying UIView, passing in our configuration
        let view = TouchLocatingUIView()
        view.onUpdate = onUpdate
        view.touchTypes = types
        view.limitToBounds = limitToBounds
        return view
    }

    public func updateUIView(_ uiView: TouchLocatingUIView, context: Context) {
    }

    // The internal UIView responsible for catching taps
    public class TouchLocatingUIView: UIView {
        // Internal copies of our settings
        public var onUpdate: ((CGPoint) -> Void)?
        public var touchTypes: TouchLocatingView.TouchType = .all
        public var limitToBounds = true

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

    // MARK: - Main Contents
    /// The main contents of the view.
    public func body(content: Content) -> some View {
        content
            .overlay(
                TouchLocatingView(onUpdate: perform, types: type, limitToBounds: limitToBounds)
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
