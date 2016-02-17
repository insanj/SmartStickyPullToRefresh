//
//  SmartStickyPullToRefresh.m
//  Pods
//
//  Created by Julian Weiss on 2/16/16.
//
//

#import "SmartStickyPullToRefresh.h"
#import "CompactConstraint.h"

@interface SmartStickyPullToRefresh ()

@property (strong, nonatomic) UIVisualEffectView *pullToRefreshBlurView;

@property (strong, nonatomic) UILabel *pullToRefreshLabel;

@property (strong, nonatomic) UIScrollView *pullToRefreshCurrentScrollView;

@end

@implementation SmartStickyPullToRefresh

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.stickyBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.stickyTextColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        self.stickyIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [((UIActivityIndicatorView *)self.stickyIndicatorView) startAnimating];
        self.stickyPreActivationMessage = @"Pull to Refresh";
        self.stickyActivationMessage = @"Refreshing...";
        
        self.stickyScrollViewDeactivationOffset = -64.0;
        self.stickyScrollViewPreActivationOffset = -100.0;
        self.stickyScrollViewActivationOffset = -164.0;
    }
    
    return self;
}

#pragma mark - enable / disable

- (void)beginDetectingPullToRefresh {
    _pullToRefreshCurrentScrollView = _stickyScrollView;
    [self setupPullToRefreshInParentView];
    [self setupPullToRefreshKeyValueObserver];
    
    if (self.stickySmartDelegate && [self.stickySmartDelegate respondsToSelector:@selector(pullToRefresh:didStartDetectingFromScrollView:)]) {
        [self.stickySmartDelegate pullToRefresh:self didStartDetectingFromScrollView:_pullToRefreshCurrentScrollView];
    }
}

- (void)stopDetectingPullToRefresh {
    [self deactivatePullToRefresh];
    [_pullToRefreshCurrentScrollView removeObserver:self forKeyPath:@"contentOffset"];
    
    if (self.stickySmartDelegate && [self.stickySmartDelegate respondsToSelector:@selector(pullToRefresh:didStopDetectingFromScrollView:)]) {
        [self.stickySmartDelegate pullToRefresh:self didStopDetectingFromScrollView:_pullToRefreshCurrentScrollView];
    }
}

#pragma mark - setup

- (void)setupPullToRefreshInParentView {
    if (_pullToRefreshBlurView) {
        [_pullToRefreshBlurView removeFromSuperview];
    }

    CGFloat pullToRefreshHeight = _stickyIndicatorView.frame.size.height;
    // CGFloat pullToRefreshBannerHeight = pullToRefreshHeight + 20.0;
    
    _pullToRefreshBlurView = [[UIVisualEffectView alloc] initWithEffect:_stickyBlurEffect];
    _pullToRefreshBlurView.translatesAutoresizingMaskIntoConstraints = YES;
    _pullToRefreshBlurView.clipsToBounds = YES;
    //_pullToRefreshBlurView.layer.cornerRadius = 4.0;
    _pullToRefreshBlurView.layer.borderWidth = 0.5;
    _pullToRefreshBlurView.layer.borderColor = _stickyTextColor.CGColor;
    
    _pullToRefreshLabel = [[UILabel alloc] init];
    _pullToRefreshLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _pullToRefreshLabel.numberOfLines = 1;
    _pullToRefreshLabel.textAlignment = NSTextAlignmentCenter;
    _pullToRefreshLabel.textColor = _stickyTextColor;
    _pullToRefreshLabel.adjustsFontSizeToFitWidth = YES;
    _pullToRefreshLabel.minimumScaleFactor = 0.1;
    _pullToRefreshLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _pullToRefreshLabel.text = _stickyPreActivationMessage;
    [_pullToRefreshBlurView.contentView addSubview:_pullToRefreshLabel];
    
    _stickyIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [_pullToRefreshBlurView.contentView addSubview:_stickyIndicatorView];

    [_pullToRefreshBlurView.contentView addCompactConstraints:@[@"indicator.width = refreshHeight",
                                                                @"indicator.height = refreshHeight",
                                                                @"indicator.top = super.top + 10",
                                                                @"indicator.bottom = super.bottom - 10",
                                                                @"indicator.right = label.left - 10",
                                                                
                                                                @"label.width <= super.width - refreshNeededWidth",
                                                                @"label.top = super.top + 10",
                                                                @"label.bottom = super.bottom - 10",
                                                                @"label.centerX = super.centerX",]
                                                      metrics:@{@"refreshHeight" : @(pullToRefreshHeight),
                                                                @"refreshNeededWidth" : @(pullToRefreshHeight + 30.0)}
                                                        views:@{@"indicator" : _stickyIndicatorView,
                                                                @"label" : _pullToRefreshLabel}];
    
    _stickyIndicatorView.alpha = 0.0;
}

- (void)setupPullToRefreshKeyValueObserver {
    [_stickyScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - activate

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == _stickyScrollView) {
        CGPoint currentOffsetPoint = [change[NSKeyValueChangeNewKey] CGPointValue];
        CGFloat currentOffset = currentOffsetPoint.y;
        
        NSLog(@"current %f, pre %f, act %f", currentOffset, _stickyScrollViewPreActivationOffset, _stickyScrollViewActivationOffset);
        
        if (currentOffset > _stickyScrollViewPreActivationOffset) { // not activated at all
            if (currentOffset >= self.stickyScrollViewDeactivationOffset && _stickyRefreshState == SmartStickyPullToRefreshStateAlreadyRefreshedThisTime) {
                _stickyRefreshState = SmartStickyPullToRefreshStateNotActivated;
            }
            
            else if (_stickyRefreshState == SmartStickyPullToRefreshStatePreActivated) {
                [self deactivatePullToRefresh];
            }
        }
        
        else if (currentOffset > _stickyScrollViewActivationOffset) { // surpassed pre-activation area, PRE ACTIVATE
            [self preactivatePullToRefresh];
        }
        
        else { // surpassed activation area, ACTIVATE
            [self activatePullToRefresh];
        }
    }
}

- (void)preactivatePullToRefresh {
    if (_stickyRefreshState != SmartStickyPullToRefreshStateNotActivated) {
        NSLog(@"preactivatePullToRefresh: refresh state is activated or pre activated (%i)", (int)_stickyRefreshState);
        return;
    }
    
    _pullToRefreshLabel.text = _stickyPreActivationMessage;
    _stickyRefreshState = SmartStickyPullToRefreshStatePreActivated;
    _stickyIndicatorView.alpha = 0.0;

    _pullToRefreshBlurView.translatesAutoresizingMaskIntoConstraints = YES;
    CGFloat pullToRefreshBannerHeight = _stickyIndicatorView.frame.size.height + 20.0;
    _pullToRefreshBlurView.frame = CGRectMake(-1.0, -pullToRefreshBannerHeight, _stickyParentView.frame.size.width + 2.0, pullToRefreshBannerHeight);
    
    [_stickyParentView.superview insertSubview:_pullToRefreshBlurView belowSubview:_stickyParentView];
    
    CGRect pullToRefreshActivatedFrame = CGRectMake(-1.0, CGRectGetMaxY(_stickyParentView.frame) - 1.0, _stickyParentView.frame.size.width + 2.0, pullToRefreshBannerHeight);
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _pullToRefreshBlurView.frame = pullToRefreshActivatedFrame;
    } completion:^(BOOL finished) {
        _pullToRefreshBlurView.translatesAutoresizingMaskIntoConstraints = NO;
        [_pullToRefreshBlurView.superview addCompactConstraints:@[@"blur.top = stickyParent.bottom - 1",
                                                                  @"blur.left = super.left - 1",
                                                                  @"blur.right = super.right + 1",
                                                                  @"blur.height = blurHeight"]
                                                        metrics:@{@"blurHeight" : @(pullToRefreshBannerHeight)}
                                                          views:@{@"blur" : _pullToRefreshBlurView,
                                                                  @"stickyParent" : _stickyParentView}];
    
        if (self.stickySmartDelegate && [self.stickySmartDelegate respondsToSelector:@selector(pullToRefreshDidPreActivate:)]) {
            [self.stickySmartDelegate pullToRefreshDidPreActivate:self];
        }
        
        /*else if (_stickyRefreshState == SmartStickyPullToRefreshStateActivated) {
            if (self.stickySmartDelegate && [self.stickySmartDelegate respondsToSelector:@selector(pullToRefreshValueChanged:)]) {
                [self.stickySmartDelegate pullToRefreshValueChanged:self];
            }
        }*/
    }];
}

- (void)activatePullToRefresh {
    if (_stickyRefreshState == SmartStickyPullToRefreshStateActivated) {
        NSLog(@"activatePullToRefresh: needs to not already be activated");
        return;
    }
    
    else if (_stickyRefreshState == SmartStickyPullToRefreshStateAlreadyRefreshedThisTime) {
        NSLog(@"activatePullToRefresh: already refreshed this time, go to offset 0 first");
        return;
    }
    
    [self preactivatePullToRefresh];
    
    _stickyRefreshState = SmartStickyPullToRefreshStateActivated;
    _pullToRefreshLabel.text = _stickyActivationMessage;
    _stickyIndicatorView.alpha = 1.0;
    
    if (self.stickySmartDelegate && [self.stickySmartDelegate respondsToSelector:@selector(pullToRefreshValueChanged:)]) {
        [self.stickySmartDelegate pullToRefreshValueChanged:self];
    }
}

- (void)deactivatePullToRefresh {
    if (_stickyRefreshState == SmartStickyPullToRefreshStateNotActivated) {
        NSLog(@"activatePullToRefresh: needs to be activated or preactivated (%i)", (int)_stickyRefreshState);
        return;
    }
    
    if (_stickyRefreshState == SmartStickyPullToRefreshStateActivated) {
        _stickyRefreshState = SmartStickyPullToRefreshStateAlreadyRefreshedThisTime;
    }
    
    else if (_stickyRefreshState == SmartStickyPullToRefreshStatePreActivated) {
        _stickyRefreshState = SmartStickyPullToRefreshStateNotActivated;
    }
    
    _pullToRefreshBlurView.translatesAutoresizingMaskIntoConstraints = YES;

    CGFloat pullToRefreshBannerHeight = _stickyIndicatorView.frame.size.height + 20.0;
    _pullToRefreshBlurView.frame = CGRectMake(0, CGRectGetMaxY(_stickyParentView.frame), _stickyParentView.frame.size.width, pullToRefreshBannerHeight);
    
    CGRect dismissedFrame = CGRectMake(0, -pullToRefreshBannerHeight, _stickyParentView.frame.size.width, pullToRefreshBannerHeight);

    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _pullToRefreshBlurView.frame = dismissedFrame;
    } completion:^(BOOL finished) {
        [_pullToRefreshBlurView removeFromSuperview];
        
        if (self.stickySmartDelegate && [self.stickySmartDelegate respondsToSelector:@selector(pullToRefreshDidStopActivating:)]) {
            [self.stickySmartDelegate pullToRefreshDidStopActivating:self];
        }
    }];
}

- (void)stopAnimating {
    [self deactivatePullToRefresh];
}

@end
