//
//  TMTabBar.m
//  LLama
//
//  Created by tommin on 15/12/7.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMTabBar.h"
#import "TMStartViewController.h"
#import "TMPublishView.h"

@interface TMTabBar()
@property (nonatomic, weak) UIButton *publishButton;

@end

@implementation TMTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
        
        // publish按钮
        UIButton *publishButton = [[UIButton alloc] init];
        [publishButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
        [publishButton setImage:[UIImage imageNamed:@"startH"] forState:UIControlStateHighlighted];
        [publishButton addTarget:self action:@selector(publishButtonClick) forControlEvents:UIControlEventTouchDown];
        [publishButton sizeToFit];
        [self addSubview:publishButton];
        self.publishButton = publishButton;
    }
    return self;
}

/**
 *  start按钮点击后调用
 */
- (void)publishButtonClick
{
    TMPublishView *publish = [TMPublishView publishView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    publish.frame = window.bounds;
    [window addSubview:publish];
}

/**
 *  布局子控件
 */
- (void)layoutSubviews
{
    // 先让父类布局子控件
    [super layoutSubviews];
    
    // tabBar的尺寸
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    
    /**** 选项卡按钮 ****/
    // 按钮的尺寸
    CGFloat buttonW = (w - self.publishButton.frame.size.width) / 2;
    CGFloat buttonH = h;
    CGFloat buttonY = 0;
    
    // 按钮的索引
    int index = 0;
    
    for (UIControl *tabBarButton in self.subviews) {
        
        NSString *className = NSStringFromClass(tabBarButton.class);
        if (![className isEqualToString:@"UITabBarButton"]) continue;
        
        // 按钮的位置
        CGFloat buttonX = index * buttonW;
        if (index >= 1) { // 右边2个按钮
            buttonX += self.publishButton.frame.size.width;
        }
        tabBarButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 增加索引
        index++;
        
    }
    
    /**** 发布按钮 ****/
    self.publishButton.center = CGPointMake(w * 0.5, h * 0.5);
    
}


@end
