//
//  LLAHallVideoItemInfo.m
//  LLama
//
//  Created by Live on 16/1/13.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHallVideoItemInfo.h"

#import "LLACommonUtil.h"

@implementation LLAHallVideoItemInfo

+ (LLAHallVideoItemInfo *) parseJsonWithDic:(NSDictionary *)data {
    
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:data error:nil];
    
}

+ (NSValueTransformer *)directorInfoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:LLAUser.class];
}

+ (NSValueTransformer *)actorInfoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:LLAUser.class];
}

+ (NSValueTransformer *)commentArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[LLAHallVideoCommentItem class]];
}

+ (NSValueTransformer *)videoUploadTimeStringJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *value, BOOL *success, NSError *__autoreleasing *error) {
        return [LLACommonUtil formatTimeFromTimeInterval:[value longLongValue]];
    }];
}

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{@"scriptID":@"id",
             @"directorInfo":@"creater",
             @"actorInfo":@"uploader",
             @"scriptContent":@"content",
             @"rewardMoney":@"fee",
             @"videoUploadTime":@"createTime",
             @"videoUploadTimeString":@"createTime",
             @"praiseNumbers":@"zan",
             @"commentNumbers":@"commentNum",
             @"hasPraised":@"canZan",
             @"commentArray":@"comments",
            //
             @"videoURL":@"videoURL"
             };
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    
    if (self) {

        if (self.videoURL){
            LLAVideoInfo *video = [[LLAVideoInfo alloc] init];
            video.videoPlayURL = self.videoURL;
            self.videoInfo = video;
        }
    }
    
    return self;
    
}

@end
