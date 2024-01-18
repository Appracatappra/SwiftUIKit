//
//  Mutable.swift
//  Escape from Mystic Manor
//
//  Created by Kevin Mullins on 11/16/21.
//

import Foundation
import SwiftUI
import LogManager

/// Provides storage for my wrapped value
open class ValueStorage<T> {
    
    /// The value being stored
    public var storedValue:T? = nil

}

/// Creates a property that can be mutated in a SwiftUI view without kicking off a state change.
@propertyWrapper public struct MutableValue<T> {
    /// Provides storage for the mutating value
    private let storage:ValueStorage = ValueStorage<T>()
    private let name:String
    
    /// The value being wrapped.
    public var wrappedValue:T {
        get {
            if name != "" {
                Debug.log("Fetching \(name): \(storage.storedValue!)")
            }
            return storage.storedValue!
        }
        nonmutating set {
            storage.storedValue = newValue
            if name != "" {
                Debug.log("Setting \(name): \(storage.storedValue!)")
            }
        }
    }
    
    // The value can be bound to SwiftUI
    public var projectedValue: Binding<T> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
    
    // Initializers
    /// Initializes the mutating value.
    /// - Parameter wrappedValue: The initial value for the property.
    public init(wrappedValue:T, name:String = "") {
        self.storage.storedValue = wrappedValue
        self.name = name
        if name != "" {
            Debug.log("Initializing \(name): \(wrappedValue)")
        }
    }
}
