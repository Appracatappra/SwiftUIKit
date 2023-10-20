//
//  OnOffToggleButton.swift
//  Hexo
//
//  Created by Kevin Mullins on 10/2/23.
//

import SwiftUI
import SoundManager
import SwiftletUtilities

/// `OnOffToggleButton` is a `SwiftUI` control that is displayed as a rounded edge Button with a border and icon. `OnOffToggleButton` will flip between the on and off states when clicked and works with both tounch based and focus base UIs.
public struct OnOffToggleButton: View {
    public typealias buttonAction = (Bool) -> Void
    
    // MARK: - Static Properties
    /// The default on background color for the `OnOffToggleButton`.
    static public var defaultOnBackgroundColor:Color = .green
    
    /// The default off background color for the `OnOffToggleButton`.
    static public var defaultOffBackgroundColor:Color = .red
    
    /// The default sound source for the `OnOffToggleButton`.
    static public var defaultSoundSource:SwiftUIKit.Source = .packageBundle
    
    /// The default clicked sound for the `OnOffToggleButton`.
    static public var defaultButtonSound:String = "mouse-click.mp3"
    
    /// The default focused sound for the `OnOffToggleButton`.
    static public var defaultButtonFocusSound:String = "diamond-click.mp3"
    
    // MARK: - Properties
    /// The description for  the toggle.
    public var description:String = "This is a sample setting"
    
    /// The text color.
    public var textColor:Color = .white
    
    /// The size for the button. If zero, it will be claculated for the device size.
    public var size:CGFloat = 0
    
    /// The sound source for the button.
    public var soundSource:SwiftUIKit.Source = OnOffToggleButton.defaultSoundSource
    
    /// The clicked sound for the button.
    public var buttonSound:String = OnOffToggleButton.defaultButtonSound
    
    /// The focused sound for the button.
    public var focusSound:String = OnOffToggleButton.defaultButtonFocusSound
    
    /// The on/off state of the button.
    @Binding public var isOn:Bool
    
    /// The action to take when the button is clicked.
    public var action:buttonAction? = nil
    
    // MARK: - Computed Properties
    /// The calculated button size.
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
    
    /// The on/off title for the button.
    public var title:String {
        if isOn {
            return "On"
        } else {
            return "Off"
        }
    }
    
    // The on/off icon for the button.
    public var icon:String {
        if isOn {
            return "checkmark.circle.fill"
        } else {
            return "x.circle.fill"
        }
    }
    
    /// The on/off background color for the button.
    public var color:Color {
        if isOn {
            return OnOffToggleButton.defaultOnBackgroundColor
        } else {
            return OnOffToggleButton.defaultOffBackgroundColor
        }
    }
    
    // MARK: - Main Contents
    /// The contents odf the button.
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
