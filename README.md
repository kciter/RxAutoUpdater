# RxAutoUpdater
[![Version](https://img.shields.io/cocoapods/v/RxAutoUpdater.svg?style=flat)](http://cocoapods.org/pods/RxAutoUpdater)
[![License](https://img.shields.io/cocoapods/l/RxAutoUpdater.svg?style=flat)](http://cocoapods.org/pods/RxAutoUpdater)
[![Platform](https://img.shields.io/cocoapods/p/RxAutoUpdater.svg?style=flat)](http://cocoapods.org/pods/RxAutoUpdater)
[![Build Status](https://travis-ci.org/kciter/RxAutoUpdater.svg?branch=master)](https://travis-ci.org/kciter/RxAutoUpdater)

Auto update to data for UITableView/UICollectionView

## Preview
```
$ pod try RxAutoUpdater
```
<table>
  <tr>
    <th width="30%">Example</th>
    <th width="30%">In Action</th>
  </tr>
  <tr>
    <td><pre>
tableView.rx_autoUpdate(items, 
                        animationTypes: animationTypes, 
                        identifier: "Cell") { index, cell, item in
    cell.textLabel?.text = item
}.addDisposableTo(disposeBag)

addButton.rx_tap
    .subscribeNext {
        self.items.append("Appended")
    }.addDisposableTo(disposeBag)

removeButton.rx_tap
    .subscribeNext {
        self.items.removeLast()
    }.addDisposableTo(disposeBag)

tableView.rx_itemSelected
    .subscribeNext { indexPath in
        self.items[indexPath.row] = "Changed!"
    }.addDisposableTo(disposeBag)</pre></td>
    <td><img src="https://raw.githubusercontent.com/kciter/RxAutoUpdater/master/Images/usage.gif"></td>
  </tr>
</table>

## Requirements
* iOS 7.0+
* Swift 2.2
* Xcode 7

## Installation
* **CocoaPods**
  ```ruby
  use_frameworks!
  pod "GlitchLabel"
  ```
  
* **Manually**
  To install manually the GlitchLabel in an app, just drag the `Sources/*.swift` file into your project.

## Simple Usage

### `UITableView`
```swift
var items: TableItem<String> = ["Item1", "Item2", "Item3"]
tableView.rx_autoUpdate(items, identifier: "Cell") { index, cell, item in
    cell.textLabel?.text = item
}.addDisposableTo(disposeBag)
```

* Change animation type
```swift
let animationTypes = RxTableViewAnimationType(insertAnimation: .Left, 
                                              deleteAnimation: .Right, 
                                              reloadAnimation: .None)
tableView.rx_autoUpdate(items, 
                        animationTypes: animationTypes, 
                        identifier: "Cell") { index, cell, item in
    cell.textLabel?.text = item
}.addDisposableTo(disposeBag)
```

### `UICollectionView`
```swift
var items: CollectionItem<UIColor> = [UIColor.blackColor(),
                                      UIColor.yellowColor(),
                                      UIColor.redColor(),
                                      UIColor.greenColor(),
                                      UIColor.brownColor()]

collectionView.rx_autoUpdate(items, identifier: "Cell") { index, cell, item in
    cell.backgroundColor = item
}.addDisposableTo(disposeBag)
```

## License
The MIT License (MIT)

Copyright (c) 2016 Lee Sun-Hyoup

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
