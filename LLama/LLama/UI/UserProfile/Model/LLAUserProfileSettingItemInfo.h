//
//  LLAUserProfileSettingItemInfo.h
//  LLama
//
//  Created by Live on 16/1/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"

typedef NS_ENUM(NSInteger,LLASettingItemType) {
    
    LLASettingItemType_AccountSafety = 0,
    LLASettingItemType_FriendAuth = 1,
    LLASettingItemType_VIP = 2,
    LLASettingItemType_UserAgreement = 3,
    LLASettingItemType_UserComment = 4,
    LLASettingItemType_Version = 5,
    LLASettingItemType_Cache = 6,
    LLASettingItemType_LoginOut = 7,
} ;

@interface LLAUserProfileSettingItemInfo : MTLModel

@property(nonatomic , copy) NSString *titleString;

@property(nonatomic , copy) NSString *detailContentString;

@property(nonatomic , assign) LLASettingItemType itemType;

+ (LLAUserProfileSettingItemInfo *) accountSaftyItem ;

+ (LLAUserProfileSettingItemInfo *) friendAuthItem;

+ (LLAUserProfileSettingItemInfo *) vipItem;

+ (LLAUserProfileSettingItemInfo *) userAgreementItem;

+ (LLAUserProfileSettingItemInfo *) userCommentItem;

+ (LLAUserProfileSettingItemInfo *) versionItem;

+ (LLAUserProfileSettingItemInfo *) cacheItem;



@end
