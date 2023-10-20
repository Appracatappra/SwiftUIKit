//
//  SelectIntOptionsButton.swift
//  Hexo
//
//  Created by Kevin Mullins on 10/6/23.
//

import SwiftUI
import SwiftletUtilities

public struct SelectIntOptionsButton: View {
    
    static public var defaultBackgroundColor:Color = .gray
    static public var defaultSoundSource:SwiftUIKit.Source = .packageBundle
    static public var defaultButtonSound:String = "mouse-click.mp3"
    static public var defaultButtonFocusSound:String = "diamond-click.mp3"
    
    public var icon:String = "globe"
    public var description:String = ""
    public var descriptionColor:Color = .white
    public var optionText:[String] = []
    public var optionValue:[Int] = []
    public var backgroundColor:Color = SelectIntOptionsButton.defaultBackgroundColor
    public var textColor:Color = .white
    public var borderColor:Color = .white
    public var borderWidth:CGFloat = 5.0
    public var size:CGFloat = 0
    public var soundSource:SwiftUIKit.Source = SelectIntOptionsButton.defaultSoundSource
    public var buttonSound:String = SelectIntOptionsButton.defaultButtonSound
    public var focusSound:String = SelectIntOptionsButton.defaultButtonFocusSound
    
    @Binding var selectedOption:Int
    
    public var currentIndex:Int {
        var index = -1
        for n in 0..<optionValue.count {
            if optionValue[n] == selectedOption {
                index = n
            }
        }
        return index
    }
    
    public var text:String {
        let n = currentIndex
        if n < 0 || n >= optionValue.count {
            return ""
        } else {
            return optionText[n]
        }
    }
    
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
    SelectIntOptionsButton(selectedOption: Binding.constant(0))
}
