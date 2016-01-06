//
//  TMLikeViewController.m
//  LLama
//
//  Created by tommin on 15/12/19.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMLikeViewController.h"
#import "TMLikeMeViewController.h"
#import "TMILikeViewController.h"
#include "TMTitleButton.h"

@interface TMLikeViewController ()<UIScrollViewDelegate>

/** 存放所有的标题按钮 */
@property (nonatomic, strong) NSMutableArray *titleButtons;
/** 标题指示器 */
//@property (nonatomic, weak) UIView *titleIndicatorView;
/** 当前被选中的标题按钮 */
@property (nonatomic, weak) TMTitleButton *selectedTitleButton;
/** 存放所有子控制器的scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;


@end

@implementation TMLikeViewController

#pragma mark - 懒加载
# warning  不懒加载会出现滚动后会反弹，而且导航栏的按钮也不会选中而且也会反弹
- (NSMutableArray *)titleButtons
{
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    [self setNav];
    
    // 添加子控制器
    [self setupChildVcs];
    
    // 添加scrollView
    [self setupScrollView];
    
    // 添加标题栏
    [self setupTitlesView];
    
    // 根据scrollView的偏移量的添加子控制器的view
    [self addChildVcView];

}

// 设置导航栏
- (void)setNav
{
    
    // 设置导航栏背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"] forBarMetrics:UIBarMetricsDefault];

    // 状态栏设置为白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
}

/**
 *  添加子控制器
 */
- (void)setupChildVcs
{
    TMLikeMeViewController *likeMe = [[TMLikeMeViewController alloc] init];
    likeMe.title = @"谁喜欢我";
    [self addChildViewController:likeMe];
    
    TMILikeViewController *iLike = [[TMILikeViewController alloc] init];
    iLike.title = @"我喜欢谁";
    [self addChildViewController:iLike];
    
}

/**
 *  添加scrollView
 */
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 禁止掉[自动设置scrollView的内边距]
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 设置内容大小
    scrollView.contentSize = CGSizeMake((self.childViewControllers.count * scrollView.width), 0);
    
}

/**
 *  添加标题栏
 */
- (void)setupTitlesView
{
    UIView *titlesView = [[UIView alloc] init];
    titlesView.size = CGSizeMake(self.view.width / 2, 40);
    self.navigationItem.titleView = titlesView;
    
    // 添加标题
    NSUInteger count = self.childViewControllers.count;
    CGFloat titleButtonW = titlesView.width / count;
    CGFloat titleButtonH = titlesView.height;
    for (int i = 0; i < count; i++) {
        // 创建
        TMTitleButton *titleButton = [[TMTitleButton alloc] init];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:titleButton];
        [self.titleButtons addObject:titleButton];
        
        // frame
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        
        // 设置
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; // selected = NO;
        [titleButton setTitleColor:TMColor(255, 207, 0) forState:UIControlStateSelected]; // selected = YES;
        titleButton.titleLabel.font = [UIFont systemFontOfSize:17];
        
        // 数据
        [titleButton setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
    }
    
    // 设置指示器的背景色为按钮的选中文字颜色
    TMTitleButton *firstTitleButton = titlesView.subviews.firstObject;

    // 让被点击的标题按钮变成选中状态
    firstTitleButton.selected = YES;
    self.selectedTitleButton = firstTitleButton;
    
}



- (void)titleButtonClick:(TMTitleButton *)titleButton
{
    // 重复点击同一个按钮
    if (self.selectedTitleButton == titleButton) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TMTitleButtonDidRepeatClickNotification" object:nil];
    }
    
    // 处理点击事件
    [self dealingTitleButtonClick:titleButton];
}

- (void)dealingTitleButtonClick:(TMTitleButton *)titleButton
{
    // 让当前被选中的标题按钮恢复以前的状态(取消选中)
    self.selectedTitleButton.selected = NO;
    
    // 让被点击的标题按钮变成选中状态
    titleButton.selected = YES;
    
    // 被点击的标题按钮 -> 当前被选中的标题按钮
    self.selectedTitleButton = titleButton;
    
//    // 让指示器移动
//    [UIView animateWithDuration:0.25 animations:^{
//        self.titleIndicatorView.width = titleButton.titleLabel.width;
//        self.titleIndicatorView.centerX = titleButton.centerX;
//    }];
    
    // 滚动scrollView
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = titleButton.tag * self.scrollView.width;
    [self.scrollView setContentOffset:offset animated:YES];
    
}

/**
 *  根据scrollView的偏移量的添加子控制器的view
 */
- (void)addChildVcView
{
    UIScrollView *scrollView = self.scrollView;
    
    // 计算按钮索引
    int index = scrollView.contentOffset.x/ scrollView.width;
    
    // 添加对应的子控制器view
    UIViewController *willShowVc = self.childViewControllers[index];
    if (willShowVc.isViewLoaded) return;
    
    [scrollView addSubview:willShowVc.view];
    
    // 设置子控制器view的frame
    willShowVc.view.frame = scrollView.bounds;
    
    
}



#pragma mark - <UIScrollViewDelegate>
/**
 * 如果通过setContentOffset:animated:让scrollView[进行了滚动动画], 那么最后会在停止滚动时调用这个方法
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 根据scrollView的偏移量的添加子控制器的view
    [self addChildVcView];
}


/**
 *  scrollView停止滚动的时候会调用1次(人为拖拽导致的停止滚动才会触发这个方法)
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 计算按钮索引
    int index = scrollView.contentOffset.x / scrollView.width;
    TMTitleButton *titleButton = self.titleButtons[index];
    
    // 点击按钮
    [self dealingTitleButtonClick:titleButton];
    
    // 根据scrollView的偏移量的添加子控制器的view
    [self addChildVcView];
}



@end
