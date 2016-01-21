//
//  LLAUserProfileViewController.m
//  LLama
//
//  Created by Live on 16/1/12.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLAUserProfileViewController.h"

//view
#import "LLATableView.h"

#import "LLALoadingView.h"
#import "LLAUserProfileNavigationBar.h"

//category
#import "UIScrollView+SVPullToRefresh.h"

//model
#import "LLAUser.h"

//util
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"

static const CGFloat navigationBarHeight = 64;

@interface LLAUserProfileViewController()<UITableViewDelegate,UITableViewDataSource>
{
    
    LLAUserProfileNavigationBar *customNaviBar;
    
    LLATableView *dataTableView;
    
    LLALoadingView *HUD;
}

@property(nonatomic , readwrite , strong) NSString *uIdString;

@property(nonatomic , readwrite , assign) UserProfileControllerType type;

@end

@implementation LLAUserProfileViewController

@synthesize uIdString;
@synthesize type;

#pragma mark - Life Cycle

- (instancetype) initWithUserIdString:(NSString *)userIdString {
    self = [super init];
    if (self) {
        uIdString = userIdString;
        
        if (uIdString) {
            if ([uIdString isEqualToString:[LLAUser me].userIdString]) {
                type = UserProfileControllerType_CurrentUser;
            }else {
                type = UserProfileControllerType_OtherUser;
            }
            
        }else {
            type = UserProfileControllerType_NotLogin;
        }
        
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavigationItems];
    [self initSubViews];
}

#pragma mark - Init

- (void) initNavigationItems {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout  = UIRectEdgeNone;
}

- (void) initSubViews {
    customNaviBar = [[LLAUserProfileNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, navigationBarHeight)];
    customNaviBar.translatesAutoresizingMaskIntoConstraints = NO;
    customNaviBar.clipsToBounds = YES;
    customNaviBar.layer.masksToBounds = YES;

    [customNaviBar makeBackgroundClear:YES];
    
    [self.view addSubview:customNaviBar];
    
    [customNaviBar layoutIfNeeded];
    [customNaviBar setNeedsLayout];
    //
    dataTableView = [[LLATableView alloc] init];
    dataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.showsVerticalScrollIndicator = NO;
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:dataTableView];
    
    __weak typeof(self) weakSelf = self;
    
    [dataTableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadData];
    }];
    
    //constraints
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[customNaviBar(naviHeight)]-(0)-[dataTableView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(navigationBarHeight),@"naviHeight", nil]
      views:NSDictionaryOfVariableBindings(dataTableView,customNaviBar)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[dataTableView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataTableView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[customNaviBar]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(customNaviBar)]];

    
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
    
    [self.view bringSubviewToFront:customNaviBar];

}

#pragma mark - Load Data

- (void) loadData {
    
    //first,load user data,then load video data
    
}

- (void) loadMoreData {
    
    //load more video data
    
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //
}



@end
