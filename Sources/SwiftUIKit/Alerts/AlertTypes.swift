//
//  File.swift
//  Stuff To Get
//
//  Created by Kevin Mullins on 4/20/21.
//

import Foundation
import SwiftUI

/**
Class can be added to a SwiftUI View to control which Alert to display.
 
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
open class AlertTypes: AlertState<AlertTypes.State> {
    
    // MARK: - Type Aliases
    /// Defines a type alias returned from a call to a CloudKit database function.
    public typealias AlertAction = () -> Void
    
    public static var shared:AlertTypes = AlertTypes()
    
    /// A list of the available Alerts that can be displayed in the App
    public enum State {
        /// Display standard alert with an OK button.
        case showOk(title:String, description:String)
        
        /// Display an alert with OK and Cancel buttons. Provides an action to take when the user selects OK.
        case showOkCancel(title:String, description:String, perform:AlertAction)
        
        /// Display an alert with a destructive action and Cancel buttons. Provides an action to take when the user selects the destructive action .
        case showDestructiveAction(title:String, description:String, buttonLabel:String, perform:AlertAction)
    }
    
    /**
     Builds the contents for the given Alert Type and returns it.
     */
    public func contents() -> Alert {
        switch self.state {
        case let .showOk(title, description):
            // Return the standard OK Alert.
            return Alert(title: Text(title), message: Text(description), dismissButton: .default(Text("OK")))
        case let .showOkCancel(title, description, perform):
            // Return the standard OK/Cancel Alert.
            return Alert(title: Text(title), message: Text(description),
                      primaryButton: .default (Text("OK")) {
                        perform()
                      },
                      secondaryButton: .cancel(Text("Cancel"))
                  )
        case let .showDestructiveAction(title, description, buttonLabel, perform):
            // Return the standard OK/Cancel Alert.
            return Alert(title: Text(title), message: Text(description),
                         primaryButton: .destructive (Text(buttonLabel)) {
                        perform()
                      },
                      secondaryButton: .cancel(Text("Cancel"))
                  )
        default:
            // Return a Opps! Something went wrong Alert.
            return Alert(title: Text("Error"), message: Text("An unknown error has occurred"), dismissButton: .default(Text("OK")))
        }
    }
}
