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
    
    /// The optional URL to an image, if not `nil` this will override the `imageName` property.
    /// - Remark: This property is being used to support images stored in a Swift Package bundle.
    public var imageURL:URL? = nil
    
    /// The scale to show the image at as a percentage.
    public var scale:Float = 1.0
    
    /// If `true`, the image will ignore the safe area. This is useful to flood a background all the way to the edges of the device.
    public var ignoreSafeArea:Bool = true
    
    // MARK: - Calculated Properties
    /// The scale to show the image at.
    public var imageScale:CGFloat {
        return CGFloat(scale)
    }
    
    // MARK: - Initializers
    /// Creates a new instance of the control.
    /// - Parameters:
    ///   - imageName: he name of the image to display.
    ///   - imageURL: A `URL` representing the souce of an image.
    ///   - scale: The scale to show the image at as a percentage.
    ///   - ignoreSafeArea: If `true`, the image will ignore the safe area. This is useful to flood a background all the way to the edges of the device.
    public init(imageName: String = "", imageURL:URL? = nil, scale: Float = 1.0, ignoreSafeArea: Bool = true) {
        self.imageName = imageName
        self.imageURL = imageURL
        self.scale = scale
        self.ignoreSafeArea = ignoreSafeArea
    }
    
    // MARK: - Main Contents
    /// The contents of the control.
    public var body: some View {
        #if os(macOS)
        if let imageURL {
            let sourceImage = NSImage.scaledImage(bundleURL: imageURL, scale: imageScale)
            contents(sourceImage: sourceImage)
        } else {
            let sourceImage = NSImage.asset(named: imageName, atScale: imageScale)
            contents(sourceImage: sourceImage)
        }
        #else
        if let imageURL {
            let sourceImage = UIImage.scaledImage(bundleURL: imageURL, scale: imageScale)
            contents(sourceImage: sourceImage)
        } else {
            let sourceImage = UIImage.asset(named: imageName, atScale: imageScale)
            contents(sourceImage: sourceImage)
        }
        #endif
    }
    #if os(macOS)
    @ViewBuilder func contents(sourceImage:NSImage?) -> some View {
        if let sourceImage {
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
    }
    #else
    @ViewBuilder func contents(sourceImage:UIImage?) -> some View {
        if let sourceImage {
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
    }
    #endif
}

#Preview {
    ScaledImageView(imageName: "")
}
