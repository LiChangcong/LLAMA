//
//  LLAHallVideoCommentItem.h
//  LLama
//
//  Created by Live on 16/1/13.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"

@class LLAUser;

@interface LLAHallVideoCommentItem : MTLModel<MTLJSONSerializing>

@property(nonatomic , assign) NSInteger commentId;

@property(nonatomic , assign) NSInteger scriptId;

@property(nonatomic , strong) LLAUser *authorUser;

@property(nonatomic , strong) LLAUser *replyToUser;

@property(nonatomic , copy) NSString *commentContent;

@property(nonatomic , assign) long long commentTime;

@property(nonatomic , copy) NSString *commentTimeString;

//
/*
 do not use
 */
@property(nonatomic , copy) NSString *authorUidString;
@property(nonatomic , copy) NSString *authorName;
@property(nonatomic , copy) NSString *authorHeadURL;

@property(nonatomic , copy) NSString *replyToUserIdString;
@property(nonatomic , copy) NSString *replyToUserName;
@property(nonatomic , copy) NSString *replyToUserHeadURL;

+ (LLAHallVideoCommentItem *) parseJsonWithDic:(NSDictionary *) data;

@end
