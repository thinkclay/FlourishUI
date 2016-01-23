# FlourishUI

[![CI Status](http://img.shields.io/travis/Clay McIlrath/FlourishUI.svg?style=flat)](https://travis-ci.org/Clay McIlrath/FlourishUI)
[![Version](https://img.shields.io/cocoapods/v/FlourishUI.svg?style=flat)](http://cocoapods.org/pods/FlourishUI)
[![License](https://img.shields.io/cocoapods/l/FlourishUI.svg?style=flat)](http://cocoapods.org/pods/FlourishUI)
[![Platform](https://img.shields.io/cocoapods/p/FlourishUI.svg?style=flat)](http://cocoapods.org/pods/FlourishUI)

<img src="https://raw.githubusercontent.com/unicorn/FlourishUI/2.0/Preview.gif" alt="Preview of UI" align="right" />

We absolutely **love** beautiful interfaces! As an organization named Unicorn, we are obligated to be unique and majestic. That is why we have made this highly configurable, out-of-the-box-pretty, User Interface library/kit thingy. It has a minimal set of UI components now, but already packs quite a punch with the UIColor extension, animated Material-inspired buttons, and modal views.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.






***Release Notes***

[Master](https://github.com/unicorn/FlourishUI/tree/master) contains the latest bleeding edge code. Currently master is supporting Swift 2.1 and up.

This library was built on iOS 8.x, but does offer decent backwards compatibility. We haven't tested older devices thoroughly however, so if you find a breaking issue, please file an issue on the repo or submit a pull request!


### Inspiration

This library was hand-written, but borrowed from concepts in [ZFRipple](https://github.com/zoonooz/ZFRippleButton),
[SLCAlertView](https://github.com/vikmeup/SCLAlertView-Swift) and [Material](http://www.google.com/design/spec/material-design/introduction.html). We'd like to thank them for paving the way for some cool concepts and for contributing their code as MIT. Following suit, we have also made this open source and completely void of Copyright or restrictions. Just use it already, and make your apps look like sexy unicorns!


## Installation

FlourishUI is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "FlourishUI"
```

Or if you prefer to skip cocoapods, you can simply drag and drop the [source files](https://github.com/thinkclay/FlourishUI/tree/master/Pod/Classes) directly into your Xcode project.


## Usage

Most of the code should be pretty self documenting. FlourishUI uses structs and enums heavily to make an easy-to-read and highly meta approach. Future updates will probably keep the API mostly the same, but switch to a better underlying infrastructure of getters and setters.

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

```swift
// Create colors with hex value in string
let red = UIColor(rgba: "#ff0000")

// Darken or lighten the value (lightness)
// 1 = 100% therefore > 1 is lighter and < 1 is darker
UIColor.adjustValue(red, percentage: 1.5)
```

## License

FlourishUI is available under the MIT license. See the LICENSE file for more info.
