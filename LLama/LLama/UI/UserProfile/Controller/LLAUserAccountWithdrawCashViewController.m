//
//  LLAUserAccountWithdrawCashViewController.m
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLAUserAccountWithdrawCashViewController.h"

//view
#import "LLALoadingView.h"
#import "LLATableView.h"
#import "LLAUserAccountWithdrawCashInfoCell.h"
#import "LLAUserAccountWithdrawCashAlipayInfoCell.h"
#import "LLAUserAccountWithdrawCashCellPhoneInfoCell.h"
#import "LLAUserWithdrawCashSuccessView.h"

//category

//model
#import "LLAUser.h"

//util
#import "LLAViewUtil.h"

//edit alipy
#import "LLAAlipayWithDrawalsViewController.h"

// cell phone number
#import "LLAChangBoundPhonesViewController.h"

#import "LLABoundPhonesViewController.h"

static const NSInteger cashInfoSectionIndex = 0;
static const NSInteger alipayInfoSectionIndex = 1;
static const NSInteger cellPhoneInfoSectionIndex = 2;

static const CGFloat cashButtonHeight = 50;
static const CGFloat cashButtonToBottom = 16;
static const CGFloat cashButtonToHorborder = 16;

@interface LLAUserAccountWithdrawCashViewController()<UITableViewDataSource,UITableViewDelegate>

{
    CGFloat withdrawCashAmount;
    
    LLATableView *dataTableView;
    
    UIButton *withdrawCashButton;
    
    LLALoadingView *HUD;
    
    LLAUser *myUserInfo;
}

@end

@implementation LLAUserAccountWithdrawCashViewController

#pragma mark - Life Cycle

- (instancetype) initWithCashAmount:(CGFloat)cashAmount {
    self = [super init];
    if (self) {
        withdrawCashAmount = cashAmount;
    }
    return self;
}

- (void) viewDidLoad {

    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:0xeaeaea];
    
    [self initVariables];
    [self initNavigationItems];
    [self initSubViews];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    myUserInfo = [LLAUser me];
    [dataTableView reloadData];
}

#pragma mark - Init

- (void) initVariables {
    myUserInfo = [LLAUser me];
}

- (void) initNavigationItems {
    self.navigationItem.title = @"提现信息";
}

- (void) initSubViews {

    
    dataTableView = [[LLATableView alloc] init];
    dataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.showsVerticalScrollIndicator = NO;
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dataTableView.backgroundColor = [UIColor colorWithHex:0xeaeaea];
    [self.view addSubview:dataTableView];
    
    //
    withdrawCashButton = [[UIButton alloc] init];
    withdrawCashButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    withdrawCashButton.titleLabel.font = [UIFont llaFontOfSize:18];
    withdrawCashButton.layer.cornerRadius = 6;
    withdrawCashButton.clipsToBounds = YES;
    
    [withdrawCashButton setTitle:@"确认提现" forState:UIControlStateNormal];
    [withdrawCashButton setTitleColor:[UIColor colorWithHex:0x11111e] forState:UIControlStateNormal];
    [withdrawCashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [withdrawCashButton setBackgroundColor:[UIColor themeColor] forState:UIControlStateNormal];
    [withdrawCashButton setBackgroundColor:[UIColor colorWithHex:0xcbcccd] forState:UIControlStateHighlighted];
    
    [withdrawCashButton addTarget:self action:@selector(withdrawCashToAccount:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:withdrawCashButton];
    
    //constraints
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[dataTableView]-(2)-[withdrawCashButton(height)]-(toBottom)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(cashButtonHeight),@"height",
               @(cashButtonToBottom),@"toBottom", nil]
      views:NSDictionaryOfVariableBindings(dataTableView,withdrawCashButton)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[dataTableView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataTableView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toBorder)-[withdrawCashButton]-(toBorder)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(cashButtonToHorborder),@"toBorder", nil]
      views:NSDictionaryOfVariableBindings(withdrawCashButton)]];
    
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
    
    //
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == cashInfoSectionIndex) {
        
        static NSString *cashIden = @"cashIden";
        
        LLAUserAccountWithdrawCashInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cashIden];
        if (!cell) {
            cell = [[LLAUserAccountWithdrawCashInfoCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:cashIden];
        }
        
        [cell updateCellWithUserInfo:withdrawCashAmount tableWith:tableView.frame.size.width];
        
        return cell;
        
    }else if (indexPath.section == alipayInfoSectionIndex) {
        
        static NSString *alipayInfoIden = @"alipayInfoIden";
        
        LLAUserAccountWithdrawCashAlipayInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:alipayInfoIden];
        if (!cell) {
            cell = [[LLAUserAccountWithdrawCashAlipayInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:alipayInfoIden];
        }
        
        [cell updateCellWithUserInfo:myUserInfo];
        
        return cell;
    
    }else if (indexPath.section == cellPhoneInfoSectionIndex) {

        static NSString *cellPhoneIden = @"cellPhoneIden";
        
        LLAUserAccountWithdrawCashCellPhoneInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellPhoneIden];
        if (!cell) {
            cell = [[LLAUserAccountWithdrawCashCellPhoneInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellPhoneIden];
        }
        
        [cell updateCellWithUserInfo:myUserInfo];
        
        return cell;
    
    }else {
        return nil;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == cellPhoneInfoSectionIndex) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 5)];
        view.backgroundColor  = tableView.backgroundColor;
        return view ;
    }else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (indexPath.section == cashInfoSectionIndex) {
        return [LLAUserAccountWithdrawCashInfoCell calculateHeightWithUserInfo:withdrawCashAmount tableWidth:tableView.frame.size.width];
    }else if (indexPath.section == alipayInfoSectionIndex) {
        return [LLAUserAccountWithdrawCashAlipayInfoCell calculateHeightWithUserInfo:myUserInfo tableWidth:tableView.frame.size.width];
    }else if (indexPath.section == cellPhoneInfoSectionIndex) {
        return [LLAUserAccountWithdrawCashCellPhoneInfoCell calculateHeightWithUserInfo:myUserInfo tableWidth:tableView.frame.size.width];
    }else {
        return 0;
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == cellPhoneInfoSectionIndex) {
        return 10;
    }else {
        return 0.0001;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == alipayInfoSectionIndex) {
        //go to edit alipy
        
        LLAAlipayWithDrawalsViewController *alipay = [[LLAAlipayWithDrawalsViewController alloc] init];
        [self.navigationController pushViewController:alipay animated:YES];
        
    }else if (indexPath.section == cellPhoneInfoSectionIndex) {
        //go to edit cell phone number

        if ([LLAUser me].mobilePhone) {
            // 绑定手机号
            LLAChangBoundPhonesViewController *changeBoundPhones = [[LLAChangBoundPhonesViewController alloc] init];
            [self.navigationController pushViewController:changeBoundPhones animated:YES];

        }else {
            // 更换绑定的手机号
            LLABoundPhonesViewController *boundPhones = [[LLABoundPhonesViewController alloc] init];
            [self.navigationController pushViewController:boundPhones animated:YES];
        }
        
    }
    
}

#pragma mark - withdraw cash

- (void) withdrawCashToAccount:(UIButton *) sender {
    //draw cache
    LLAUserWithdrawCashSuccessView *success = [[LLAUserWithdrawCashSuccessView alloc] init];
    [success show];
}

@end
