//
//  SwiftUIView.swift
//  
//
//  Created by Kevin Mullins on 11/8/23.
//

import SwiftUI
import SoundManager
import SwiftletUtilities

public struct ContentButton<Content: View>: View {
    /// The action that will be taken with the button is clicked.
    public typealias buttonAction = () -> Void
    
    // MARK: - Properties
    /// The sound source for the button.
    public var soundSource:SwiftUIKit.Source = IconButton.defaultSoundSource
    
    /// The button's clicked sound.
    public var buttonSound:String = IconButton.defaultButtonSound
    
    /// The button's focused sound.
    public var focusSound:String = IconButton.defaultButtonFocusSound
    
    /// The button's content.
    @ViewBuilder public var content: Content
    
    /// The action to take when the button is clicked.
    public var action:buttonAction? = nil
    
    /// If `true`, the button is in focus.
    @State private var isFocused = false
    
    // MARK: - Computed Properties
    /// The glowRadius when the button is in focus.
    public var glowRadius:CGFloat {
        if isFocused {
            return CGFloat(10.0)
        } else {
            return CGFloat(0.0)
        }
    }
    
    // MARK: - Initializers
    /// Creates a new instance
    /// - Parameters:
    ///   - soundSource: The sound source for the button.
    ///   - buttonSound: The button's clicked sound.
    ///   - focusSound: The button's focused sound.
    ///   - content: The button's content.
    ///   - action: The action to take when the button is clicked.
    public init(soundSource: SwiftUIKit.Source = .packageBundle, buttonSound: String = IconButton.defaultButtonSound, focusSound: String = IconButton.defaultButtonFocusSound, @ViewBuilder content: @escaping () -> Content, action: buttonAction? = nil) {
        self.soundSource = soundSource
        self.buttonSound = buttonSound
        self.focusSound = focusSound
        self.content = content()
        self.action = action
    }
    
    public var body: some View {
        #if os(tvOS)
        content
            .focusable(true) { newState in
                isFocused = newState
                if isFocused {
                    if focusSound != "" {
                        switch soundSource {
                        case .appBundle:
                            SoundManager.shared.playSoundEffect(sound: focusSound, channel: .channel02)
                        case .packageBundle:
                            SoundManager.shared.playSoundEffect(path: SwiftUIKit.pathTo(resource: focusSound), channel: .channel02)
                        }
                    }
                }
            }
            .animation(.easeInOut, value: isFocused)
            .shadow(color: (isFocused) ? .accentColor : .clear, radius: glowRadius)
            .onLongPressGesture(minimumDuration: 0.01, pressing: { _ in }) {
                Execute.onMain {
                    if buttonSound != "" {
                        switch soundSource {
                        case .appBundle:
                            SoundManager.shared.playSoundEffect(sound: buttonSound)
                        case .packageBundle:
                            SoundManager.shared.playSoundEffect(path: SwiftUIKit.pathTo(resource: buttonSound))
                        }
                    }
                    if let action = action {
                        action()
                    }
                }
            }
        #else
        Button(action: {
            Execute.onMain {
                if buttonSound != "" {
                    switch soundSource {
                    case .appBundle:
                        SoundManager.shared.playSoundEffect(sound: buttonSound)
                    case .packageBundle:
                        SoundManager.shared.playSoundEffect(path: SwiftUIKit.pathTo(resource: buttonSound))
                    }
                }
                if let action = action {
                    action()
                }
            }
        }) {
            content
        }
        #endif
    }
}

#Preview {
    ContentButton() {
        Text("Hello World!")
       .font(.largeTitle)
    }
}
