//
//  SelectIntOptionsButton.swift
//  Hexo
//
//  Created by Kevin Mullins on 10/6/23.
//

import SwiftUI
import SwiftletUtilities

/// `SelectIntOptionsButton` is a `SwiftUI` control that is displayed as a rounded edge Button with a border, icon and descriptive text block. When clicked, the `SelectIntOptionsButton` will cycle through the list of options provided. `SelectIntOptionsButton` will work with both touch based and focus base UIs and makes a great user preference control.
public struct SelectIntOptionsButton: View {
    
    // MARK: - Static Properties
    /// The default background color for the `SelectIntOptionsButton`.
    static public nonisolated(unsafe) var defaultBackgroundColor:Color = .gray
    
    /// The default sound source for the `SelectIntOptionsButton`.
    static public nonisolated(unsafe) var defaultSoundSource:SwiftUIKit.Source = .packageBundle
    
    /// The default clicked sound for the`SelectIntOptionsButton`.
    static public nonisolated(unsafe) var defaultButtonSound:String = "mouse-click.mp3"
    
    /// The default focused sound for the `SelectIntOptionsButton`.
    static public nonisolated(unsafe) var defaultButtonFocusSound:String = "diamond-click.mp3"
    
    // MARK: - Properties
    /// The icon for the button.
    public var icon:String = "globe"
    
    /// The descriptive text.
    public var description:String = ""
    
    /// The descriptive text color.
    public var descriptionColor:Color = .white
    
    /// The text to show for the different options.
    public var optionText:[String] = []
    
    /// The values for the different options.
    public var optionValue:[Int] = []
    
    /// The background color for the button.
    public var backgroundColor:Color = SelectIntOptionsButton.defaultBackgroundColor
    
    /// The text color for the button.
    public var textColor:Color = .white
    
    /// The border color for the button.
    public var borderColor:Color = .white
    
    /// The border width for the button.
    public var borderWidth:CGFloat = 5.0
    
    /// The size of the button. If zero, it will be calculated  for the device.
    public var size:CGFloat = 0
    
    /// The sound source for the button.
    public var soundSource:SwiftUIKit.Source = SelectIntOptionsButton.defaultSoundSource
    
    /// The clicked sound for the button.
    public var buttonSound:String = SelectIntOptionsButton.defaultButtonSound
    
    /// The focused sound for the button.
    public var focusSound:String = SelectIntOptionsButton.defaultButtonFocusSound
    
    /// The index of the currently selected option.
    @Binding var selectedOption:Int
    
    // MARK: - Computed Properties
    /// The currently selected Index based on the passed in value.
    public var currentIndex:Int {
        var index = -1
        for n in 0..<optionValue.count {
            if optionValue[n] == selectedOption {
                index = n
            }
        }
        return index
    }
    
    /// The text to display for the currently selected option.
    public var text:String {
        let n = currentIndex
        if n < 0 || n >= optionValue.count {
            return ""
        } else {
            return optionText[n]
        }
    }
    
    // MARK: - Initializers
    /// Creates a new instance of the button.
    /// - Parameters:
    ///   - icon: The icon for the button.
    ///   - description: The descriptive text.
    ///   - descriptionColor: The descriptive text color.
    ///   - optionText: The text to show for the different options.
    ///   - optionValue: The values for the different options.
    ///   - backgroundColor: The background color for the button.
    ///   - textColor: The text color for the button.
    ///   - borderColor: The border color for the button.
    ///   - borderWidth: The border width for the button.
    ///   - size: The size of the button. If zero, it will be calculated  for the device.
    ///   - soundSource: The sound source for the button.
    ///   - buttonSound: The clicked sound for the button.
    ///   - focusSound: The focused sound for the button.
    ///   - selectedOption: The index of the currently selected option.
    public init(icon: String, description: String, descriptionColor: Color = .white, optionText: [String], optionValue: [Int], backgroundColor: Color = SelectIntOptionsButton.defaultBackgroundColor, textColor: Color = .white, borderColor: Color = .white, borderWidth: CGFloat = 5.0, size: CGFloat = 0, soundSource: SwiftUIKit.Source = SelectIntOptionsButton.defaultSoundSource, buttonSound: String = SelectIntOptionsButton.defaultButtonSound, focusSound: String = SelectIntOptionsButton.defaultButtonFocusSound, selectedOption: Binding<Int>) {
        self.icon = icon
        self.description = description
        self.descriptionColor = descriptionColor
        self.optionText = optionText
        self.optionValue = optionValue
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.size = size
        self.soundSource = soundSource
        self.buttonSound = buttonSound
        self.focusSound = focusSound
        self._selectedOption = selectedOption
    }
    
    // MARK: - Main Contents
    /// The main contents of the control.
    public var body: some View {
        IconDescriptionButton(icon: icon, description: description, descriptionColor: descriptionColor, text: text, backgroundColor: backgroundColor, textColor: textColor, borderColor: borderColor, borderWidth:borderWidth, size: size, soundSource: soundSource, buttonSound: buttonSound, focusSound: focusSound) {
            var n = currentIndex + 1
            if n >= optionValue.count {
                n = 0
            }
            selectedOption = optionValue[n]
        }
    }
}

#Preview {
    SelectIntOptionsButton(icon: "globe", description: "This is a test", optionText: ["Option 1", "Option 2"], optionValue: [0, 1], selectedOption: Binding.constant(0))
}
