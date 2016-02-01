//
//  LLALoveViewController.m
//  LLama
//
//  Created by tommin on 16/2/1.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLALoveViewController.h"
#import "LLAWhoLoveMeViewController.h"
#import "LLAILoveWhoViewController.h"
#import "LLALoveTitleView.h"

@interface LLALoveViewController ()<UIScrollViewDelegate, LLALoveTitleViewDelegate>
{
    LLALoveTitleView *titleView;
    
    UIScrollView *contentScrollView;
    
    LLAWhoLoveMeViewController *whoLoveMeController;
    LLAILoveWhoViewController *iLoveWhoController;
    
}

@end

@implementation LLALoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 设置状态栏
    [self initNaviBarItems];
    // 设置子控件
    [self initSubViews];

}

// 设置状态栏
- (void) initNaviBarItems {
    
    titleView = [[LLALoveTitleView alloc] initWithTitles:@[@"谁喜欢我",@"我喜欢谁"]];
    titleView.delegate = self;
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
}

// 设置子控件
- (void) initSubViews {
    
    // scrolView
    contentScrollView = [[UIScrollView alloc] init];
    contentScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate = self;
    contentScrollView.bounces = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentScrollView];
    
    // 添加scrolView约束
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
    
    // 添加大厅子控制器
    whoLoveMeController = [[LLAWhoLoveMeViewController alloc] init];
    [self addChildViewController:whoLoveMeController];
    [whoLoveMeController didMoveToParentViewController:self];
    UIView *whoLoveMeView = whoLoveMeController.view;
    whoLoveMeView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentScrollView addSubview:whoLoveMeView];
    
    // 添加剧本子控制器
    iLoveWhoController = [[LLAILoveWhoViewController alloc] init];
    [self addChildViewController:iLoveWhoController];
    [iLoveWhoController didMoveToParentViewController:self];
    UIView *iLoveWhoView = iLoveWhoController.view;
    iLoveWhoView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentScrollView addSubview:iLoveWhoView];
    
    // 给内部子控制器添加约束
    
    NSMutableArray *constrArr = [NSMutableArray array];
    //vertical
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[whoLoveMeView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(whoLoveMeView)]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[iLoveWhoView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(iLoveWhoView)]];
    
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:whoLoveMeView
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:contentScrollView
      attribute:NSLayoutAttributeHeight
      multiplier:1.0
      constant:0]];
    
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:iLoveWhoView
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:contentScrollView
      attribute:NSLayoutAttributeHeight
      multiplier:1.0
      constant:0]];
    
    //horizonal
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[whoLoveMeView]-(0)-[iLoveWhoView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(whoLoveMeView,iLoveWhoView)]];
    
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:whoLoveMeView
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:contentScrollView
      attribute:NSLayoutAttributeWidth
      multiplier:1.0
      constant:0]];
    
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:iLoveWhoView
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:contentScrollView
      attribute:NSLayoutAttributeWidth
      multiplier:1.0
      constant:0]];
    
    [contentScrollView addConstraints: constrArr];
    
}
// 点击了顶部标题view按钮跳到不同子控制器
- (void) titleView:(LLALoveTitleView *)titleView didSelectedIndex:(NSInteger)index {
    [contentScrollView setContentOffset:CGPointMake(self.view.frame.size.width*index, contentScrollView.contentOffset.y) animated:YES];
    
}

#pragma mark - UIScrollViewDelegate

// 滑动scrollView时候调用
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat propotion = (scrollView.contentOffset.x) / scrollView.frame.size.width;
    
    [titleView scrollWithProportion:propotion];
    
}


@end
