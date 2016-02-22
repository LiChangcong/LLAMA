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
#import "LLAZoomViewController.h"
#import "LLAMessageViewController.h"

#import "TMPublishView.h"

#import "LLAUser.h"


static NSString * const homeTabarImage_Normal = @"home";
static NSString * const homeTabarImage_Selected = @"homeH";

static NSString * const userProfileTabbarImage_Normal = @"profile";
static NSString * const userProfileTabbarImage_Selected = @"profileH";

static NSString * const zoomTabbarImage_Normal = @"zoom";
static NSString * const zoomTabbarImage_Selected = @"zoomH";

static NSString * const messageTabbarImage_Normal = @"message";
static NSString * const messageTabbarImage_Selected = @"messageH";


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
@synthesize zoomNavigationController;
@synthesize messageNavigationController;

#pragma mark - 初始化方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAppearance];
    
    [self setupViewControllers];
    
    // 处理tabBar
    [self setupTabBar];
}

// view布局完子控件的时候设置发布按钮的位置
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
    
    //zoom
    LLAZoomViewController *zoomViewController = [[LLAZoomViewController alloc] init];
    
    zoomNavigationController = [[LLABaseNavigationController alloc] initWithRootViewController:zoomViewController];
    
    //empty controller
    UIViewController *empty = [UIViewController new];
    
    
    //message
    LLAMessageViewController *messageViewController = [[LLAMessageViewController alloc] init];
    
    messageNavigationController = [[LLABaseNavigationController alloc] initWithRootViewController:messageViewController];
    
    //user profile
    LLAUserProfileViewController *userProfile = [[LLAUserProfileViewController alloc] initWithUserIdString:[LLAUser me].userIdString];
    
    userProfileNavigationController = [[LLABaseNavigationController alloc] initWithRootViewController:userProfile];
    
    [self setViewControllers:@[homeNavigationController,zoomNavigationController,empty,messageNavigationController,userProfileNavigationController]];
    
    NSArray *titlesArray = @[@"",@"",@"",@"",@""];
    NSArray *normalImages = @[homeTabarImage_Normal,zoomTabbarImage_Normal,@"",messageTabbarImage_Normal,userProfileTabbarImage_Normal];
    NSArray *selectedImages = @[homeTabarImage_Selected,zoomTabbarImage_Selected,@"",messageTabbarImage_Selected,userProfileTabbarImage_Selected];
    
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item setTitle:titlesArray[idx]];
        [item setImage:[[UIImage llaImageWithName:normalImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setSelectedImage:[[UIImage llaImageWithName:selectedImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }];
    
    [self.tabBar.items[2] setEnabled:NO];
    
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
