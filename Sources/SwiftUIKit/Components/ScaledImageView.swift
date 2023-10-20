//
//  ScaledImageView.swift
//  Escape from Mystic Manor
//
//  Created by Kevin Mullins on 10/27/21.
//

import SwiftUI
import SwiftletUtilities

public struct ScaledImageView: View {
    public var imageName = "ButtonBack"
    public var scale:Float = 1.0
    public var ignoreSafeArea:Bool = true
    
    public var imageScale:CGFloat {
        return CGFloat(scale)
    }
    
    public var body: some View {
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
    }
}

#Preview {
    ScaledImageView()
}
