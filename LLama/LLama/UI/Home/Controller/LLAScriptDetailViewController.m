//
//  LLAScriptDetailViewController.m
//  LLama
//
//  Created by Live on 16/1/17.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAScriptDetailViewController.h"

//view
#import "LLACollectionView.h"
#import "LLAScriptDetailMainInfoCell.h"
#import "LLAChooseActorCell.h"
#import "LLALoadingView.h"
#import "LLAScriptChooseActorHeader.h"

//model
#import "LLAScriptHallItemInfo.h"

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
    
    [self initNavigationItems];
    [self initSubView];
    
    [self loadData];
    [HUD show:YES];
}

#pragma mark - Init

- (void) initNavigationItems {
    self.navigationItem.title = @"详情";
}

- (void) initSubView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = chooseActorCellsHorSpace;
    flowLayout.minimumLineSpacing = chooseActorCellsVerSpace;

    
    dataCollectionView = [[LLACollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    dataCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    dataCollectionView.delegate = self;
    dataCollectionView.dataSource = self;
    dataCollectionView.bounces = YES;
    dataCollectionView.alwaysBounceVertical = YES;
    dataCollectionView.backgroundColor = [UIColor colorWithHex:0xeaeaea];
    
    [self.view addSubview:dataCollectionView];
    
    //register class
    [dataCollectionView registerClass:[LLAScriptDetailMainInfoCell class] forCellWithReuseIdentifier:scriptInfoCellIden];
    [dataCollectionView registerClass:[LLAChooseActorCell class] forCellWithReuseIdentifier:chooseActorCellIden];
    [dataCollectionView registerClass:[LLAScriptChooseActorHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:chooseActorHeaderIden];
    
    //constraints
    
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
    
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
    
}


#pragma mark - Load Data

- (void) loadData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:scriptIDString forKey:@"playId"];
    
    [LLAHttpUtil httpPostWithUrl:@"/play/getPlayDetails" param:params responseBlock:^(id responseObject) {
        
        [HUD hide:YES];
        
        LLAScriptHallItemInfo *info = [LLAScriptHallItemInfo parseJsonWithDic:responseObject];
        if (info) {
            scriptInfo = info;
            [dataCollectionView reloadData];
        }
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:YES];
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [HUD hide:YES];
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        
    }];
    
}

- (void) loadMoreData {
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == mainInfoSectionIndex) {
        if (scriptInfo){
            return 1;
        }else {
            return 0;
        }
    }else if (section == chooseActorInfoSectionIndex) {
        return scriptInfo.partakeUsersArray.count;
    }else {
        return 0;
    }
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == mainInfoSectionIndex) {
        
        LLAScriptDetailMainInfoCell *mainCell = [dataCollectionView dequeueReusableCellWithReuseIdentifier:scriptInfoCellIden forIndexPath:indexPath];
        mainCell.delegate = self;
        
        [mainCell updateCellWithInfo:scriptInfo maxWidth:collectionView.frame.size.width];
        return mainCell;
        
    }else {
        LLAChooseActorCell *actorCell = [dataCollectionView dequeueReusableCellWithReuseIdentifier:chooseActorCellIden forIndexPath:indexPath];
        actorCell.delegate = self;
        
        [actorCell updateCellWithUserInfo:scriptInfo.partakeUsersArray[indexPath.row]];
        return actorCell;
    }
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //header footer
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
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
    
    if (indexPath.section == chooseActorInfoSectionIndex) {
        //select,or,deselect
        
        if (scriptInfo.currentRole == LLAUserRoleInScript_Director && scriptInfo.status == LLAScriptStatus_Normal) {
            
            LLAUser *oldSelectedUser = [self selectedUserInfoScriptInfo];
            
            LLAUser *newSelectedUser = scriptInfo.partakeUsersArray[indexPath.row];
            
            if (oldSelectedUser == newSelectedUser) {
                oldSelectedUser.hasBeenSelected = NO;
            }else {
                oldSelectedUser.hasBeenSelected = NO;
                newSelectedUser.hasBeenSelected = YES;
            }
            
            [dataCollectionView reloadData];

        }
    }
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (mainInfoSectionIndex == indexPath.section) {
        
        return CGSizeMake(collectionView.frame.size.width, [LLAScriptDetailMainInfoCell calculateHeightWithInfo:scriptInfo maxWidth:collectionView.frame.size.width]);
        
    }else {
    
        CGFloat itemWidth = (collectionView.frame.size.width - 3*chooseActorCellsHorSpace)/2;
    
        CGFloat itemHeight = [LLAChooseActorCell calculateHeightWitthUserInfo:scriptInfo.partakeUsersArray[indexPath.row] maxWidth:itemWidth];
        return CGSizeMake(itemWidth, itemHeight);
    }
    
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == mainInfoSectionIndex) {
        return UIEdgeInsetsZero;
    }else {
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

- (void) directorHeadViewClicked:(LLAUserHeadView *) headView userInfo:(LLAUser *) userInfo scriptInfo:(LLAScriptHallItemInfo *)scriptInfo {
    //go to user profile
}

- (void) flexOrShrinkScriptContentWithScriptInfo:(LLAScriptHallItemInfo *) cellScriptInfo {
    //
    cellScriptInfo.isStretched = !cellScriptInfo.isStretched;
    
    [dataCollectionView reloadData];
}

- (void) manageScriptWithScriptInfo:(LLAScriptHallItemInfo *) cellScriptInfo {
    //
    switch (scriptInfo.status) {
        case LLAScriptStatus_Normal:
        {
            if (scriptInfo.currentRole == LLAUserRoleInScript_Director) {
                //director,this time choose actor
                
                if (scriptInfo.partakeUsersArray.count > 0) {

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

- (void) viewUserDetailWithUserInfo:(LLAUser *)userInfo  {
    //go to user profile
    
}

#pragma mark - Private Method

- (void) signUpTheScript {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:scriptInfo.scriptIdString forKey:@"playId"];
    
    [HUD show:NO];
    
    [LLAHttpUtil httpPostWithUrl:@"/play/applyPlay" param:params responseBlock:^(id responseObject) {
        
        [HUD hide:NO];
        //sign up success,join me to the sign up array
        
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
