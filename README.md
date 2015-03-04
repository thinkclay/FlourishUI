# FlourishUI

<img src="https://raw.githubusercontent.com/unicorn/FlourishUI/master/Preview.gif" alt="Preview of UI" align="right" />

We absolutely **love** beautiful interfaces! As an organization named Unicorn, we are obligated to be unique and majestic. That is why we have made this highly configurable, out-of-the-box-pretty, User Interface library/kit thingy. It has a minimal set of UI components now, but already packs quite a punch with the UIColor extension, animated Material-inspired buttons, and modal views.

***Release Notes***

[Master](https://github.com/unicorn/FlourishUI/tree/master) contains the latest bleeding edge code. Currently master is supporting Swift 1.2. For backwards compatibility for Swift 1.1 Stable, use the [1.1 branch](https://github.com/unicorn/FlourishUI/tree/1.1).

This library was built on iOS 8.x, but does offer decent backwards compatibility. We haven't tested older devices thoroughly however, so if you find a breaking issue, please file an issue on the repo or submit a pull request!


### Inspiration

This library was hand-written, but borrowed heavily from concepts in [ZFRipple](https://github.com/zoonooz/ZFRippleButton),
[SLCAlertView](https://github.com/vikmeup/SCLAlertView-Swift) and [Material](http://www.google.com/design/spec/material-design/introduction.html). We'd like to thank them for paving the way for some cool concepts and for contributing their code as MIT. Following suit, we have also made this open source and completely void of Copyright or restrictions. Just use it already, and make your apps look like sexy unicorns!


## Installation

Easy, just drap and drop the FlourishUI folder (or individual files) into your project and start using!


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

---
# License

The MIT License (MIT)

Copyright (c) <year> <copyright holders>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
