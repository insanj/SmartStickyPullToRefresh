//
//  SmartStickyPullToRefresh.h
//  Pods
//
//  Created by Julian Weiss on 2/16/16.
//
//

#import <UIKit/UIKit.h>
#import "SmartStickyPullToRefreshDelegate.h"

typedef NS_ENUM(NSUInteger, SmartStickyPullToRefreshState) {
    SmartStickyPullToRefreshStateNotActivated = 0,
    SmartStickyPullToRefreshStatePreActivated = 1,
    SmartStickyPullToRefreshStateActivated = 2,
    SmartStickyPullToRefreshStateAlreadyRefreshedThisTime = 3,
};

@interface SmartStickyPullToRefresh : NSObject

@property (strong, nonatomic) UIView *stickyParentView;

@property (strong, nonatomic) UIScrollView *stickyScrollView;

@property (nonatomic, readwrite) CGFloat stickyScrollViewDeactivationOffset, stickyScrollViewActivationOffset; // contentOffset.y in stickyScrollView that fully activates pullToRefresh (default is -164.0 which means you probably want to use 0, or something to activate at the precise sensitivity desired)

@property (nonatomic, readwrite) CGFloat stickyScrollViewPreActivationOffset; // usually just a few points off from stickyScrollViewActivationOffset, defaults to -100.0

@property (strong, nonatomic) NSObject <SmartStickyPullToRefreshDelegate> *stickySmartDelegate;

@property (nonatomic, readonly) SmartStickyPullToRefreshState stickyRefreshState; // current state

- (void)beginDetectingPullToRefresh;

- (void)stopDetectingPullToRefresh;

- (void)stopAnimating;

// ***** CUSTOMIZATION PROPERTIES, SET BEFORE beginDetectingPullToRefresh ***** //

@property (nonatomic, readwrite) UIBlurEffect *stickyBlurEffect;

@property (strong, nonatomic) UIColor *stickyTextColor;

@property (nonatomic, readwrite) UIView *stickyIndicatorView; // controls height of the view itself!

@property (strong, nonatomic) NSString *stickyPreActivationMessage, *stickyActivationMessage;

@end
