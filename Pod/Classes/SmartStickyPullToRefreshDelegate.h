//
//  SmartStickyPullToRefreshDelegate.h
//  Pods
//
//  Created by Julian Weiss on 2/16/16.
//
//

#ifndef SmartStickyPullToRefreshDelegate_h
#define SmartStickyPullToRefreshDelegate_h

#import <UIKit/UIKit.h>

@class SmartStickyPullToRefresh;

@protocol SmartStickyPullToRefreshDelegate <NSObject>

@optional
- (void)pullToRefresh:(SmartStickyPullToRefresh *)refreshControl didStartDetectingFromScrollView:(UIScrollView *)scrollView;

- (void)pullToRefresh:(SmartStickyPullToRefresh *)refreshControl didStopDetectingFromScrollView:(UIScrollView *)scrollView;

- (void)pullToRefreshDidPreActivate:(SmartStickyPullToRefresh *)refreshControl;

- (void)pullToRefreshDidActivate:(SmartStickyPullToRefresh *)refreshControl;

- (void)pullToRefreshValueChanged:(SmartStickyPullToRefresh *)refreshControl;

- (void)pullToRefreshDidStopActivating:(SmartStickyPullToRefresh *)refreshControl;

@end

#endif /* SmartStickyPullToRefreshDelegate_h */
