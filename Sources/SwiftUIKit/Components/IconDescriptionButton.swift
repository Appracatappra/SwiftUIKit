//
//  IconDescriptionButton.swift
//  Hexo
//
//  Created by Kevin Mullins on 10/5/23.
//

import SwiftUI
import SwiftletUtilities

public struct IconDescriptionButton: View {
    
    static public var defaultBackgroundColor:Color = .gray
    static public var defaultSoundSource:SwiftUIKit.Source = .packageBundle
    static public var defaultButtonSound:String = "mouse-click.mp3"
    static public var defaultButtonFocusSound:String = "diamond-click.mp3"
    
    public var icon:String = "globe"
    public var description:String = ""
    public var descriptionColor:Color = .white
    public var text:String = "Hello World!"
    public var backgroundColor:Color = IconDescriptionButton.defaultBackgroundColor
    public var textColor:Color = .white
    public var borderColor:Color = .white
    public var borderWidth:CGFloat = 5.0
    public var size:CGFloat = 0
    public var soundSource:SwiftUIKit.Source = IconDescriptionButton.defaultSoundSource
    public var buttonSound:String = IconDescriptionButton.defaultButtonSound
    public var focusSound:String = IconDescriptionButton.defaultButtonFocusSound
    public var action:IconButton.buttonAction? = nil
    
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
    IconDescriptionButton()
}
