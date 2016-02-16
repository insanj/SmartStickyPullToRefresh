# SmartStickyPullToRefresh

[![Version](https://img.shields.io/cocoapods/v/SmartStickyPullToRefresh.svg?style=flat)](http://cocoapods.org/pods/SmartStickyPullToRefresh)
[![License](https://img.shields.io/cocoapods/l/SmartStickyPullToRefresh.svg?style=flat)](http://cocoapods.org/pods/SmartStickyPullToRefresh)
[![Platform](https://img.shields.io/cocoapods/p/SmartStickyPullToRefresh.svg?style=flat)](http://cocoapods.org/pods/SmartStickyPullToRefresh)

## Usage

	SmartStickyPullToRefresh *control = [[SmartStickyPullToRefresh alloc] init];
	
	control.stickyParentView = self.navigationController.navigationBar; // attaches to bottom using same superview (animates INTO autolayout!)
	
	control.stickyScrollView = self.tableView; // necessary, but only used as a pointer; setter does nothing so we must call:
	
	[control beginDetectingPullToRefresh]; // adds KVO as-needed to stickyScrollView to animate SmartStickyPullToRefresh (a UIView) beneath and anchored below stickyParentView
	
	// [control stopDetectingPullToRefresh]; // removes KVO and any existing pull to refresh business

	control.stickySmartDelegate = self; // optional methods for started animating, VALUE CHANGED, stopped animating, started detecting, stopped detecting

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

SmartStickyPullToRefresh is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod "SmartStickyPullToRefresh"
```

## Author

insanj, insanjmail@gmail.com

## License

SmartStickyPullToRefresh is available under the MIT license. See the LICENSE file for more info.
