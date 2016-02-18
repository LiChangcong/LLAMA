//
//  LLAUserProfileSettingItemInfo.m
//  LLama
//
//  Created by Live on 16/1/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserProfileSettingItemInfo.h"

#import "LLACommonUtil.h"

@implementation LLAUserProfileSettingItemInfo

+ (LLAUserProfileSettingItemInfo *) accountSaftyItem {
    LLAUserProfileSettingItemInfo *item = [LLAUserProfileSettingItemInfo new];
    item.titleString = @"帐号与安全";
    return item;
}

+ (LLAUserProfileSettingItemInfo *) friendAuthItem {
    
    LLAUserProfileSettingItemInfo *item = [LLAUserProfileSettingItemInfo new];
    item.titleString = @"好友验证";
    return item;
    
}

+ (LLAUserProfileSettingItemInfo *) vipItem {
    LLAUserProfileSettingItemInfo *item = [LLAUserProfileSettingItemInfo new];
    item.titleString = @"加V认证";
    return item;
}

+ (LLAUserProfileSettingItemInfo *) userAgreementItem {
    LLAUserProfileSettingItemInfo *item = [LLAUserProfileSettingItemInfo new];
    item.titleString = @"用户协议";
    return item;
}

+ (LLAUserProfileSettingItemInfo *) userCommentItem {
    LLAUserProfileSettingItemInfo *item = [LLAUserProfileSettingItemInfo new];
    item.titleString = @"给个好评吧，都不容易";
    return item;
}

+ (LLAUserProfileSettingItemInfo *) versionItem {
    
    LLAUserProfileSettingItemInfo *item = [LLAUserProfileSettingItemInfo new];
    item.titleString = @"版本信息(点击检测新版本)";
    item.detailContentString = [LLACommonUtil appVersion];
    return item;
}
+ (LLAUserProfileSettingItemInfo *) cacheItem {
    LLAUserProfileSettingItemInfo *item = [LLAUserProfileSettingItemInfo new];
    item.itemType = LLASettingItemType_Cache;
    item.titleString = @"清除缓存";
    item.detailContentString = @"正在检测...";
    return item;
}

@end
