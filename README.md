# RNLoadingButton(Swift)

RNLoadingButotn(Swift) is based on [RNLoadingButton](https://github.com/souzainf3/RNLoadingButton) write in Objective-C.

An easy-to-use UIButton subclass with an activity indicator.

The activity state is configurable and can hide the image or text while the activity indicator is displaying .
You can Also choose the position of easily activity indicator or Set It up with a spacing.



[![](https://raw.githubusercontent.com/souzainf3/RNLoadingButton-Swift/master/RNLoadingButtonDemo/Screens/screen1.png)](https://raw.githubusercontent.com/souzainf3/RNLoadingButton-Swift/master/RNLoadingButtonDemo/Screens/screen1.png)
[![](https://raw.githubusercontent.com/souzainf3/RNLoadingButton-Swift/master/RNLoadingButtonDemo/Screens/screen2.png)](https://raw.githubusercontent.com/souzainf3/RNLoadingButton-Swift/master/RNLoadingButtonDemo/Screens/screen2.png)

## Features
- [x] Swift 2


## Support
- [x] Swift 1.0 (tag 0.0.1)
- [x] Swift 1.2 (tag 2.0.0)


## Requirements

* iOS 8.0+ / Mac OS X 10.9+
* Xcode 7.0+

## Adding RNLoadingButton-Swift to your project

#### Cocoapods

1. Add a pod entry for RNActivityView to your Podfile `pod 'RNLoadingButton-Swift'`
2. Install the pod(s) by running `pod install`.

#### Manually

1. Drag RNLoadingButton.swift to your project

## Using RNLoadingButton-Swift

```swift
//Mark: Can usage with Nib
// Configure State
btn1.hideTextWhenLoading = false
btn1.loading = false
btn1.activityIndicatorAlignment = RNActivityIndicatorAlignment.Right
btn1.activityIndicatorEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 10)
btn1.setTitle("connecting", forState: UIControlState.Disabled)
```


##### Apps using this controls (send your to souzainf3@yahoo.com.br )
- [Zee - Personal Finances](https://itunes.apple.com/us/app/id422694086).
