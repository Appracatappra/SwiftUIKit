//
//  IconButton.swift
//  Hexo
//
//  Created by Kevin Mullins on 9/22/23.
//

import SwiftUI
import SoundManager
import SwiftletUtilities

/// `IconButton` is a `SwiftUI` control that is displayed as a rounded edge Button with a border and icon. `IconButton` will work with both tounch based and focus base UIs.
public struct IconButton: View {
    /// The action that will be taken with the button is clicked.
    public typealias buttonAction = () -> Void
    
    // MARK: - Static Properties
    /// The default background color for the `IconButton`.
    static public var defaultBackgroundColor:Color = .gray
    
    /// The default sound source for the `IconButton`.
    static public var defaultSoundSource:SwiftUIKit.Source = .packageBundle
    
    /// The default button clicked sound `IconButton`.
    static public var defaultButtonSound:String = "mouse-click.mp3"
    
    /// The default focused sound for the `IconButton`.
    static public var defaultButtonFocusSound:String = "diamond-click.mp3"
    
    
    // MARK: - Properties
    /// The isonc to display.
    public var icon:String = "globe"
    
    /// The text to display.
    public var text:String = "Hello World!"
    
    /// The button's background color.
    public var backgroundColor:Color = IconButton.defaultBackgroundColor
    
    /// The button's text color.
    public var textColor:Color = .white
    
    /// The button's border Color.
    public var borderColor:Color = .white
    
    /// The button's border Width.
    public var borderWidth:CGFloat = 5.0
    
    /// The font size for the button.
    public var size:CGFloat = 24
    
    /// The sound source for the button.
    public var soundSource:SwiftUIKit.Source = IconButton.defaultSoundSource
    
    /// The button's clicked sound.
    public var buttonSound:String = IconButton.defaultButtonSound
    
    /// The button's focused sound.
    public var focusSound:String = IconButton.defaultButtonFocusSound
    
    /// The action to take when the button is clicked.
    public var action:buttonAction? = nil
    
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
    
    // MARK: - Control Body
    /// The body of the control.
    public var body: some View {
        #if os(tvOS)
        Contents()
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
            Contents()
        }
        #endif
        
    }
    
    /// Draws the button's main contents.
    /// - Returns: The `View` containing the button's contents.
    @ViewBuilder public func Contents() -> some View {
        HStack(spacing: 10.0) {
            if icon != "" {
                Image(systemName: icon)
                    .font(.system(size: size))
                    .foregroundColor(textColor)
            }
            
            if text != "" {
                Text(text)
                    .font(.system(size: size))
                    .foregroundColor(textColor)
            }
        }
        .padding(.all, 10.0)
        .background(backgroundColor)
        .cornerRadius(size / 2.0)
        .overlay(
            RoundedRectangle(cornerRadius: size / 2.0)
                .stroke(borderColor, lineWidth: borderWidth)
        )
    }
}

#Preview {
    IconButton()
}
