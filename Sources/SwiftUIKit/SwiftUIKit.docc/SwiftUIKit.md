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
