//
//  LLAHotUsersVideosInfo.h
//  LLama
//
//  Created by tommin on 16/3/3.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"

//#import "LLAHotUserInfo.h"
#import "LLAHotVideoInfo.h"
#import "LLAUser.h"


@interface LLAHotUsersVideosInfo : MTLModel<MTLJSONSerializing>

@property(nonatomic , strong) NSMutableArray<LLAUser *> *hotUsersataList;
@property(nonatomic , strong) NSMutableArray<LLAHotVideoInfo *> *hotVideosdataList;

+ (LLAHotUsersVideosInfo *) parseJsonWithDic:(NSDictionary *) data;


@end
