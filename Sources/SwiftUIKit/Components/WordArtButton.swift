//
//  SwiftUIView.swift
//  
//
//  Created by Kevin Mullins on 10/20/23.
//

import SwiftUI
import SoundManager
import SwiftletUtilities

/// `WordArtButton` is a `SwiftUI` control that is displayed as interactable Word Art. `WordArtButton` will work with both touch based and focus base UIs.
public struct WordArtButton: View {
    /// The action that will be taken with the button is clicked.
    public typealias buttonAction = () -> Void
    
    // MARK: - Static Properties
    /// The default sound source for the `IconButton`.
    static public var defaultSoundSource:SwiftUIKit.Source = .packageBundle
    
    /// The default button clicked sound `IconButton`.
    static public var defaultButtonSound:String = "mouse-click.mp3"
    
    /// The default focused sound for the `IconButton`.
    static public var defaultButtonFocusSound:String = "diamond-click.mp3"
    
    // MARK: - Properties
    /// The text for the wor art.
    public var title:String = "Test"
    
    /// The font to display the text in.
    public var fontName:String = "Arial"
    
    /// The size of the text to display.
    public var fontSize:Float = 128
    
    /// The gradient to display the text in.
    public var gradientColors:[Color] = [.purple, .blue, .cyan, .green, .yellow, .orange, .red]
    
    /// The degrees to rotate the text in.
    public var rotationDegrees:Double = 0
    
    /// If `true`, display a shadow behind the text.
    public var shadowed:Bool = true
    
    /// The x offset for the text.
    public var xOffset:Float = 0.0
    
    /// The y offset for the text.
    public var yOffset:Float = 0.0
    
    /// The sound source for the button.
    public var soundSource:SwiftUIKit.Source = IconButton.defaultSoundSource
    
    /// The button's clicked sound.
    public var buttonSound:String = IconButton.defaultButtonSound
    
    /// The button's focused sound.
    public var focusSound:String = IconButton.defaultButtonFocusSound
    
    /// The action to take when the button is clicked.
    public var action:buttonAction? = nil
    
    /// The focused state of the button.
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
    /// Creates a new instance of the button.
    /// - Parameters:
    ///   - title: The text for the wor art.
    ///   - fontName: The font to display the text in.
    ///   - fontSize: The size of the text to display.
    ///   - gradientColors: The gradient to display the text in.
    ///   - rotationDegrees: The degrees to rotate the text in.
    ///   - shadowed: If `true`, display a shadow behind the text.
    ///   - xOffset: The x offset for the text.
    ///   - yOffset: The y offset for the text.
    ///   - soundSource: The sound source for the button.
    ///   - buttonSound: The button's clicked sound.
    ///   - focusSound: The button's focused sound.
    ///   - action: The action to take when the button is clicked.
    public init(title: String, fontName: String = "Arial", fontSize: Float = 128, gradientColors: [Color] = [.purple, .blue, .cyan, .green, .yellow, .orange, .red], rotationDegrees: Double = 0.0, shadowed: Bool = true, xOffset: Float = 0.0, yOffset: Float = 0.0, soundSource: SwiftUIKit.Source = IconButton.defaultSoundSource, buttonSound: String = IconButton.defaultButtonSound, focusSound: String = IconButton.defaultButtonFocusSound, action: buttonAction? = nil) {
        self.title = title
        self.fontName = fontName
        self.fontSize = fontSize
        self.gradientColors = gradientColors
        self.rotationDegrees = rotationDegrees
        self.shadowed = shadowed
        self.xOffset = xOffset
        self.yOffset = yOffset
        self.soundSource = soundSource
        self.buttonSound = buttonSound
        self.focusSound = focusSound
        self.action = action
    }
    
    // MARK: - Main Contents
    /// The contents of the button.
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
        WordArtView(title: title, fontName: fontName, fontSize: fontSize, gradientColors: gradientColors, rotationDegrees: rotationDegrees, shadowed: shadowed)
    }
}

#Preview {
    WordArtButton(title: "Hello World")
}
