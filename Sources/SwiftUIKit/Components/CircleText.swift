//
//  CircleLabel.swift
//  GeometryPractical
//
//  Created by Trung Phan on 3/18/20.
//  Copyright © 2020 TrungPhan. All rights reserved.
//

import Foundation
import SwiftUI

/// The `CircleText` control will display text around a circle in a `SwiftUI View`.
public struct CircleText: View {
    
    // MARK: - Properties
    /// The radius of the circle to display the text in.
    public var radius: Double
    
    /// The text to display.
    public var text: String
    
    /// The width of the box the circle is drawn in.
    public var width:Float = 300
    
    /// The height of the box the circle is drawn in.
    public var height:Float = 300
    
    /// The color to draw the text in.
    public var color:Color = Color.black
    
    /// The font size to draw the text in.
    public var fontSize = 16
    
    /// The kerning between the text.
    public var kerning: CGFloat = 5.0
    
    // MARK: - Calculated Property
    /// The characters in the text string.
    private var texts: [(offset: Int, element:Character)] {
        return Array(text.enumerated())
    }
    
    /// A dictionary of the text and sizes.
    @State var textSizes: [Int:Double] = [:]
    
    // MARK: - Initializers
    /// Creates a new instance of the control.
    /// - Parameters:
    ///   - radius: The radius of the circle to display the text in.
    ///   - text: The text to display.
    ///   - width: The width of the box the circle is drawn in.
    ///   - height: The height of the box the circle is drawn in.
    ///   - color: The color to draw the text in.
    ///   - fontSize: The font size to draw the text in.
    ///   - kerning: The kerning between the text.
    public init(radius: Double, text: String, width: Float = 300, height: Float = 300, color: Color = .black, fontSize: Int = 16, kerning: CGFloat = 5.0) {
        self.radius = radius
        self.text = text
        self.width = width
        self.height = height
        self.color = color
        self.fontSize = fontSize
        self.kerning = kerning
    }
    
    // MARK: - Main Contents
    /// The main contents of the control.
    public var body: some View {
        ZStack {
            ForEach(self.texts, id: \.self.offset) { (offset, element) in
                VStack {
                    Text(String(element))
                        .font(.system(size: CGFloat(fontSize)))
                        .foregroundColor(color)
                        .kerning(self.kerning)
                        .background(Sizeable())
                        .onPreferenceChange(WidthPreferenceKey.self, perform: { size in
                            self.textSizes[offset] = Double(size)
                        })
                    Spacer()
                }
                .rotationEffect(self.angle(at: offset))
                
            }
        }.rotationEffect(-self.angle(at: self.texts.count-1)/2)
            
        .frame(width: CGFloat(width), height: CGFloat(height), alignment: .center)
    }
    
    /// Calculates the angle of the text.
    /// - Parameter index: The index of the text to draw.
    /// - Returns: The angle to draw the text at.
    private func angle(at index: Int) -> Angle {
        guard let labelSize = textSizes[index] else {return .radians(0)}
        let percentOfLabelInCircle = labelSize / radius.perimeter
        let labelAngle = 2 * Double.pi * percentOfLabelInCircle
        
        
        let totalSizeOfPreChars = textSizes.filter{$0.key < index}.map{$0.value}.reduce(0,+)
        let percenOfPreCharInCircle = totalSizeOfPreChars / radius.perimeter
        let angleForPreChars = 2 * Double.pi * percenOfPreCharInCircle
        
        return .radians(angleForPreChars + labelAngle)
    }
    
}

#Preview {
    CircleText(radius: 200, text: "Dwarves Foundation Looking for Golang, FE candidates", color:Color.red)
}

/// Extends double for drawing circular text.
public extension Double {
    // MARK: - Computed Properties
    /// Calculates a perimeter.
    var perimeter: Double {
        return self * 2 * .pi
    }
}


//Get size for label helper
public struct WidthPreferenceKey: PreferenceKey {
    public typealias Value = CGFloat
    
    // MARK: - Properties
    /// The default value.
    public nonisolated(unsafe) static var defaultValue = CGFloat(0)
    
    // MARK: - Computed Pproperties
    /// Reduces the given value.
    /// - Parameters:
    ///   - value: The value the reduce.
    ///   - nextValue: The next value.
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

/// Defines the view that can get its contents size.
public struct Sizeable: View {
    
    // MARK: - Initializers
    /// Creates a new instance of the control.
    public init() {
        
    }
    
    // MARK: - Main Contents
    /// The contents of the view.
    public var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
        }
    }
}
