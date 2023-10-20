//
//  OnOffToggleButton.swift
//  Hexo
//
//  Created by Kevin Mullins on 10/2/23.
//

import SwiftUI
import SoundManager
import SwiftletUtilities

public struct OnOffToggleButton: View {
    public typealias buttonAction = (Bool) -> Void
    
    static public var defaultOnBackgroundColor:Color = .green
    static public var defaultOffBackgroundColor:Color = .red
    static public var defaultSoundSource:SwiftUIKit.Source = .packageBundle
    static public var defaultButtonSound:String = "mouse-click.mp3"
    static public var defaultButtonFocusSound:String = "diamond-click.mp3"
    
    public var description:String = "This is a sample setting"
    public var textColor:Color = .white
    public var size:CGFloat = 0
    public var soundSource:SwiftUIKit.Source = OnOffToggleButton.defaultSoundSource
    public var buttonSound:String = OnOffToggleButton.defaultButtonSound
    public var focusSound:String = OnOffToggleButton.defaultButtonFocusSound
    @Binding public var isOn:Bool
    public var action:buttonAction? = nil
    
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
    
    public var title:String {
        if isOn {
            return "On"
        } else {
            return "Off"
        }
    }
    
    public var icon:String {
        if isOn {
            return "checkmark.circle.fill"
        } else {
            return "x.circle.fill"
        }
    }
    
    public var color:Color {
        if isOn {
            return OnOffToggleButton.defaultOnBackgroundColor
        } else {
            return OnOffToggleButton.defaultOffBackgroundColor
        }
    }
    
    public var body: some View {
        HStack(alignment: .top) {
            Text(description)
                .foregroundColor(textColor)
                .font(.system(size: buttonSize))
            
            Spacer()
            
            IconButton(icon: icon, text: title, backgroundColor: color, size: buttonSize, soundSource: soundSource, buttonSound: buttonSound, focusSound: focusSound) {
                isOn = !isOn
                if let action {
                    Execute.onMain {
                        action(isOn)
                    }
                }
            }
        }
    }
}

#Preview {
    
    OnOffToggleButton(isOn: Binding.constant(true))
}
