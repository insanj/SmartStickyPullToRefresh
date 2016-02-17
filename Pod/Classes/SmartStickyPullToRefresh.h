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

@property (nonatomic, readwrite) CGFloat stickyScrollViewPreActivationOffset, stickyScrollViewDeactivationOffset, stickyScrollViewActivationOffset; // contentOffset.y in stickyScrollView that means (0) the refreshControl should be "deactivated", if in pre-activated state (1) the refreshControl should pre-activate and show the appropriate label, or (3) fully activates pullToRefresh (default is -64.0, -100.0, -164.0)

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
