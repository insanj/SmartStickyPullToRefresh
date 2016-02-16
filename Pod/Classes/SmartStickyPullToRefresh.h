//
//  SmartStickyPullToRefresh.h
//  Pods
//
//  Created by Julian Weiss on 2/16/16.
//
//

#import <UIKit/UIKit.h>
#import "SmartStickyPullToRefreshDelegate.h"

@interface SmartStickyPullToRefresh : UIView

@property (strong, nonatomic) UIView *stickyParentView;

@property (strong, nonatomic) UIScrollView *stickyScrollView;

@property (nonatomic, readwrite) CGPoint stickyScrollViewActivationOffset; // contentOffset in stickyScrollView that activates pullToRefresh (default is 0,0 which means you probably want to use 0,-CGRectGetMaxY(self.navigationController.navigationBar.frame) or something to activate at the precise sensitivity desired)

@property (strong, nonatomic) NSObject <SmartStickyPullToRefreshDelegate> *stickySmartDelegate;

@property (nonatomic, readonly) BOOL stickyPullToRefreshAnimating; // current state, use stop to force stop

- (void)beginDetectingPullToRefresh;

- (void)stopDetectingPullToRefresh;

@end
