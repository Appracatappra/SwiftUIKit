# ``SwiftUIKit``

`SwiftUIKit` provides a collection of common controls for use with `SwiftUI`.

## Overview

`SwiftUIKit` provides a simply way to display alerts in your `SwiftUI Views` and several useful new controls.

### Embedded Sounds

There are two default sounds embedded in `SwiftUIKit`:

* [diamond-click.mp3](https://freesound.org/people/MATRIXXX_/sounds/703884/) - Used when a control gets focus.
* [mouse-click.mp3](https://freesound.org/people/MATRIXXX_/sounds/365648/) - Used when the control is clicked.

Both sounds were sourced from [Freeound.org](https://freesound.org) under the Creative Commons 0 License.

### The SwiftUIKit Class

The `SwiftUIKit` provides a few helper utilities that allow you to easily access resources stored in the Swift Package (such as the sounds above).

For example, the following code would return the path to the `diamond-click.mp3` file:

```
// Option 1
let path = SwiftUIKit.pathTo(resource:"diamond-click.mp3")

// Option 2
let path = SwiftUIKit.pathTo(resource:"diamond-click", ofType: "mp3")
```


### Default Control Settings

Several of the controls defined in `SwiftUIKit` have a static set of properties to control all instances of the control created without specifying those properties.

For example, the `IconButton` defines:

```
/// The default background color for the `IconButton`.
static public var defaultBackgroundColor:Color = .gray
    
/// The default sound source for the `IconButton`.
static public var defaultSoundSource:SwiftUIKit.Source = .packageBundle
    
/// The default button clicked sound `IconButton`.
static public var defaultButtonSound:String = "mouse-click.mp3"
    
/// The default focused sound for the `IconButton`.
static public var defaultButtonFocusSound:String = "diamond-click.mp3"
```

If you wanted to universally style all of the `IconButton` instances used throughout you App, simply adjust the `defaultBackgroundColor` of `IconButton`:

```
IconButton.defaultBackgroundColor = .blue
```

Now all new `IconButtons` created will have a Blue background.

### Where To Set The Style Changes

For style changes to be in effect, you'll need to make the changes before any `Views` are drawn. You can use the following code on your main app:

```
import SwiftUI
import SwiftletUtilities
import LogManager
import SwiftUIKit

@main
struct PackageTesterApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) var colorScheme
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { oldScenePhase, newScenePhase in
            switch newScenePhase {
            case .active:
                Debug.info(subsystem: "PackageTesterApp", category: "Scene Phase", "App is active")
            case .inactive:
                Debug.info(subsystem: "PackageTesterApp", category: "Scene Phase", "App is inactive")
            case .background:
                Debug.info(subsystem: "PackageTesterApp", category: "Scene Phase", "App is in background")
            @unknown default:
                Debug.notice(subsystem: "PackageTesterApp", category: "Scene Phase", "App has entered an unexpected scene: \(oldScenePhase), \(newScenePhase)")
            }
        }
    }
}

/// Class the handle the event that would typically be handled by the Application Delegate so they can be handled in SwiftUI.
class AppDelegate: NSObject, UIApplicationDelegate {
    
    /// Handles the app finishing launching
    /// - Parameter application: The app that has started.
    func applicationDidFinishLaunching(_ application: UIApplication) {
        // Register to receive remote notifications
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    /// Handle the application getting ready to launch
    /// - Parameters:
    ///   - application: The application that is going to launch.
    ///   - launchOptions: Any options being passed to the application at launch time.
    /// - Returns: Returns `True` if the application can launch.
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Set any `SwiftUIKit` global style defaults here before any `Views` are drawn.
        // Set style defaults
        IconButton.defaultBackgroundColor = .blue
        return true
    }
    
    /// Handles the app receiving a remote notification
    /// - Parameters:
    ///   - application: The app receiving the notifications.
    ///   - userInfo: The info that has been sent to the App.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
    }
}
```

With this code in place, make any style changes in `func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool` and they apply to all views built afterwards.
