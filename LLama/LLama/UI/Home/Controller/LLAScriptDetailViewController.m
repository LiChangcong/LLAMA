//
//  LLAScriptDetailViewController.m
//  LLama
//
//  Created by Live on 16/1/17.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLAScriptDetailViewController.h"
#import "LLAUserProfileViewController.h"
#import "LLAPayUserViewController.h"

//view
#import "LLACollectionView.h"
#import "LLAScriptDetailMainInfoCell.h"
#import "LLAChooseActorCell.h"
#import "LLALoadingView.h"
#import "LLAScriptChooseActorHeader.h"

//category
#import "SVPullToRefresh.h"

//model
#import "LLAScriptHallItemInfo.h"
#import "LLAPayUserPayInfo.h"

//util
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"

//
static NSString *const scriptInfoCellIden = @"scriptInfoCellIden";
static NSString *const chooseActorCellIden = @"chooseActorCellIden";
static NSString *const chooseActorHeaderIden = @"chooseActtorHeaderIden";

//
static const CGFloat chooseActorCellsHorSpace = 6;
static const CGFloat chooseActorCellsVerSpace = 6;

//section index

static const NSInteger mainInfoSectionIndex = 0;
static const NSInteger chooseActorInfoSectionIndex = 1;

@interface LLAScriptDetailViewController()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LLAScriptDetailMainInfoCellDelegate,LLAChooseActorCellDelegate>

{
    LLACollectionView *dataCollectionView;
    
    LLALoadingView *HUD;
    
    LLAScriptHallItemInfo *scriptInfo;
    
    NSString *scriptIDString;
}

@end

@implementation LLAScriptDetailViewController

#pragma mark - Life Cycle

- (instancetype) initWithScriptIdString:(NSString *)idString {
    self = [super init];
    if (self) {
        scriptIDString = [idString copy];
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    

    // 设置导航栏

    [self initNavigationItems];
    // 设置子控件
    [self initSubView];
    // 加载数据
    [self loadData];
    // 显示加载菊花
    [HUD show:YES];
}

#pragma mark - Init

// 设置导航栏
- (void) initNavigationItems {
    self.navigationItem.title = @"详情";
}

// 设置子控件
- (void) initSubView {
    // collectionView布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = chooseActorCellsHorSpace;
    flowLayout.minimumLineSpacing = chooseActorCellsVerSpace;

    // collectionView
    dataCollectionView = [[LLACollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    dataCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    dataCollectionView.delegate = self;
    dataCollectionView.dataSource = self;
    dataCollectionView.bounces = YES;
    dataCollectionView.alwaysBounceVertical = YES;
    dataCollectionView.backgroundColor = [UIColor colorWithHex:0xeaeaea];
    [self.view addSubview:dataCollectionView];
    
    // 注册cell
    [dataCollectionView registerClass:[LLAScriptDetailMainInfoCell class] forCellWithReuseIdentifier:scriptInfoCellIden];
    [dataCollectionView registerClass:[LLAChooseActorCell class] forCellWithReuseIdentifier:chooseActorCellIden];
    [dataCollectionView registerClass:[LLAScriptChooseActorHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:chooseActorHeaderIden];

    //
    
    __weak typeof(self) weakSelf = self;
    
    [dataCollectionView addPullToRefreshWithActionHandler:^{
        [weakSelf loadData];
    }];
    
    //constraints
    

    // 约束

    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[dataCollectionView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataCollectionView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[dataCollectionView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataCollectionView)]];

    // 菊花控件
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
    
}


#pragma mark - Load Data
// 加载数据
- (void) loadData {
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:scriptIDString forKey:@"playId"];
    
    // 请求
    [LLAHttpUtil httpPostWithUrl:@"/play/getPlayDetails" param:params responseBlock:^(id responseObject) {
        
        [HUD hide:YES];
        
        [dataCollectionView.pullToRefreshView stopAnimating];
        
        LLAScriptHallItemInfo *info = [LLAScriptHallItemInfo parseJsonWithDic:responseObject];
        if (info) {
            scriptInfo = info;
            [dataCollectionView reloadData];
        }
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:YES];
        [dataCollectionView.pullToRefreshView stopAnimating];
        
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [HUD hide:YES];
        [dataCollectionView.pullToRefreshView stopAnimating];
        
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        
    }];
    
}

// 加载更多数据
- (void) loadMoreData {
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 第一组显示剧本详情，第二组显示挑选演员
    if (section == mainInfoSectionIndex) {
        // 获取数据有值时才返回1
        if (scriptInfo){
            return 1;
        }else {
            return 0;
        }
    }else if (section == chooseActorInfoSectionIndex) {
        // 返回报名演员个数
        return scriptInfo.partakeUsersArray.count;
    }else {
        return 0;
    }
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 第一组显示基本详情，第二组显示报名演员
    if (indexPath.section == mainInfoSectionIndex) {
        
        LLAScriptDetailMainInfoCell *mainCell = [dataCollectionView dequeueReusableCellWithReuseIdentifier:scriptInfoCellIden forIndexPath:indexPath];
        mainCell.delegate = self;
        
        // 设置数据
        [mainCell updateCellWithInfo:scriptInfo maxWidth:collectionView.frame.size.width];
        return mainCell;
        
    }else {
        LLAChooseActorCell *actorCell = [dataCollectionView dequeueReusableCellWithReuseIdentifier:chooseActorCellIden forIndexPath:indexPath];
        actorCell.delegate = self;
        
        // 设置数据
        [actorCell updateCellWithUserInfo:scriptInfo.partakeUsersArray[indexPath.row]];
        return actorCell;
    }
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //header footer
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 报名演员的header
        LLAScriptChooseActorHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:chooseActorHeaderIden forIndexPath:indexPath];
        return header;
        
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return nil;
    }else {
        return nil;
    }
}

#pragma mark - UICollectionViewDelegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 选演员
    if (indexPath.section == chooseActorInfoSectionIndex) {
        //select,or,deselect
        
        if (scriptInfo.currentRole == LLAUserRoleInScript_Director && scriptInfo.status == LLAScriptStatus_Normal) {
            
            LLAUser *oldSelectedUser = [self selectedUserInfoScriptInfo];
            
            LLAUser *newSelectedUser = scriptInfo.partakeUsersArray[indexPath.row];
            
            if (oldSelectedUser == newSelectedUser) {
                oldSelectedUser.hasBeenSelected = NO;
                scriptInfo.hasTempChoose = NO;
            }else {
                oldSelectedUser.hasBeenSelected = NO;
                newSelectedUser.hasBeenSelected = YES;
                scriptInfo.hasTempChoose = YES;
            }
            
            [dataCollectionView reloadData];

        }
    }
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 通过判断来确定剧本详情cell和挑选演员cell的尺寸
    if (mainInfoSectionIndex == indexPath.section) {
        
        return CGSizeMake(collectionView.frame.size.width, [LLAScriptDetailMainInfoCell calculateHeightWithInfo:scriptInfo maxWidth:collectionView.frame.size.width]);
        
    }else {
    
        CGFloat itemWidth = (collectionView.frame.size.width - 3*chooseActorCellsHorSpace)/2;
    
        CGFloat itemHeight = [LLAChooseActorCell calculateHeightWitthUserInfo:scriptInfo.partakeUsersArray[indexPath.row] maxWidth:itemWidth];
        return CGSizeMake(itemWidth, itemHeight);
    }
    
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (section == mainInfoSectionIndex) { // 剧本详情cell
        // 组间隙0
        return UIEdgeInsetsZero;
    }else { // 挑选演员cell
        return UIEdgeInsetsMake(0, chooseActorCellsHorSpace,6, chooseActorCellsHorSpace);
    }
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == mainInfoSectionIndex) {
        return CGSizeZero;
    }else {
        if (scriptInfo.partakeUsersArray.count > 0) {
            return CGSizeMake(collectionView.frame.size.width, [LLAScriptChooseActorHeader calculateHeight]);
        }else {
            return CGSizeZero;
        }
    }
}

#pragma mark - LLAScriptDetailMainInfoCellDelegate
// 选中导演头像
- (void) directorHeadViewClicked:(LLAUserHeadView *) headView userInfo:(LLAUser *) userInfo scriptInfo:(LLAScriptHallItemInfo *)scriptInfo {
    //go to user profile
    
    LLAUserProfileViewController *userProfile = [[LLAUserProfileViewController alloc] initWithUserIdString:userInfo.userIdString];
    
    [self.navigationController pushViewController:userProfile animated:YES];
    
}

// 点击更多信息后收起或者展开基本详情
- (void) flexOrShrinkScriptContentWithScriptInfo:(LLAScriptHallItemInfo *) cellScriptInfo {
    //
    cellScriptInfo.isStretched = !cellScriptInfo.isStretched;
    
    [dataCollectionView reloadData];
}

// 不同状态下的剧本
- (void) manageScriptWithScriptInfo:(LLAScriptHallItemInfo *) cellScriptInfo {
    // 剧本状态信息
    switch (scriptInfo.status) {
        case LLAScriptStatus_Normal:
        {
            if (scriptInfo.currentRole == LLAUserRoleInScript_Director) {
                //director,this time choose actor
                
                if (scriptInfo.partakeUsersArray.count > 0) {
                    LLAUser *selectedUser = [self selectedUserInfoScriptInfo];
                    
                    //
                    LLAPayUserPayInfo *payInfo = [LLAPayUserPayInfo new];
                    payInfo.payToUser = selectedUser;
                    payInfo.payMoney = scriptInfo.rewardMoney;
                    payInfo.payToScriptIdString = scriptInfo.scriptIdString;
                    
                    //
                    LLAPayUserViewController *pay = [[LLAPayUserViewController alloc] initWithPayInfo:payInfo];
                    [self.navigationController pushViewController:pay animated:YES];
                    
                }else {
                    
                }
                
                
            }else if (scriptInfo.currentRole == LLAUserRoleInScript_Actor) {
                //actor,do nothing
                
            }else {
                //passer,join to act the script
                [self signUpTheScript];
            }
        }
            
            break;
        case LLAScriptStatus_PayUnvertified:
        {
            if (scriptInfo.currentRole == LLAUserRoleInScript_Director) {
                //director
            }else if (scriptInfo.currentRole == LLAUserRoleInScript_Actor) {
                //actor
            }else {
                //passer
            }
        }
            
            break;
        case LLAScriptStatus_PayVertified:
        {
            if (scriptInfo.currentRole == LLAUserRoleInScript_Director) {
                //director,should wait,do nothing
                
            }else if (scriptInfo.currentRole == LLAUserRoleInScript_Actor) {
                //actor,should upload viedeo
                
            }else {
                //passer,do nothing

            }
        }
            break;
            
        case LLAScriptStatus_VideoUploaded:
        {
            if (scriptInfo.currentRole == LLAUserRoleInScript_Director) {
                //director,show the video
                
            }else if (scriptInfo.currentRole == LLAUserRoleInScript_Actor) {
                //actor,show the video
            
                
            }else {
                //passer,show the video
            }
        }
            
            break;
        case LLAScriptStatus_WaitForUploadTimeOut:
        {
            if (scriptInfo.currentRole == LLAUserRoleInScript_Director) {
                //director,time out
                
            }else if (scriptInfo.currentRole == LLAUserRoleInScript_Actor) {
                //actor,time out
        
            }else {
                //passer,time out
            }
        }
            
            break;
            
        default:
        {
            //do nothing
            
//            if (scriptInfo.currentRole == LLAUserRoleInScript_Director) {
//                //director
//            
//            }else if (scriptInfo.currentRole == LLAUserRoleInScript_Actor) {
//                //actor
//                
//            }else {
//                //passer
//            }
        }
            
            break;
    }
}

#pragma mark - LLAChooseActorCellDelegate
// 点击演员头像后查看详细信息
- (void) viewUserDetailWithUserInfo:(LLAUser *)userInfo  {
    //go to user profile
    
    LLAUserProfileViewController *userProfile = [[LLAUserProfileViewController alloc] initWithUserIdString:userInfo.userIdString];
    
    [self.navigationController pushViewController:userProfile animated:YES];

    
}

#pragma mark - Private Method
// 申请演剧本
- (void) signUpTheScript {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:scriptInfo.scriptIdString forKey:@"playId"];
    
    [HUD show:NO];
    
    [LLAHttpUtil httpPostWithUrl:@"/play/applyPlay" param:params responseBlock:^(id responseObject) {
        
        [HUD hide:NO];
        //sign up success,join me to the sign up array，申请成功就显示在演员列表中
        
        LLAUser *user = [LLAUser me];
        
        [scriptInfo.partakeUsersArray insertObject:user atIndex:0];
        
        [dataCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:chooseActorInfoSectionIndex]]];
        scriptInfo.signupUserNumbers++;
        scriptInfo.currentRole = LLAUserRoleInScript_Actor;
        [dataCollectionView reloadSections:[NSIndexSet indexSetWithIndex:mainInfoSectionIndex]];
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:NO];
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [HUD hide:NO];
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        
    }];
    
}

// 选择的演员
- (LLAUser *) selectedUserInfoScriptInfo {
    
    for (LLAUser *user in scriptInfo.partakeUsersArray) {
        if (user.hasBeenSelected) {
            return user;
            break;
        }
    }
    return nil;
}


@end
