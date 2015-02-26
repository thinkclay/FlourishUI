# FlourishUI

We love beautiful interfaces. That's why we made a highly configurable and out-of-the-box-pretty UI library.
It's minimal now, but already packs quite a punch with the UIColor extension, animated Material-inspired buttons, and modal views.

## Installation

*Note* This library was built on Swift 1.2, but does offer decent backwards compatibility. We haven't tested older devices thoroughly however,
so if you find a breaking issue, please file an issue on the repo or submit a pull request!

Easy, just drap and drop the FlourishUI folder (or individual files) into your project and start using!

## Inspiration

This library was hand-written, but borrowed heavily from concepts in [ZFRipple](https://github.com/zoonooz/ZFRippleButton),
[SLCAlertView](https://github.com/vikmeup/SCLAlertView-Swift) and [Material](http://www.google.com/design/spec/material-design/introduction.html).

## Use

Most of the code should be pretty self documenting. FlourishUI uses structs and enums heavily to make an easy-to-read and highly meta approach.

### Button

The Button class is ready to go with Interface Builder and IBDesignable, just inherit!
You can check the demo to see this configured with IB.

### Modal

Modals are heavily based on configurations, and thus, are built and called in code.
We plan on making them more robust in time, but for now, you'll want to simply treat them like you would an AlertView.

```swift
Modal.Overlay.blurStyle = .ExtraLight
Modal.Dialog.shadowType = .Hover
Modal.Dialog.shadowRadius = CGFloat(5)
Modal.Dialog.shadowOffset = CGSize(width: 0, height: 0)
Modal.Dialog.shadowOpacity = 0.1

Modal(title: sender.titleLabel?.text, body: body, status: .Warning).show()
```

### UIColor Extension

You would think Apple would just drop in support for little utilities like these, but alas, we've recreated them:

```swift
// Create colors with hex value in string
let red = UIColor(rgba: "#ff0000")

// Darken or lighten the value (lightness)
// 1 = 100% therefore > 1 is lighter and < 1 is darker
UIColor.adjustValue(red, percentage: 1.5)
```

