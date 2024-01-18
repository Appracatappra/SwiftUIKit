//
//  Mutable.swift
//  Escape from Mystic Manor
//
//  Created by Kevin Mullins on 11/16/21.
//

import Foundation
import SwiftUI

/// Provides storage for my wrapped value
class ValueStorage<T> {
    
    /// The value being stored
    var storedValue:T? = nil

}

/// Creates a property that can be mutated in a SwiftUI view without kicking off a state change.
@propertyWrapper struct MutableValue<T> {
    /// Provides storage for the mutating value
    private let storage:ValueStorage = ValueStorage<T>()
    private let name:String
    
    /// The value being wrapped.
    var wrappedValue:T {
        get {
            if name != "" {
                print("Fetching \(name): \(storage.storedValue!)")
            }
            return storage.storedValue!
        }
        nonmutating set {
            storage.storedValue = newValue
            if name != "" {
                print("Setting \(name): \(storage.storedValue!)")
            }
        }
    }
    
    // The value can be bound to SwiftUI
    var projectedValue: Binding<T> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
    
    // Initializers
    /// Initializes the mutating value.
    /// - Parameter wrappedValue: The initial value for the property.
    init(wrappedValue:T, name:String = "") {
        self.storage.storedValue = wrappedValue
        self.name = name
        if name != "" {
            print("Initializing \(name): \(wrappedValue)")
        }
    }
}
