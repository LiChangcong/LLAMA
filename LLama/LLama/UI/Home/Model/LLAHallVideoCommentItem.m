//
//  LLAHallVideoCommentItem.m
//  LLama
//
//  Created by Live on 16/1/13.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHallVideoCommentItem.h"

#import "LLAUser.h"
#import "LLACommonUtil.h"

@implementation LLAHallVideoCommentItem

+ (LLAHallVideoCommentItem *) parseJsonWithDic:(NSDictionary *)data {
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:data error:nil];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"commentId":@"id",
             @"scriptId":@"uid",
             @"commentContent":@"content",
             @"commentTimeString":@"time",
             @"commentTime":@"time",
             
             //
             @"authorUidString":@"uid",
             @"authorName":@"uname",
             @"authorHeadURL":@"imgUrl",
             
             @"replyToUserIdString":@"targetUid",
             @"replyToUserName":@"target",
             @"replyToUserHeadURL":@"tartgetImgUrl",
             
             
             };
}

+ (NSValueTransformer *)commentTimeStringJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [LLACommonUtil formatTimeFromTimeInterval:[value longLongValue]];
    }];
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
    
    LLAHallVideoCommentItem *item = [super initWithDictionary:dictionaryValue error:error];
    
    //construct author user,reply user
    LLAUser *author = [LLAUser new];
    
    author.userIdString = self.authorUidString;
    author.userName = self.authorName;
    author.headImageURL = self.authorHeadURL;
    item.authorUser = author;
    
    //reply user
    NSString *replyUserName = self.replyToUserName;
    if (replyUserName.length > 0) {
        
        LLAUser *replyToUser = [LLAUser new];
        replyToUser.userName = replyUserName;
        replyToUser.userIdString = self.replyToUserIdString;
        replyToUser.headImageURL = self.replyToUserHeadURL;
        
        item.replyToUser = replyToUser;
    }
    
    return item;
}

@end
