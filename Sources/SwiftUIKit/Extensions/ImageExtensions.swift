//
//  File.swift
//  
//
//  Created by Kevin Mullins on 10/19/23.
//

import Foundation
import SwiftUI

extension Image {
    // MARK: - Initializers
    init(path:String?) {
        
        guard let path else {
            self.init("")
            return
        }
        
        #if canImport(UIKit)
        guard let image = UIImage(contentsOfFile: path) else {
            self.init("")
            return
        }
        self.init(uiImage: image)
        #elseif canImport(AppKit)
        guard let image = NSImage(contentsOfFile: path) else {
            self.init("")
            return
        }
        self.init(nsImage: image)
        #else
        self.init("")
        #endif
    }
}
