//
//  WordArtView.swift
//  Escape from Mystic Manor (iOS)
//
//  Created by Kevin Mullins on 2/9/22.
//

import SwiftUI
import UIKit

/// `WordArtView` displays text in the given font at the given size and rotation with the defined gradient.
public struct WordArtView: View {
    
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
    
    // MARK: - Computed Properties
    /// The font selected for the text.
    public var font:Font {
        return Font.custom(fontName, size: CGFloat(fontSize))
    }
    
    // MARK: - Main Contents
    /// The contents of the control.
    public var body: some View {
        ZStack {
            if shadowed {
                Text(markdown: title)
                    .font(font)
                    .foregroundStyle(.linearGradient(colors: gradientColors, startPoint: .top, endPoint: .bottom))
                    .rotationEffect(Angle(degrees: rotationDegrees))
                    .shadow(color: .black, radius: 5, x: 10, y: 10)
                    .allowsHitTesting(false)
                    .offset(x: CGFloat(xOffset), y: CGFloat(yOffset))
            } else {
                Text(markdown: title)
                    .font(font)
                    .foregroundStyle(.linearGradient(colors: gradientColors, startPoint: .top, endPoint: .bottom))
                    .rotationEffect(Angle(degrees: rotationDegrees))
                    .allowsHitTesting(false)
                    .offset(x: CGFloat(xOffset), y: CGFloat(yOffset))
            }
        }
    }
    
}

#Preview {
    WordArtView()
}
