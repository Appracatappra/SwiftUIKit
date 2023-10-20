//
//  TextExtensions.swift
//  ReedWriteCycle (iOS)
//
//  Created by Kevin Mullins on 3/9/22.
//

import Foundation
import SwiftUI

// Extentions to the Swift UI Text element.
public extension Text {
    
    // MARK: - Initializers
    /// Creates a new `Text` element from the provided string contianing Markdown code. This allows a `Text` element to be built from a variable containing Markdown and properly display the converted results, not the source for the Markdown.
    /// - Parameter markdown: The source of the Markdown text to render.
    init(markdown:String) {
        var text:AttributedString = ""
        
        do {
            text = try AttributedString(markdown: markdown, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
        } catch {
            text = "Markdown Error!"
        }
        
        self.init(text)
    }
}
