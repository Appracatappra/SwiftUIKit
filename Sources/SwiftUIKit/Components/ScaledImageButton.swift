//
//  ScaledImageButton.swift
//  Escape from Mystic Manor
//
//  Created by Kevin Mullins on 10/27/21.
//

import SwiftUI
import SoundManager
import SwiftletUtilities

public struct ScaledImageButton: View {
    public typealias buttonAction = () -> Void
    
    static public var defaultSoundSource:SwiftUIKit.Source = .packageBundle
    static public var defaultButtonSound:String = "mouse-click.mp3"
    static public var defaultButtonFocusSound:String = "diamond-click.mp3"
    
    public var imageName = ""
    public var scale:Float = 1.0
    public var glowOnFocus:Bool = true
    public var isEnabled:Bool = true
    public var action:buttonAction? = nil
    public var soundSource:SwiftUIKit.Source = ScaledImageButton.defaultSoundSource
    public var buttonSound:String = ScaledImageButton.defaultButtonSound
    public var focusSound:String = ScaledImageButton.defaultButtonFocusSound
    
    @State private var isFocused = false
    
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
    ScaledImageButton()
}
