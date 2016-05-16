# DropdownMenu

<!--[![Pod Version](https://img.shields.io/cocoapods/v/DropdownMenu.svg?style=flat)](http://cocoadocs.org/docsets/DropdownMenu/)-->
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/0x51/DropdownMenu/blob/master/LICENSE)
![Language](https://img.shields.io/badge/language-Swift-brightgreen.svg?style=flat)
<!--[![Build Status](https://travis-ci.org/qxh/DropdownMenu.svg?branch=master)](https://travis-ci.org/qxh/DropdownMenu)-->

## Demo
![Demo gif](Example/screenCap.gif)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```swift
class ViewController: UIViewController, DropdownMenuMixin { // Adding DropdownMenuMixin conformance 

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Smart"
        self.setupTitleDropdownMenu(["Smart", "Latest", "Neareast", "Most Popular"])//call setupTitleDropdownMenu to create a dropdown menu, the first parameter is the menu items list
    }
}
```

## Requirements

## Installation

DropdownMenu is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DropdownMenu', :git => 'https://github.com/imqxh/DropdownMenu'
```

## Author

Qiu Xinghao, qxh@mail.com

## License

DropdownMenu is available under the MIT license. See the LICENSE file for more info.
