//
//  LLAHomeViewController.m
//  LLama
//
//  Created by Live on 16/1/12.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLAHomeViewController.h"
#import "LLAHomeHallViewController.h"
#import "LLAHomeScriptViewController.h"

//view
#import "LLAHomeTitleView.h"

@interface LLAHomeViewController()<UIScrollViewDelegate,LLAHomeTitleViewDelegate>

{
    LLAHomeTitleView *titleView;
    
    UIScrollView *contentScrollView;
    
    LLAHomeHallViewController *hallController;
    LLAHomeScriptViewController *scriptController;
    
}

@end

@implementation LLAHomeViewController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initNaviBarItems];
    [self initSubViews];
}

#pragma mark - Init

- (void) initNaviBarItems {
    
    titleView = [[LLAHomeTitleView alloc] initWithTitles:@[@"大厅",@"剧本"]];
    titleView.delegate = self;
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
}

- (void) initSubViews {
    
    contentScrollView = [[UIScrollView alloc] init];
    contentScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate = self;
    contentScrollView.bounces = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:contentScrollView];
    //
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[contentScrollView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(contentScrollView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[contentScrollView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(contentScrollView)]];
    
    //sub views
    hallController = [[LLAHomeHallViewController alloc] init];
    
    [self addChildViewController:hallController];
    [hallController didMoveToParentViewController:self];
    
    UIView *hallView = hallController.view;
    hallView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentScrollView addSubview:hallView];
    //
    scriptController = [[LLAHomeScriptViewController alloc] init];
    [self addChildViewController:scriptController];
    [scriptController didMoveToParentViewController:self];
    
    UIView *scriptView = scriptController.view;
    scriptView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentScrollView addSubview:scriptView];
    
    //constraints on scrollView
    
    NSMutableArray *constrArr = [NSMutableArray array];
    
    //vertical
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[hallView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(hallView)]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[scriptView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(scriptView)]];
    
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:hallView
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:contentScrollView
      attribute:NSLayoutAttributeHeight
      multiplier:1.0
      constant:0]];
    
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:scriptView
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:contentScrollView
      attribute:NSLayoutAttributeHeight
      multiplier:1.0
      constant:0]];
    
    //horizonal
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[hallView]-(0)-[scriptView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(hallView,scriptView)]];
    
    
    
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:hallView
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:contentScrollView
      attribute:NSLayoutAttributeWidth
      multiplier:1.0
      constant:0]];
    
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:scriptView
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:contentScrollView
      attribute:NSLayoutAttributeWidth
      multiplier:1.0
      constant:0]];
    //
    
    [contentScrollView addConstraints: constrArr];
    
}

#pragma mark - LLAHomeTitleViewDelegate

- (void) titleView:(LLAHomeTitleView *)titleView didSelectedIndex:(NSInteger)index {
    [contentScrollView setContentOffset:CGPointMake(self.view.frame.size.width*index, contentScrollView.contentOffset.y) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat propotion = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    [titleView scrollWithProportion:propotion];
}

@end
