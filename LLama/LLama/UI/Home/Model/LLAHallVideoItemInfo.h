//
//  LLAHallVideoItemInfo.h
//  LLama
//
//  Created by Live on 16/1/13.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"

#import "LLAUser.h"
#import "LLAHallVideoCommentItem.h"
#import "LLAVideoInfo.h"

@interface LLAHallVideoItemInfo : MTLModel<MTLJSONSerializing>

@property(nonatomic , copy) NSString *scriptID;

@property(nonatomic , strong) LLAUser *directorInfo;

@property(nonatomic , strong) LLAUser *actorInfo;

@property(nonatomic , copy) NSString *videoCoverImageURL;

@property(nonatomic , copy) NSString *scriptContent;

@property(nonatomic , assign) NSInteger rewardMoney;

@property(nonatomic , assign) long long videoUploadTime;

@property(nonatomic , copy)  NSString *videoUploadTimeString;

@property(nonatomic , assign) NSInteger praiseNumbers;

@property(nonatomic , assign) NSInteger commentNumbers;

@property(nonatomic , assign) BOOL hasPraised;

@property(nonatomic , strong) NSArray <LLAHallVideoCommentItem *> *commentArray;

//
@property(nonatomic , strong) LLAVideoInfo *videoInfo;

//do not use,just for temp
/*
 do not use
 */
@property(nonatomic , copy) NSString *videoURL;


+ (LLAHallVideoItemInfo *) parseJsonWithDic:(NSDictionary *)data;

@end
