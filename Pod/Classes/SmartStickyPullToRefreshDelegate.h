//
//  SmartStickyPullToRefreshDelegate.h
//  Pods
//
//  Created by Julian Weiss on 2/16/16.
//
//

#import <UIKit/UIKit.h>

@class SmartStickyPullToRefresh;

@protocol SmartStickyPullToRefreshDelegate <NSObject>

@required
- (void)pullToRefreshValueChanged:(SmartStickyPullToRefresh *)refreshControl;

@optional
- (void)pullToRefresh:(SmartStickyPullToRefresh *)refreshControl didStartDetectingFromScrollView:(UIScrollView *)scrollView;

- (void)pullToRefresh:(SmartStickyPullToRefresh *)refreshControl didStopDetectingFromScrollView:(UIScrollView *)scrollView;

- (void)pullToRefreshDidPreActivate:(SmartStickyPullToRefresh *)refreshControl;

- (void)pullToRefreshDidStopActivating:(SmartStickyPullToRefresh *)refreshControl;

@end
