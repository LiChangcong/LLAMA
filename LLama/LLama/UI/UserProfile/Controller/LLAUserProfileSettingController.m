//
//  LLAUserProfileSettingController.m
//  LLama
//
//  Created by Live on 16/1/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserProfileSettingController.h"

//view
#import "LLATableView.h"
#import "LLAUserProfileSettingCell.h"
#import "LLAUserProfileLogoutCell.h"

//model
#import "LLAUserProfileSettingItemInfo.h"
#import "llauser.h"

//util
#import "LLAViewUtil.h"
#import "LLAChangeRootControllerUtil.h"

//setting
#import "TMAccountSecurityController.h"

static const NSInteger accountSaftySectionIndex = 0;
static const NSInteger mainInfoSaftySectionIndex = 1;
static const NSInteger logoutSection = 2;

static const CGFloat mainInfoHeaderHeight = 10;
static const CGFloat logoutHeaderHeight = 28;

@interface LLAUserProfileSettingController()<UITableViewDataSource,UITableViewDelegate,LLAUserProfileLogoutCellDelegate>
{
    LLATableView *dataTableView;
    
    NSMutableArray <LLAUserProfileSettingItemInfo *> *accountInfoArray;
    
    NSMutableArray <LLAUserProfileSettingItemInfo *> *mainInfoArray;
    
    NSMutableArray  *loginOutArray;
    
    
}

@end

@implementation LLAUserProfileSettingController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    [self initNavigationItems];
    [self initVariables];
    [self initSubViews];

}

#pragma mark - Init

- (void) initNavigationItems {
    
    self.navigationItem.title = @"设置";
}

- (void) initVariables {
    
    //account
    accountInfoArray = [NSMutableArray array];
    
    [accountInfoArray addObject:[LLAUserProfileSettingItemInfo accountSaftyItem]];
    
    //
    mainInfoArray = [NSMutableArray array];
    
    [mainInfoArray addObject:[LLAUserProfileSettingItemInfo friendAuthItem]];
    [mainInfoArray addObject:[LLAUserProfileSettingItemInfo vipItem]];
    
    [mainInfoArray addObject:[LLAUserProfileSettingItemInfo userAgreementItem]];
    [mainInfoArray addObject:[LLAUserProfileSettingItemInfo userCommentItem]];
    [mainInfoArray addObject:[LLAUserProfileSettingItemInfo versionItem]];
    [mainInfoArray addObject:[LLAUserProfileSettingItemInfo cacheItem]];
    
    //
    loginOutArray = [NSMutableArray array];
    
    [loginOutArray addObject:[LLAUser me]];
}

- (void) initSubViews {
    dataTableView = [[LLATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    dataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.showsVerticalScrollIndicator = NO;
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dataTableView.backgroundColor = [UIColor colorWithHex:0xededed];
    [self.view addSubview:dataTableView];
    
    //constraints
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[dataTableView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataTableView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[dataTableView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataTableView)]];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == accountSaftySectionIndex) {
        return [accountInfoArray count];
    }else if (section == mainInfoSaftySectionIndex) {
        return [mainInfoArray count];
    }else if (section == logoutSection) {
        return [loginOutArray count];
    }else {
        return 0;
    }
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == accountSaftySectionIndex || indexPath.section == mainInfoSaftySectionIndex) {
        
        static NSString *cellIden = @"cellIden";
        
        LLAUserProfileSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
        
        if (!cell) {
            cell = [[LLAUserProfileSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
        }
        
        if (indexPath.section == accountSaftySectionIndex) {
            [cell updateCellWithItemInfo:[accountInfoArray objectAtIndex:indexPath.row] shouldHideSepLine:indexPath.row == accountInfoArray.count - 1];
        }else {
            [cell updateCellWithItemInfo:[mainInfoArray objectAtIndex:indexPath.row] shouldHideSepLine:indexPath.row == mainInfoArray.count - 1];
        }
        
        return cell;
        
    }else if (indexPath.section == logoutSection) {
        
        static NSString *logoutCellIden = @"logoutCellIden";
        
        LLAUserProfileLogoutCell *cell = [ tableView dequeueReusableCellWithIdentifier:logoutCellIden];
        if (!cell) {
            cell = [[LLAUserProfileLogoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:logoutCellIden];
            cell.delegate = self;
        }
        
        return cell;
    
    }else {
        return nil;
    }
    
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  {
    if (section == mainInfoSaftySectionIndex) {
        
        UIView *mainInfoHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, mainInfoHeaderHeight)];
        mainInfoHeader.backgroundColor = tableView.backgroundColor;
        return mainInfoHeader;
        
    }else if (section == logoutSection) {
        
        UIView *logoutHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, logoutHeaderHeight)];
        logoutHeader.backgroundColor = tableView.backgroundColor;
        
        return logoutHeader;
        
    }else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        TMAccountSecurityController *accountSecurity = [[TMAccountSecurityController alloc] init];
        [self.navigationController pushViewController:accountSecurity animated:YES];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == accountSaftySectionIndex) {
        return [LLAUserProfileSettingCell calculateHeightWihtItemInfo:accountInfoArray[indexPath.row]];
    }else if (indexPath.section == mainInfoSaftySectionIndex) {
        return [LLAUserProfileSettingCell calculateHeightWihtItemInfo:mainInfoArray[indexPath.row]];
    }else if (indexPath.section == logoutSection) {
        return [LLAUserProfileLogoutCell calculateHeight];
    }else {
        return 0;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == mainInfoSaftySectionIndex) {
        return mainInfoHeaderHeight;
    }else if (section == logoutSection) {
        return logoutHeaderHeight;
    }else {
        return 0.0001;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

#pragma mark - LogoutCellDelgate

- (void) logoutCurrentUser {
    //
    [LLAUser logout];
    //change root view controller
    
    [LLAChangeRootControllerUtil changeToLoginViewController];

}

@end
