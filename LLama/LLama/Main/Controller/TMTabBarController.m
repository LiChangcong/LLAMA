//
//  TMTabBarController.m
//  LLama
//
//  Created by tommin on 15/12/7.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMTabBarController.h"

#import "LLABaseNavigationController.h"
#import "LLAHomeViewController.h"
#import "LLAUserProfileViewController.h"

#import "TMPublishView.h"


static NSString * const homeTabarImage_Normal = @"home";
static NSString * const homeTabarImage_Selected = @"homeH";

static NSString * const userProfileTabbarImage_Normal = @"message";
static NSString * const userProfileTabbarImage_Selected = @"messageH";

static NSString * const publishScriptImage_Normal = @"start";
static NSString * const publishScriptImage_Selected= @"startH";

@interface TMTabBarController ()
{
    UIButton *publishScriptButton;
}

@property(nonatomic,readwrite,strong) UINavigationController *homeNavigationController;

@property(nonatomic,readwrite,strong) UINavigationController *userProfileNavigationController;

@end

@implementation TMTabBarController

@synthesize homeNavigationController;
@synthesize userProfileNavigationController;

#pragma mark - 初始化方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAppearance];
    
    [self setupViewControllers];
    
    // 处理tabBar
    [self setupTabBar];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [publishScriptButton sizeToFit];
    
    publishScriptButton.center = CGPointMake(self.tabBar.bounds.size.width/2, self.tabBar.bounds.size.height/2);
}

/**
 *  处理tabBar
 */
- (void)setupTabBar
{
    //[self setValue:[[TMTabBar alloc] init] forKeyPath:@"tabBar"];
}

/**
 *  设置item的文字属性
 */
- (void)setupAppearance {
    self.tabBar.backgroundImage = [UIImage llaImageWithColor:[UIColor llaTabbarColor]];
    self.tabBar.contentMode = UIViewContentModeScaleAspectFill;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor themeColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
}

- (void) setupViewControllers {
    
    //home
    LLAHomeViewController *homeViewController = [[LLAHomeViewController alloc] init];

    homeNavigationController = [[LLABaseNavigationController alloc] initWithRootViewController:homeViewController];
    
    //empty controller
    UIViewController *empty = [UIViewController new];
    
    //user profile
    LLAUserProfileViewController *userProfile = [[LLAUserProfileViewController alloc] init];
    
    userProfileNavigationController = [[LLABaseNavigationController alloc] initWithRootViewController:userProfile];
    
    [self setViewControllers:@[homeNavigationController,empty,userProfileNavigationController]];
    
    NSArray *titlesArray = @[@"",@"",@""];
    NSArray *normalImages = @[homeTabarImage_Normal,@"",userProfileTabbarImage_Normal];
    NSArray *selectedImages = @[homeTabarImage_Selected,@"",userProfileTabbarImage_Selected];
    
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item setTitle:titlesArray[idx]];
        [item setImage:[[UIImage llaImageWithName:normalImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setSelectedImage:[[UIImage llaImageWithName:selectedImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }];
    
    [self.tabBar.items[1] setEnabled:NO];
    
    //center Button
    publishScriptButton = [[UIButton alloc] init];
    //publishScriptButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [publishScriptButton setImage:[UIImage llaImageWithName:publishScriptImage_Normal] forState:UIControlStateNormal];
    [publishScriptButton setImage:[UIImage llaImageWithName:publishScriptImage_Selected] forState:UIControlStateHighlighted];
    [publishScriptButton addTarget:self action:@selector(publishButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [publishScriptButton sizeToFit];
    
    [self.tabBar addSubview:publishScriptButton];
    
}

#pragma mark - Publish Script

- (void) publishButtonClicked:(UIButton *) sender {
    
    TMPublishView *publish = [TMPublishView publishView];
    
    [publish show];

}

#pragma mark - Rotating

- (BOOL) shouldAutorotate {
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.selectedViewController.preferredInterfaceOrientationForPresentation;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return self.selectedViewController.preferredStatusBarStyle;
}

@end
