//
//  LLAPayUserViewController.m
//  LLama
//
//  Created by Live on 16/1/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

//constroller
#import "LLAPayUserViewController.h"

//view
#import "LLACollectionView.h"
#import "LLALoadingView.h"
#import "LLAPayUserInfoCollectionCell.h"
#import "LLAPayUserPayTypeCell.h"
#import "LLAPayUserPaySuccessView.h"

//model
#import "LLAPayUserPayTypeItem.h"
#import "LLAPayUserPayInfo.h"

//util
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"
#import "LLAThirdPayManager.h"

static NSString *const payInfoCellIdentifier = @"payInfoCellIdentifier";
static NSString *const payTypeCellIdentifier = @"payTypeCellIdentifier";

static const NSInteger payInfoSectionIndex = 0;
static const NSInteger payTypeSectionIndex = 1;

//
static const CGFloat payInfoToTop = 33;
static const CGFloat payInfoWidth = 290;

static const CGFloat payTypeCellToVerBorder = 28;
static const CGFloat payTypeCellToHorBorder = 10;

static const CGFloat payTypeCellsVerSpace = 8;

@interface LLAPayUserViewController()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LLAPayUserPayTypeCellDelegate>
{
    LLACollectionView *dataCollectionView;
    
    LLAPayUserPayInfo *payInfo;
    
    NSMutableArray<LLAPayUserPayTypeItem *> *payTypeArray;
    
}

@end

@implementation LLAPayUserViewController

@synthesize delegate;

#pragma mark - Life Cycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    [self initVariables];
    [self initNavigationItems];
    [self initSubViews];
    [self initSubConstraints];
    
}

#pragma mark - Init

- (instancetype) initWithPayInfo:(LLAPayUserPayInfo *)info {
    
    self = [super init];
    if (self) {
        payInfo = [info copy];
    }
    
    return self;

}

- (void) initVariables {
    
    payTypeArray = [NSMutableArray array];
    
    //balance
    
    LLAPayUserPayTypeItem *balanceItem = [LLAPayUserPayTypeItem new];
    
    balanceItem.payType = LLAPayUserType_AccountBalance;
    balanceItem.payTypeDesc = @"帐号余额支付";
    balanceItem.payTypeNormalImage = [UIImage llaImageWithName:@"dollarbag"];
    balanceItem.backColor = [UIColor colorWithHex:0x202031];
    
    [payTypeArray addObject:balanceItem];
    
    //alipay
    LLAPayUserPayTypeItem *alipayItem = [LLAPayUserPayTypeItem new];
    
    alipayItem.payType = LLAPayUserType_Alipay;
    alipayItem.payTypeDesc = @"支付宝支付";
    alipayItem.payTypeNormalImage = [UIImage llaImageWithName:@"alipay"];
    alipayItem.backColor = [UIColor colorWithHex:0x5b79fb];
    
    [payTypeArray addObject:alipayItem];
    
    //weChat
    LLAPayUserPayTypeItem *weChatItem = [LLAPayUserPayTypeItem new];
    
    weChatItem.payType = LLAPayUserType_WeChat;
    weChatItem.payTypeDesc = @"微信支付";
    weChatItem.payTypeNormalImage = [UIImage llaImageWithName:@"wechatPay"];
    weChatItem.backColor = [UIColor colorWithHex:0x76d0ac];
    
    [payTypeArray addObject:weChatItem];

    
    
}

- (void) initNavigationItems {
    self.title = @"支付";
}

- (void) initSubViews {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = payTypeCellsVerSpace;
    
    // collectionView
    dataCollectionView = [[LLACollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    dataCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    dataCollectionView.delegate = self;
    dataCollectionView.dataSource = self;
    dataCollectionView.bounces = YES;
    dataCollectionView.alwaysBounceVertical = YES;
    dataCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dataCollectionView];

    [dataCollectionView registerClass:[LLAPayUserInfoCollectionCell class] forCellWithReuseIdentifier:payInfoCellIdentifier];
    [dataCollectionView registerClass:[LLAPayUserPayTypeCell class] forCellWithReuseIdentifier:payTypeCellIdentifier];
    
}

- (void) initSubConstraints {
    
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
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == payInfoSectionIndex) {
        return 1;
    }else if (section == payTypeSectionIndex) {
        return payTypeArray.count;
    }else {
        return 0;
    }
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == payInfoSectionIndex) {
        
        LLAPayUserInfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:payInfoCellIdentifier forIndexPath:indexPath];
        [cell updateCellWithPayInfo:payInfo];
        
        return cell;
        
    }else {
        
        LLAPayUserPayTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:payTypeCellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        [cell updateCellWithPayTypeInfo:payTypeArray[indexPath.row]];
        
        return cell;
        
    }
    
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == payInfoSectionIndex) {
        return CGSizeMake(payInfoWidth, [LLAPayUserInfoCollectionCell calculateHeightWithPayInfo:payInfo tableWidth:collectionView.bounds.size.width]);
    }else {
        
        CGFloat width = collectionView.bounds.size.width - 2 * payTypeCellToHorBorder;
        
        CGFloat height = [LLAPayUserPayTypeCell calculateHeightPayTypeInfo:payTypeArray[indexPath.row] width:width];
        
        return CGSizeMake(width, height);
        
    }
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == payInfoSectionIndex) {
        
        return UIEdgeInsetsMake(payInfoToTop,0, 0, 0);
        
    }else if(section == payTypeSectionIndex) {
        
        return UIEdgeInsetsMake(payTypeCellToVerBorder, payTypeCellToHorBorder, payTypeCellToVerBorder, payTypeCellToHorBorder);
        
    }else {
        return UIEdgeInsetsZero;
    }
}

#pragma mark - LLAPayUserPayTypeCellDelegate

- (void) choosePayType:(LLAPayUserPayTypeItem *)payTypeInfo {
    //
    
    LLALoadingView *HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
    HUD.removeFromSuperViewOnHide = YES;
    [HUD show:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:payInfo.payToScriptIdString forKey:@"playId"];
    [params setValue:payInfo.payToUser.userIdString forKey:@"userId"];

    
    if (payTypeInfo.payType == LLAPayUserType_AccountBalance) {
        [params setValue:@"DEFAULT" forKey:@"payType"];
    }else if (payTypeInfo.payType == LLAPayUserType_Alipay) {
        
        [params setValue:@"ALIPAY" forKey:@"payType"];
        
    }else if (payTypeInfo.payType == LLAPayUserType_WeChat) {
        //request
        [params setValue:@"WX" forKey:@"payType"];
    }
    
    [LLAHttpUtil httpPostWithUrl:@"/play/choosePlay" param:params responseBlock:^(id responseObject) {
        
        [HUD hide:YES];
        
        if (payTypeInfo.payType == LLAPayUserType_AccountBalance) {
            //balance
            
            CGFloat balance = [[responseObject valueForKey:@"balance"] floatValue] / 100.0;
            
            LLAUser *me = [LLAUser me];
            me.balance = balance;
            
            [LLAUser updateUserInfo:me];
            
            //show success
            [self showPaySuccessView];
        
        }else {
            
            LLAThirdPayType payType = LLAThirdPayType_AliPay;
            if (payTypeInfo.payType == LLAPayUserType_WeChat) {
                payType = LLAThirdPayType_WeChat;
            }
            
            [[LLAThirdPayManager shareManager] payWithPayType:payType data:responseObject response:^(LLAThirdPayResponseStatus code, NSError *error) {
                //response
                if (code == LLAThirdPayResponseStatus_Success) {
                    // show success
                    [self showPaySuccessView];
                }else if (code == LLAThirdPayResponseStatus_Unknow) {
                    //pop to pre and refresh
                    if (delegate && [delegate respondsToSelector:@selector(refreshData)]) {
                        [delegate refreshData];
                    }
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            

        }
        
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:YES];
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [HUD hide:YES];
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        
    }];
    
}

//

- (void) showPaySuccessView {
    //
    LLAPayUserPaySuccessView *paySuccess = [[LLAPayUserPaySuccessView alloc] init];
    
    paySuccess.hideCompletionBlock = ^ (MMPopupView *popupView) {
        //pop to pre and refresh
        if (delegate && [delegate respondsToSelector:@selector(refreshData)]) {
            [delegate refreshData];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [paySuccess show];
}

@end
