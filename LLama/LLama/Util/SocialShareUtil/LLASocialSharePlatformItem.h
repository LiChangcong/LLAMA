//
//  LLASocialSharePlatformItem.h
//  LLama
//
//  Created by Live on 16/2/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"
#import "LLASocialShareHeader.h"

@interface LLASocialSharePlatformItem : MTLModel

@property(nonatomic , copy) NSString *platformName;

@property(nonatomic , strong) UIImage *platformImage_Normal;

@property(nonatomic , strong) UIImage *platformImage_Highlight;

@property(nonatomic , assign) LLASocialSharePlatform platform;

+ (LLASocialSharePlatformItem *) weChatSessionItem;

+ (LLASocialSharePlatformItem *) weChatTimeLineItem;

+ (LLASocialSharePlatformItem *) sinaWeiboItem;

+ (LLASocialSharePlatformItem *) qqFriendItem;

+ (LLASocialSharePlatformItem *) qqZoneItem;

+ (LLASocialSharePlatformItem *) copyLink;

@end
