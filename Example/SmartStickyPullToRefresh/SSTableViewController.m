//
//  SSTableViewController.m
//  SmartStickyPullToRefresh
//
//  Created by insanj on 02/15/2016.
//  Copyright (c) 2016 insanj. All rights reserved.
//

#import "SSTableViewController.h"

@interface SSTableViewController ()

@property (strong, nonatomic) NSArray *smartPhrases, *smartPhraseHeights;

@end

@implementation SSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.961 green:0.549 blue:0.369 alpha:1.00];
    
    self.title = @"SmartStickyPullToRefresh";
    
    [self setupSmartPhrases];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self setupSmartPhrases];
        [self.tableView reloadData];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup

- (void)setupSmartPhrases {
    _smartPhrases = @[@"You can fail at what you don't want, so you might as well take a chance on doing what you love. -- Bruno Ize, NeedMonkey",
                      @"Stop looking for the magic formula. There isn't one. Nothing beats hard work, doing your own research and experimentation. -- Jason Shen, Ship Your Side Project",
                      @"Life's not so serious. -- Kevin Robinson,  Juniper Jones",
                      @"Innovation is a feat not of intellect, but of will. -- Anne Sorenson, Bonsai"];
    
    NSMutableArray *generatedHeights = [NSMutableArray arrayWithCapacity:_smartPhrases.count];
    CGSize phraseBoundingSize = CGSizeMake(self.tableView.frame.size.width - 25.0, INFINITY);
    for (NSString *phrase in _smartPhrases) {
        CGSize phraseSize = [phrase boundingRectWithSize:phraseBoundingSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular]} context:nil].size;
        [generatedHeights addObject:@(phraseSize.height + 20.0)];
    }
    
    _smartPhraseHeights = [NSArray arrayWithArray:generatedHeights];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _smartPhrases.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row > _smartPhraseHeights.count ? 80.0 : [_smartPhraseHeights[indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *smartStickyCellIdentifier = @"smartStickyCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:smartStickyCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:smartStickyCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular];
        cell.textLabel.textColor = [UIColor colorWithRed:0.192 green:0.184 blue:0.176 alpha:1.00];
        cell.textLabel.numberOfLines = 0;
    }
    
    cell.textLabel.text = _smartPhrases[indexPath.row];
    
    return cell;
}

@end
