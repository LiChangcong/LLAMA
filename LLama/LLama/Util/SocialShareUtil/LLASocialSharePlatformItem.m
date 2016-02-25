//
//  LLASocialSharePlatformItem.m
//  LLama
//
//  Created by Live on 16/2/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLASocialSharePlatformItem.h"

@implementation LLASocialSharePlatformItem

+ (LLASocialSharePlatformItem *) weChatSessionItem {
    LLASocialSharePlatformItem *item = [LLASocialSharePlatformItem new];
    item.platformName = @"微信";
    item.platform = LLASocialSharePlatform_WechatSession;
    item.platformImage_Normal = [UIImage llaImageWithName:@"wechat"];
    item.platformImage_Highlight = [UIImage llaImageWithName:@"wechath"];
    
    return item;
}

+ (LLASocialSharePlatformItem *) weChatTimeLineItem {
    LLASocialSharePlatformItem *item = [LLASocialSharePlatformItem new];
    item.platformName = @"朋友圈";
    item.platform = LLASocialSharePlatform_WechatTimeLine;
    item.platformImage_Normal = [UIImage llaImageWithName:@"friendscircle"];
    item.platformImage_Highlight = [UIImage llaImageWithName:@"friendscircleh"];
    
    return item;

}

+ (LLASocialSharePlatformItem *) sinaWeiboItem {
    LLASocialSharePlatformItem *item = [LLASocialSharePlatformItem new];
    item.platformName = @"新浪微博";
    item.platform = LLASocialSharePlatform_SinaWeiBo;
    item.platformImage_Normal = [UIImage llaImageWithName:@"weibo"];
    item.platformImage_Highlight = [UIImage llaImageWithName:@"weiboh"];
    
    return item;

}

+ (LLASocialSharePlatformItem *) qqFriendItem {
    LLASocialSharePlatformItem *item = [LLASocialSharePlatformItem new];
    item.platformName = @"QQ";
    item.platform = LLASocialSharePlatform_QQFriend;
    item.platformImage_Normal = [UIImage llaImageWithName:@"qq"];
    item.platformImage_Highlight = [UIImage llaImageWithName:@"qqh"];
    
    return item;

}

+ (LLASocialSharePlatformItem *) qqZoneItem {
    LLASocialSharePlatformItem *item = [LLASocialSharePlatformItem new];
    item.platformName = @"QQ空间";
    item.platform = LLASocialSharePlatform_QQZone;
    item.platformImage_Normal = [UIImage llaImageWithName:@"qqzone"];
    item.platformImage_Highlight = [UIImage llaImageWithName:@"qqzoneh"];
    
    return item;

}

+ (LLASocialSharePlatformItem *) copyLink {
    LLASocialSharePlatformItem *item = [LLASocialSharePlatformItem new];
    item.platformName = @"复制链接";
    item.platform = LLASocialSharePlatform_CopyLink;
    item.platformImage_Normal = [UIImage llaImageWithName:@"connect"];
    item.platformImage_Highlight = [UIImage llaImageWithName:@"connectH"];
    
    return item;

}

@end
