//
//  SmartStickyPullToRefresh.h
//  Pods
//
//  Created by Julian Weiss on 2/16/16.
//
//

#import <UIKit/UIKit.h>
#import "SmartStickyPullToRefreshDelegate.h"

@interface SmartStickyPullToRefresh : NSObject

@property (strong, nonatomic) UIView *stickyParentView;

@property (strong, nonatomic) UIScrollView *stickyScrollView;

@property (nonatomic, readwrite) CGPoint stickyScrollViewActivationOffset; // contentOffset in stickyScrollView that activates pullToRefresh (default is 0,0 which means you probably want to use 0,-CGRectGetMaxY(self.navigationController.navigationBar.frame) or something to activate at the precise sensitivity desired)

@property (nonatomic, readwrite) CGPoint stickyScrollViewPreActivationOffset; // usually just a few points off from stickyScrollViewActivationOffset

@property (strong, nonatomic) NSObject <SmartStickyPullToRefreshDelegate> *stickySmartDelegate;

@property (nonatomic, readwrite) BOOL stickyPullToRefreshAnimating; // current state

- (void)beginDetectingPullToRefresh;

- (void)stopDetectingPullToRefresh;

// ***** CUSTOMIZATION PROPERTIES, SET BEFORE beginDetectingPullToRefresh ***** //

@property (nonatomic, readwrite) UIBlurEffect *stickyBlurEffect;

@property (strong, nonatomic) UIColor *stickyTextColor;

@property (nonatomic, readwrite) UIView *stickyIndicatorView; // controls height of the view itself!

@property (strong, nonatomic) NSString *stickyPreActivationMessage, *stickyActivationMessage;

@end
