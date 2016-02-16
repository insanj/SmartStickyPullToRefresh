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

@end

@implementation SmartStickyPullToRefresh

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.stickyBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.stickyTextColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        self.stickyIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.stickyPreActivationMessage = @"Pull to Refresh...";
        self.stickyActivationMessage = @"Refreshing...";
        
        self.stickyScrollViewPreActivationOffset = CGPointMake(0, -64.0);
        self.stickyScrollViewActivationOffset = CGPointMake(0, -100.0);
    }
    
    return self;
}

#pragma mark - enable / disable

- (void)beginDetectingPullToRefresh {
    [self setupPullToRefreshInParentView];
    [self setupPullToRefreshKeyValueObserver];    
}

- (void)stopDetectingPullToRefresh {
    [self deactivatePullToRefresh];
    [_stickyScrollView removeObserver:self forKeyPath:@"contentOffset.y"];
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
    _pullToRefreshBlurView.layer.cornerRadius = 4.0;
    _pullToRefreshBlurView.layer.borderWidth = 1.0;
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

    [_pullToRefreshBlurView.contentView addCompactConstraints:@[@"indicator.left = super.left + 15",
                                                                @"indicator.width = refreshHeight",
                                                                @"indicator.height = refreshHeight",
                                                                @"indicator.top = super.top + 10",
                                                                @"indicator.bottom = super.bottom - 10",
                                                                
                                                                @"label.left = indicator.right + 15",
                                                                @"label.right = super.right - 15",
                                                                @"label.top = super.top + 10",
                                                                @"label.bottom = super.bottom - 10"]
                                                      metrics:@{@"refreshHeight" : @(pullToRefreshHeight)}
                                                        views:@{@"indicator" : _stickyIndicatorView,
                                                                @"label" : _pullToRefreshLabel}];
}

- (void)setupPullToRefreshKeyValueObserver {
    [_stickyScrollView addObserver:self forKeyPath:@"contentOffset.y" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - activate

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    NSLog(@"%@ -> %@", object, _stickyScrollView);
    if (object == _stickyScrollView) {
        NSNumber *changedOffsetValue = change[NSKeyValueChangeNewKey];
        CGFloat currentOffset = [changedOffsetValue floatValue];
        
        if (currentOffset < _stickyScrollViewPreActivationOffset.y) { // not activated at all
            [self deactivatePullToRefresh];
        }
        
        else if (currentOffset < _stickyScrollViewActivationOffset.y) { // surpassed pre-activation area, PRE ACTIVATE
            [self preactivatePullToRefresh];
        }
        
        else { // surpassed activation area, ACTIVATE
            [self activatePullToRefresh];
        }
    }
}

- (void)preactivatePullToRefresh {
    _stickyPullToRefreshAnimating = YES;
    
    CGFloat pullToRefreshBannerHeight = _stickyIndicatorView.frame.size.height + 20.0;
    _pullToRefreshBlurView.frame = CGRectMake(0, -pullToRefreshBannerHeight, _stickyParentView.frame.size.width, pullToRefreshBannerHeight);
    
    [_stickyParentView.superview addSubview:_pullToRefreshBlurView];
    
    CGRect pullToRefreshActivatedFrame = CGRectMake(0, CGRectGetMaxY(_stickyParentView.frame), _stickyParentView.frame.size.width, pullToRefreshBannerHeight);
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _pullToRefreshBlurView.frame = pullToRefreshActivatedFrame;
    } completion:^(BOOL finished) {
        _pullToRefreshBlurView.translatesAutoresizingMaskIntoConstraints = NO;
        [_pullToRefreshBlurView.superview addCompactConstraints:@[@"blur.top = stickyParent.bottom",
                                                                  @"blur.left = super.left",
                                                                  @"blur.right = super.right",
                                                                  @"blur.height = blurHeight"]
                                                        metrics:@{@"blurHeight" : @(pullToRefreshBannerHeight)}
                                                          views:@{@"blur" : _pullToRefreshBlurView,
                                                                  @"stickyParent" : _stickyParentView}];
    }];
}

- (void)activatePullToRefresh {
    _pullToRefreshLabel.text = _stickyActivationMessage;

    if (!_stickyPullToRefreshAnimating) {
        [self preactivatePullToRefresh];
    }
}

- (void)deactivatePullToRefresh {
    if (!_stickyPullToRefreshAnimating) {
        return;
    }
    
    _pullToRefreshBlurView.translatesAutoresizingMaskIntoConstraints = YES;

    CGFloat pullToRefreshBannerHeight = _stickyIndicatorView.frame.size.height + 20.0;
    _pullToRefreshBlurView.frame = CGRectMake(0, CGRectGetMaxY(_stickyParentView.frame), _stickyParentView.frame.size.width, pullToRefreshBannerHeight);
    
    CGRect dismissedFrame = CGRectMake(0, -pullToRefreshBannerHeight, _stickyParentView.frame.size.width, pullToRefreshBannerHeight);

    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _pullToRefreshBlurView.frame = dismissedFrame;
    } completion:^(BOOL finished) {
        [_pullToRefreshBlurView removeFromSuperview];
         _stickyPullToRefreshAnimating = NO;
    }];
}

@end
