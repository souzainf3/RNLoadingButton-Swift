# RNLoadingButton-Swift

RNLoadingButotn-Swift is based on [RNLoadingButton](https://github.com/souzainf3/RNLoadingButton) write in Objective-C.

An easy-to-use UIButton subclass with an activity indicator.

The activity state is configurable and can hide the image or text while the activity indicator is displaying .
You can Also choose the position of easily activity indicator or Set It up with a spacing.



[![](https://raw.githubusercontent.com/souzainf3/RNLoadingButton-Swift/master/RNLoadingButtonDemo/Screens/screen1.png)](https://raw.githubusercontent.com/souzainf3/RNLoadingButton-Swift/master/RNLoadingButtonDemo/Screens/screen1.png)
[![](https://raw.githubusercontent.com/souzainf3/RNLoadingButton-Swift/master/RNLoadingButtonDemo/Screens/screen2.png)](https://raw.githubusercontent.com/souzainf3/RNLoadingButton-Swift/master/RNLoadingButtonDemo/Screens/screen2.png)

## Support

- [x] Swift 3 - Current version (4.x.x)
- [x] Swift 2.3 (tag 3.2.0)
- [x] Swift 2.2 (tag 3.0.0)
- [x] Swift 1.2 (tag 2.0.0)
- [x] Swift 1.0 (tag 0.0.1)


## Requirements

* iOS 8.0+ / Mac OS X 10.9+
* Xcode 8.0+, Swift 3

## Adding RNLoadingButton-Swift to your project

#### Carthage

1. Add `github "souzainf3/RNLoadingButton-Swift" "master"` to your Cartfile
2. Run `carthage update` to clone & build the framework

#### [CocoaPods](http://cocoapods.org)

1. Add a pod entry for RNActivityView to your Podfile
```ruby
# Latest release of RNLoadingButton-Swift
pod 'RNLoadingButton-Swift'
```
2. Install the pod(s) by running `pod install`

#### Manually

1. Drag RNLoadingButton.swift to your project

## Using RNLoadingButton-Swift

```swift
//Mark: Buttons From Nib
// Configure State
btn1.hideTextWhenLoading = false
btn1.isLoading = false
btn1.activityIndicatorAlignment = RNActivityIndicatorAlignment.right
btn1.activityIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 10)
btn1.setTitleColor(UIColor(white: 0.673, alpha: 1.0), for: UIControlState.disabled)
btn1.setTitle("connecting", for: UIControlState.disabled)
```


##### Apps using these controls (send yours to souzainf3@yahoo.com.br )
- [Zee - Personal Finances](https://itunes.apple.com/us/app/id422694086).
