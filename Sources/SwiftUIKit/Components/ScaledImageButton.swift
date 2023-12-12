//
//  ScaledImageButton.swift
//  Escape from Mystic Manor
//
//  Created by Kevin Mullins on 10/27/21.
//

import SwiftUI
import SoundManager
import SwiftletUtilities

/// `ScaledImageButton` is a `SwiftUI` control that displays the given image as a button. `ScaledImageButton` will work with both touch based and focus base UIs.
public struct ScaledImageButton: View {
    public typealias buttonAction = () -> Void
    
    // MARK: - Static Properties
    /// The default sound source for the `ScaledImageButton`.
    static public var defaultSoundSource:SwiftUIKit.Source = .packageBundle
    
    /// The default clicked sound for the `ScaledImageButton`.
    static public var defaultButtonSound:String = "mouse-click.mp3"
    
    /// The default focused sound forr the `ScaledImageButton`.
    static public var defaultButtonFocusSound:String = "diamond-click.mp3"
    
    // MARK: - Properties
    /// The name of the image to display.
    public var imageName = ""
    
    /// The scale for the image button as a percentage.
    public var scale:Float = 1.0
    
    /// If `true`, apply a glow to the button when it is in focus.
    public var glowOnFocus:Bool = true
    
    /// If `true`, the button is enabled.
    public var isEnabled:Bool = true
    
    /// The sound source for the button.
    public var soundSource:SwiftUIKit.Source = ScaledImageButton.defaultSoundSource
    
    /// The clicked sound for the button.
    public var buttonSound:String = ScaledImageButton.defaultButtonSound
    
    /// The focused sound for the button.
    public var focusSound:String = ScaledImageButton.defaultButtonFocusSound
    
    /// The action to take when the button is clicked.
    public var action:buttonAction? = nil
    
    /// The focused state for the button.
    @State private var isFocused = false
    
    // MARK: - Computed Properties
    /// The glow radius for the button.
    public var glowRadius:CGFloat {
        if isFocused {
            if glowOnFocus {
                return CGFloat(10.0)
            } else {
                return CGFloat(0.0)
            }
        } else {
            return CGFloat(0.0)
        }
    }
    
    // MARK: - Initializers
    /// Creates a new insstance of the button.
    /// - Parameters:
    ///   - imageName: The name of the image to display.
    ///   - scale: The scale for the image button as a percentage.
    ///   - glowOnFocus: If `true`, apply a glow to the button when it is in focus.
    ///   - isEnabled: If `true`, the button is enabled.
    ///   - soundSource: The sound source for the button.
    ///   - buttonSound: The clicked sound for the button.
    ///   - focusSound: The focused sound for the button.
    ///   - action: The action to take when the button is clicked.
    public init(imageName: String, scale: Float = 1.0, glowOnFocus: Bool = true, isEnabled: Bool = true, soundSource: SwiftUIKit.Source = ScaledImageButton.defaultSoundSource, buttonSound: String = ScaledImageButton.defaultButtonSound, focusSound: String = ScaledImageButton.defaultButtonFocusSound, action: buttonAction? = nil) {
        self.imageName = imageName
        self.scale = scale
        self.glowOnFocus = glowOnFocus
        self.isEnabled = isEnabled
        self.action = action
        self.soundSource = soundSource
        self.buttonSound = buttonSound
        self.focusSound = focusSound
    }
    
    // MARK: - Main Content
    /// The contents of the button.
    public var body: some View {
        if !isEnabled {
            ScaledImageView(imageName: imageName, scale: scale)
                .opacity(0.50)
        } else {
            #if os(tvOS)
            ScaledImageView(imageName: imageName, scale: scale)
                .scaleEffect(isFocused ? CGFloat(1.2) : CGFloat(1.0))
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
                ScaledImageView(imageName: imageName, scale: scale)
            }
            #endif
        }
    }
}

#Preview {
    ScaledImageButton(imageName: "")
}
