//
//  LLAAccountSecurityController.m
//  LLama
//
//  Created by tommin on 16/1/26.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAAccountSecurityController.h"
#import "LLAAccountSecuritySectionOneCell.h"
#import "LLAAccountSecuritySectionTwoCell.h"
#import "LLAAccountSecuritySectionOne.h"
#import "LLAAccountSecuritySectionTwo.h"

#import "LLABoundPhonesViewController.h"
#import "LLAChangBoundPhonesViewController.h"
#import "LLAModifyPasswordViewController.h"

#import "LLAUser.h"
#import "LLAHttpUtil.h"

#import "LLAThirdSDKDelegate.h"
#import "LLAViewUtil.h"
#import "LLALoadingView.h"


static NSString *const accountSecuritySectionOneCell = @"LLAAccountSecuritySectionOneCell";
static NSString *const accountSecuritySectionTwoCell = @"LLAAccountSecuritySectionTwoCell";


@interface LLAAccountSecurityController ()<UITableViewDataSource,UITableViewDelegate, LLAAccountSecuritySectionTwoCellDelegate>
{
    UITableView *dataTableView;
    
    UILabel *headerLabel;
    
    LLAUser *myUserInfo;
    
    LLALoadingView *HUD;
    
}

//@property (nonatomic, strong) NSMutableArray *accountSecuritySectionOne;
//@property (nonatomic, strong) NSMutableArray *accountSecuritySectionTwo;


@end

@implementation LLAAccountSecurityController

// 懒加载
//- (NSMutableArray *)accountSecuritySectionOne
//{
//    if (_accountSecuritySectionOne == nil) {
//        
//        _accountSecuritySectionOne = [NSMutableArray array];
//        
//        NSArray *dictArray = @[
//                               @{@"title":@"绑定手机号"},
//                               @{@"title":@"更改密码"}
//                               ];
//        
//        for (NSDictionary *dict in dictArray) {
//            
//            LLAAccountSecuritySectionOne *sectionOne = [LLAAccountSecuritySectionOne accountSecuritySectionOneWithDict:dict];
//            
//            [_accountSecuritySectionOne addObject:sectionOne];
//        }
//
//    }
//    return _accountSecuritySectionOne;
//}

//- (NSMutableArray *)accountSecuritySectionTwo
//{
//    if (_accountSecuritySectionTwo == nil) {
//        
//        _accountSecuritySectionTwo = [NSMutableArray array];
//        
//        NSArray *dictArray = @[
//                               @{@"icon":@"wechat",@"on":@"YES"},
//                               @{@"icon":@"weixin",@"on":@"NO"},
//                               @{@"icon":@"qq",@"on":@"NO"}
//                               ];
//
//        for (NSDictionary *dict in dictArray) {
//            
//            LLAAccountSecuritySectionTwo *sectionTwo = [LLAAccountSecuritySectionTwo accountSecuritySectionTwoWithDict:dict];
//            
//            [_accountSecuritySectionTwo addObject:sectionTwo];
//        }
//    }
//    return _accountSecuritySectionTwo;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 背景色
    self.view.backgroundColor = [UIColor colorWithHex:0xebebeb];
    
    // 设置导航栏
    [self initNavigationItems];
    // 设置变量
    [self initVariables];
    // 设置子控件
    [self initSubViews];
    
    myUserInfo = [LLAUser me];
    [dataTableView reloadData];

}

// 设置导航栏
- (void)initNavigationItems
{
    self.navigationItem.title = @"设置";
}

// 设置变量
- (void)initVariables
{

}

// 设置子控件
- (void)initSubViews
{
    // tableView
    dataTableView  = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    dataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.showsVerticalScrollIndicator = NO;
//    dataTableView.backgroundColor = [UIColor redColor];
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dataTableView.backgroundColor = [UIColor colorWithHex:0xededed];
    [self.view addSubview:dataTableView];
    
    // 注册cell
    [dataTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LLAAccountSecuritySectionOneCell class]) bundle:nil] forCellReuseIdentifier:accountSecuritySectionOneCell];
    [dataTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LLAAccountSecuritySectionTwoCell class]) bundle:nil] forCellReuseIdentifier:accountSecuritySectionTwoCell];

    // header title
    headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.font = [UIFont systemFontOfSize:14];
    headerLabel.textColor = [UIColor colorWithHex:0xababab];
    headerLabel.text = @"绑定社交账号";
    
    // constraints
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


#pragma mark - tableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        LLAAccountSecuritySectionOneCell *oneCell = [tableView dequeueReusableCellWithIdentifier:accountSecuritySectionOneCell];
        oneCell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (indexPath.row == 0) {
            
//            [oneCell updateCellWithUserInfo:myUserInfo];
            
            if (myUserInfo.mobilePhone) {
                oneCell.titleLabel.text = [NSString stringWithFormat:@"已绑定:%@",myUserInfo.mobilePhone];
            }else {
                oneCell.titleLabel.text = @"绑定手机号";
            }
        }else if (indexPath.row == 1) {
            oneCell.titleLabel.text = @"更改密码";
        }
        return oneCell;
    }else if (indexPath.section == 1){
        
        LLAAccountSecuritySectionTwoCell *twoCell = [tableView dequeueReusableCellWithIdentifier:accountSecuritySectionTwoCell];
        twoCell.indexPath = indexPath;
        twoCell.delegate = self;
        twoCell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        if (indexPath.row == 0) { // 微信
            
            twoCell.iconView.image = [UIImage imageNamed:@"wechat"];
            
            // 判断绑定微信情况
            if (!myUserInfo.weChatOpenId) {
                
//                [self boundWeChat];
                [twoCell.swit setOn:NO];
                twoCell.swit.enabled = YES;
            }else {
                
                [twoCell.swit setOn:YES];
                twoCell.swit.enabled = NO;
            }
        }else if (indexPath.row == 1) { // 微博
            
            twoCell.iconView.image = [UIImage imageNamed:@"weixin"];
            
            // 判断绑定微博情况
            if (!myUserInfo.sinaWeiBoUid) {
                
//                [self boundSinaWeiBo];
                [twoCell.swit setOn:NO];
                twoCell.swit.enabled = YES;
            }else{
                
                [twoCell.swit setOn:YES];
                twoCell.swit.enabled = NO;
            }
            
        }else if (indexPath.row == 2) { // qq
            
            twoCell.iconView.image = [UIImage imageNamed:@"qq"];
            
            // 判断绑定qq情况
            if (!myUserInfo.qqOpenId) {
                
//                [self boundQQ];
                [twoCell.swit setOn:NO];
                twoCell.swit.enabled = YES;
            }else {
                
                [twoCell.swit setOn:YES];
                twoCell.swit.enabled = NO;
            }
        }
        

        return twoCell;
        
    }else {
        return nil;
    }
    
}

#pragma mark - tableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 58;
    }else {
        return 70;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }else {
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 37;
    }else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return nil;
    }else {
        
        return headerLabel;
    }
}

// 点击cell后
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (myUserInfo.mobilePhone) {
                
                LLAChangBoundPhonesViewController *changeBoundPhones = [[LLAChangBoundPhonesViewController alloc] init];
                [self.navigationController pushViewController:changeBoundPhones animated:YES];
            }else {
                LLABoundPhonesViewController *boundPhones = [[LLABoundPhonesViewController alloc] init];
                [self.navigationController pushViewController:boundPhones animated:YES];
            }
        }else if (indexPath.row == 1) {
            
//            NSLog(@"%@",)
            if (myUserInfo.mobilePhone) {
                
                // 更改密码
                LLAModifyPasswordViewController *modifyPwd = [[LLAModifyPasswordViewController alloc] init];
                [self.navigationController pushViewController:modifyPwd animated:YES];
            }else {
                
                [LLAViewUtil showAlter:self.view withText:@"三方登陆无法修改密码"];

            }
           
        }
    }
}

#pragma mark - 社交软件绑定


// 绑定微信
- (void)boundWeChat:(LLAAccountSecuritySectionTwoCell *)accountSecuritySectionTwoCell
{
    [[LLAThirdSDKDelegate shareInstance] thirdLoginWithType:UserLoginType_WeChat loginCallBack:^(NSString *openId, NSString *accessToken, LLAThirdLoginState state, NSError *error) {
        
        if (state == LLAThirdLoginState_Success) {
            
            [self.view endEditing:YES];
            
            [HUD show:YES];
            
            //register
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            [params setValue:@([openId longLongValue]) forKey:@"openid"];
            [params setValue:accessToken forKey:@"access_token"];
            
            __weak  typeof(self) blockSelf = self;
            
            [LLAHttpUtil httpPostWithUrl:@"/user/bindWeixin" param:params progress:NULL responseBlock:^(id responseObject) {
                
                //[HUD hide:YES];
                
                NSString *openid = [responseObject valueForKey:@"openid"];
                
                LLAUser *newUser = [LLAUser me];
                newUser.weChatOpenId = openid;
                [LLAUser updateUserInfo:newUser];
                
                // 设置开关为打开并使开关不能点击
                [accountSecuritySectionTwoCell.swit setOn:YES];
                accountSecuritySectionTwoCell.swit.enabled = NO;
                
            } exception:^(NSInteger code, NSString *errorMessage) {
                
                [HUD hide:YES];
                [LLAViewUtil showAlter:blockSelf.view withText:errorMessage];
                
                // 关闭开关状态并让开关可点
                [accountSecuritySectionTwoCell.swit setOn:NO];
                accountSecuritySectionTwoCell.swit.enabled = YES;
                
            } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
                
                [HUD hide:YES];
                [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
                
                // 关闭开关状态并让开关可点
                [accountSecuritySectionTwoCell.swit setOn:NO];
                accountSecuritySectionTwoCell.swit.enabled = YES;
            }];
            
            
        }else {
            [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
            
            // 关闭开关状态并让开关可点
            [accountSecuritySectionTwoCell.swit setOn:NO];
            accountSecuritySectionTwoCell.swit.enabled = YES;
        }
        
    }];

}

// 绑定新浪微博
- (void)boundSinaWeiBo:(LLAAccountSecuritySectionTwoCell *)accountSecuritySectionTwoCell
{
    [[LLAThirdSDKDelegate shareInstance] thirdLoginWithType:UserLoginType_SinaWeiBo loginCallBack:^(NSString *openId, NSString *accessToken, LLAThirdLoginState state, NSError *error) {
        
        if (state == LLAThirdLoginState_Success) {
            
            [self.view endEditing:YES];
            
            [HUD show:YES];
            
            //register
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            [params setValue:@([openId longLongValue]) forKey:@"uid"];
            [params setValue:accessToken forKey:@"access_token"];
            
            __weak  typeof(self) blockSelf = self;
            
            [LLAHttpUtil httpPostWithUrl:@"/user/bindWeibo" param:params progress:NULL responseBlock:^(id responseObject) {
                
                //[HUD hide:YES];
                
                NSString *uid = [responseObject valueForKey:@"uid"];
                
                LLAUser *newUser = [LLAUser me];
                newUser.sinaWeiBoUid = [uid integerValue];
                [LLAUser updateUserInfo:newUser];
                
                // 设置开关为打开并使开关不能点击
                [accountSecuritySectionTwoCell.swit setOn:YES];
                accountSecuritySectionTwoCell.swit.enabled = NO;

                
            } exception:^(NSInteger code, NSString *errorMessage) {
                
                [HUD hide:YES];
                [LLAViewUtil showAlter:blockSelf.view withText:errorMessage];
                
                // 关闭开关状态并让开关可点
                [accountSecuritySectionTwoCell.swit setOn:NO];
                accountSecuritySectionTwoCell.swit.enabled = YES;


                
            } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
                
                [HUD hide:YES];
                [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
                
                // 关闭开关状态并让开关可点
                [accountSecuritySectionTwoCell.swit setOn:NO];
                accountSecuritySectionTwoCell.swit.enabled = YES;


            }];

            
        }else {
            [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
            
            // 关闭开关状态并让开关可点
            [accountSecuritySectionTwoCell.swit setOn:NO];
            accountSecuritySectionTwoCell.swit.enabled = YES;


        }
        
    }];

}

// 绑定QQ
- (void)boundQQ:(LLAAccountSecuritySectionTwoCell *)accountSecuritySectionTwoCell
{
    
    [[LLAThirdSDKDelegate shareInstance] thirdLoginWithType:UserLoginType_QQ loginCallBack:^(NSString *openId, NSString *accessToken, LLAThirdLoginState state, NSError *error) {
        
        if (state == LLAThirdLoginState_Success) {
            
            [self.view endEditing:YES];
            
            [HUD show:YES];
            
            //register
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            [params setValue:openId forKey:@"openid"];
            [params setValue:accessToken forKey:@"access_token"];
            
            __weak  typeof(self) blockSelf = self;
            
            [LLAHttpUtil httpPostWithUrl:@"/user/bindQQ" param:params progress:NULL responseBlock:^(id responseObject) {
                
                //[HUD hide:YES];
                
                NSString *openid = [responseObject valueForKey:@"openid"];
                
                LLAUser *newUser = [LLAUser me];
                newUser.qqOpenId = openid;
                [LLAUser updateUserInfo:newUser];
                
                // 设置开关为打开并使开关不能点击
                [accountSecuritySectionTwoCell.swit setOn:YES];
                accountSecuritySectionTwoCell.swit.enabled = NO;
            
                
            } exception:^(NSInteger code, NSString *errorMessage) {
                
                [HUD hide:YES];
                [LLAViewUtil showAlter:blockSelf.view withText:errorMessage];
                
                // 关闭开关状态并让开关可点
                [accountSecuritySectionTwoCell.swit setOn:NO];
                accountSecuritySectionTwoCell.swit.enabled = YES;
                
            } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
                
                [HUD hide:YES];
                [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
                
                // 关闭开关状态并让开关可点
                [accountSecuritySectionTwoCell.swit setOn:NO];
                accountSecuritySectionTwoCell.swit.enabled = YES;
            }];
            
            
        }else {
            [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
            
            // 关闭开关状态并让开关可点
            [accountSecuritySectionTwoCell.swit setOn:NO];
            accountSecuritySectionTwoCell.swit.enabled = YES;
        }
        
    }];

}


// LLAAccountSecuritySectionTwoCell代理方法
- (void)switchButtonOn:(LLAAccountSecuritySectionTwoCell *)accountSecuritySectionTwoCell indexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {// 绑定微信
        
        [self boundWeChat:accountSecuritySectionTwoCell];
        
        
    }else if (indexPath.row == 1){// 绑定微博
        
        [self boundSinaWeiBo:accountSecuritySectionTwoCell];
        
    }else { // 绑定QQ
        
        [self boundQQ:accountSecuritySectionTwoCell];
        
    }
}

@end
