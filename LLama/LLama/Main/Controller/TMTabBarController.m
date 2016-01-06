//
//  TMTabBarController.m
//  LLama
//
//  Created by tommin on 15/12/7.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMTabBarController.h"
#import "TMHomeViewController.h"
#import "TMStartViewController.h"
#import "TMProfileViewController.h"
#import "TMNavigationController.h"
#import "TMTabBar.h"
#import "TMMessageController.h"
#import "TMZoomController.h"

@interface TMTabBarController ()

@end

@implementation TMTabBarController

#pragma mark - 初始化方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置item的文字属性
    [self setupItemTextAttrs];
    
    // 添加所有的子控制器
    [self setupChildVcs];
    
    // 处理tabBar
    [self setupTabBar];
}

/**
 *  处理tabBar
 */
- (void)setupTabBar
{
    [self setValue:[[TMTabBar alloc] init] forKeyPath:@"tabBar"];
}

/**
 *  设置item的文字属性
 */
- (void)setupItemTextAttrs
{
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    // 统一设置所有UITabBarItem的文字属性
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

/**
 *  添加所有的子控制器
 */
- (void)setupChildVcs
{
    
    // 主页
    [self setupOneChildVc:[[TMNavigationController alloc] initWithRootViewController:[[TMHomeViewController alloc] init]]  image:@"home" selectedImage:@"homeH"];

    // 消息
    [self setupOneChildVc:[[TMNavigationController alloc] initWithRootViewController:[[TMMessageController alloc] init]]  image:@"message" selectedImage:@"messageH"];
    
    // 发现
    [self setupOneChildVc:[[TMNavigationController alloc] initWithRootViewController:[[TMZoomController alloc] init]]
        image:@"zoom" selectedImage:@"zoomH"];
    
    // 我
    [self setupOneChildVc:[[TMNavigationController alloc] initWithRootViewController:[[TMProfileViewController alloc] init]]  image:@"profile" selectedImage:@"profileH"];
    
}

/**
 *  添加一个子控制器
 *  @param vc            控制器
 *  @param image         图标
 *  @param selectedImage 选中的图标
 */
- (void)setupOneChildVc:(UIViewController *)vc image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 图标
    vc.tabBarItem.image = [UIImage imageNamed:image];
    // 选中图标
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    [self addChildViewController:vc];
}


@end
