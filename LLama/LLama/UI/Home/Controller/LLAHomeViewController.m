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

static const NSInteger hallIndex = 0;
static const NSInteger scriptHallIndex = 1;

@interface LLAHomeViewController()<UIScrollViewDelegate,LLAHomeTitleViewDelegate,LLAHomeHallViewControllerDelegate>

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
    // 设置状态栏
    [self initNaviBarItems];
    // 设置子控件
    [self initSubViews];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self scrollViewDidScroll:contentScrollView];
}

#pragma mark - Init
// 设置状态栏
- (void) initNaviBarItems {
    
    titleView = [[LLAHomeTitleView alloc] initWithTitles:@[@"大厅",@"剧本"]];
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
    hallController = [[LLAHomeHallViewController alloc] init];
    hallController.delegate = self;
    [self addChildViewController:hallController];
    [hallController didMoveToParentViewController:self];
    UIView *hallView = hallController.view;
    hallView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentScrollView addSubview:hallView];
    
    // 添加剧本子控制器
    scriptController = [[LLAHomeScriptViewController alloc] init];
    [self addChildViewController:scriptController];
    [scriptController didMoveToParentViewController:self];
    UIView *scriptView = scriptController.view;
    scriptView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentScrollView addSubview:scriptView];
    
    // 给内部子控制器添加约束
    
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
    
    [contentScrollView addConstraints: constrArr];
    
}

#pragma mark - LLAHomeTitleViewDelegate

// 点击了顶部标题view按钮跳到不同子控制器
- (void) titleView:(LLAHomeTitleView *)titleView didSelectedIndex:(NSInteger)index {
    
    [contentScrollView setContentOffset:CGPointMake(self.view.frame.size.width*index, contentScrollView.contentOffset.y) animated:YES];
}

#pragma mark - UIScrollViewDelegate

// 滑动scrollView时候调用
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat propotion = (scrollView.contentOffset.x) / scrollView.frame.size.width;
    
    [titleView scrollWithProportion:propotion];
    
    NSInteger selectedIndex = (NSInteger)((scrollView.contentOffset.x+scrollView.bounds.size.width/2) /scrollView.frame.size.width);
    
    [self handlePlayWithIndex:selectedIndex];
   
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger selectedIndex = (NSInteger)((scrollView.contentOffset.x+scrollView.bounds.size.width/2) /scrollView.frame.size.width);
    
    [self handlePlayWithIndex:selectedIndex];
}

#pragma mark - handle play stop

- (void) handlePlayWithIndex:(NSInteger) index {
    if (index == hallIndex) {
        [hallController startPlayVideo];
    }else {
        [hallController stopAllVideo];
    }
}

#pragma mark - LLAHomeHallViewControllerDelegate

-(BOOL) shouldPlayVideo {
    
    NSInteger selectedIndex = (NSInteger)((contentScrollView.contentOffset.x+contentScrollView.bounds.size.width/2) /contentScrollView.frame.size.width);
    
    return selectedIndex == hallIndex;
}

#pragma mark - Public Method

- (void) showHallViewController {
    [self titleView:titleView didSelectedIndex:hallIndex];
}

- (void) showScriptHallViewController {
    [self titleView:titleView didSelectedIndex:scriptHallIndex];
}


@end
