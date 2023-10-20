//
//  AlertState.swift
//  Stuff To Get
//
//  Created by Kevin Mullins on 4/20/21.
//

import Foundation
import SwiftUI

// TODO: Cannot remove `ObservableObject` from this class.
/**
 Handles showing a given Alert in the UI.
 
 ## Example
 
 ```swift
 @ObservedObject var alert = AlertTypes()
 
 ...
 
 alert.state = .showOkCancel(title: "Restore Defaults", description: "Restore default Product Categories?", perform: {
     dataStore.restoreDefaultCategories()
 })
 
 ...
 
 .alert(isPresented: $alert.isShowing) {
     alert.contents()
 }
 ```
 */
open class AlertState<State>: ObservableObject {
    
    // MARK: - Properties
    /// If `true`, the UI needs to display the given alert.
    @Published public var isShowing = false
    
    /// The type of alert to display. if `nil`, no sheet should be displayed.
    @Published public var state: State? {
        didSet { isShowing = state != nil }
    }
}
