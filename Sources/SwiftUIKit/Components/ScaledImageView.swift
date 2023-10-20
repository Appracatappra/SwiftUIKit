//
//  ScaledImageView.swift
//  Escape from Mystic Manor
//
//  Created by Kevin Mullins on 10/27/21.
//

import SwiftUI
import SwiftletUtilities

/// `ScaledImageView` is a `SwiftUI` control that displays an image in a `SwiftUI View` scaled to a give ratio. The image is scaled directly from the disk storage so that it takes less actual memory in the device.
public struct ScaledImageView: View {
    
    // MARK: - Properties
    /// The name of the image to display.
    public var imageName = ""
    
    /// The scale to show the image at as a percentage.
    public var scale:Float = 1.0
    
    /// If `true`, the image will ignore the safe area. This is useful to flood a background all the way to the edges of the device.
    public var ignoreSafeArea:Bool = true
    
    // MARK: - Calculated Properties
    /// The scale to show the image at.
    public var imageScale:CGFloat {
        return CGFloat(scale)
    }
    
    // MARK: - Main Contents
    /// The contents of the control.
    public var body: some View {
        #if os(macOS)
        if let sourceImage = NSImage.asset(named: imageName, atScale: imageScale) {
            if ignoreSafeArea {
                Image(nsImage: sourceImage)
                    .ignoresSafeArea()
            } else {
                Image(nsImage: sourceImage)
            }
        } else {
            Text("`\(imageName)` Missing")
                .foregroundColor(Color.white)
        }
        #else
        if let sourceImage = UIImage.asset(named: imageName, atScale: imageScale) {
            if ignoreSafeArea {
                Image(uiImage: sourceImage)
                    .ignoresSafeArea()
            } else {
                Image(uiImage: sourceImage)
            }
        } else {
            Text("`\(imageName)` Missing")
                .foregroundColor(Color.white)
        }
        #endif
    }
}

#Preview {
    ScaledImageView()
}
