//
//  IconDescriptionButton.swift
//  Hexo
//
//  Created by Kevin Mullins on 10/5/23.
//

import SwiftUI
import SwiftletUtilities

/// `IconDescriptionButton` is a `SwiftUI` control that is displayed as a rounded edge Button with a border and icon along with a description block of text. The `IconDescriptionButton` make great user preference controls and will work with both touch based and focus base UIs.
public struct IconDescriptionButton: View {
    
    // MARK: - Static Properties
    /// The default background color for the `IconDescriptionButton`.
    static public var defaultBackgroundColor:Color = .gray
    
    /// The default sound source for the `IconDescriptionButton`.
    static public var defaultSoundSource:SwiftUIKit.Source = .packageBundle
    
    /// The default button clicked sound for the `IconDescriptionButton`.
    static public var defaultButtonSound:String = "mouse-click.mp3"
    
    /// The defaut button focused sound for the `IconDescriptionButton`.
    static public var defaultButtonFocusSound:String = "diamond-click.mp3"
    
    // MARK: - Properties
    /// The icon to display on the button.
    public var icon:String = "globe"
    
    /// The description to display.
    public var description:String = ""
    
    /// The color of the description text.
    public var descriptionColor:Color = .white
    
    /// The text to display on the button.
    public var text:String = "Hello World!"
    
    /// The background color of the button.
    public var backgroundColor:Color = IconDescriptionButton.defaultBackgroundColor
    
    /// The text color for the button.
    public var textColor:Color = .white
    
    /// The border color for the button.
    public var borderColor:Color = .white
    
    /// The border color for the button.
    public var borderWidth:CGFloat = 5.0
    
    /// The size for the button, if you leave it at zero, it will be calculated from the device size.
    public var size:CGFloat = 0
    
    /// The sound source for the button.
    public var soundSource:SwiftUIKit.Source = IconDescriptionButton.defaultSoundSource
    
    /// The button clicked sound.
    public var buttonSound:String = IconDescriptionButton.defaultButtonSound
    
    /// The button focused sound.
    public var focusSound:String = IconDescriptionButton.defaultButtonFocusSound
    
    /// The action to tak when the button is clicked.
    public var action:IconButton.buttonAction? = nil
    
    /// The calculated size for the button.
    public var buttonSize:CGFloat {
        if size > 0 {
            return size
        } else {
            #if os(macOS)
            return 24
            #else
            switch HardwareInformation.screenHeight {
            case 667:
                return 14
            default:
                #if os(tvOS)
                return 32
                #else
                if HardwareInformation.isPad {
                    return 24
                } else {
                    return 16
                }
                #endif
            }
            #endif
        }
    }
    
    // MARK: - Initializers
    /// Creates a new instance of the button.
    /// - Parameters:
    ///   - icon: The icon to display on the button.
    ///   - description: The description to display.
    ///   - descriptionColor: The color of the description text.
    ///   - text: The text to display on the button.
    ///   - backgroundColor: The background color of the button.
    ///   - textColor: The text color for the button.
    ///   - borderColor: The border color for the button.
    ///   - borderWidth: The border color for the button.
    ///   - size: The size for the button, if you leave it at zero, it will be calculated from the device size.
    ///   - soundSource: The sound source for the button.
    ///   - buttonSound: The button clicked sound.
    ///   - focusSound: The button focused sound.
    ///   - action: The action to tak when the button is clicked.
    public init(icon: String, description: String, descriptionColor: Color = .white, text: String, backgroundColor: Color = IconDescriptionButton.defaultBackgroundColor, textColor: Color = .white, borderColor: Color = .white, borderWidth: CGFloat = 5.0, size: CGFloat = 0, soundSource: SwiftUIKit.Source = IconDescriptionButton.defaultSoundSource, buttonSound: String = IconDescriptionButton.defaultButtonSound, focusSound: String = IconDescriptionButton.defaultButtonFocusSound, action: IconButton.buttonAction? = nil) {
        self.icon = icon
        self.description = description
        self.descriptionColor = descriptionColor
        self.text = text
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.size = size
        self.soundSource = soundSource
        self.buttonSound = buttonSound
        self.focusSound = focusSound
        self.action = action
    }
    
    // MARK: - Main Contents
    /// The contents of the button
    public var body: some View {
        HStack(alignment: .top) {
            Text(description)
                .foregroundColor(descriptionColor)
                .font(.system(size: buttonSize))
            
            Spacer()
            
            IconButton(icon: icon, text: text, backgroundColor: backgroundColor, textColor: textColor, borderColor: borderColor, borderWidth: borderWidth, size: buttonSize, soundSource: soundSource, buttonSound: buttonSound, focusSound: focusSound, action: action)
        }
    }
}

#Preview {
    IconDescriptionButton(icon: "globe", description: "This is some sample text", text: "Hello Wordl")
}
