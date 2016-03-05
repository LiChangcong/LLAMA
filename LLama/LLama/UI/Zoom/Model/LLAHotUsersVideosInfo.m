//
//  LLAHotUsersVideosInfo.m
//  LLama
//
//  Created by tommin on 16/3/3.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHotUsersVideosInfo.h"

@implementation LLAHotUsersVideosInfo
+ (LLAHotUsersVideosInfo *) parseJsonWithDic:(NSDictionary *) data
{
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:data error:nil];
}

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"hotVideosdataList":@"plays",
             @"hotUsersataList":@"users"
             };
}

+ (NSValueTransformer *)hotVideosdataListJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[LLAHotVideoInfo class]];
}

+ (NSValueTransformer *)hotUsersataListJSONTransformer {
    [LLAUser setIsSimpleUserModel:NO];
    [LLAUser setIsSearchModel:YES];
    return [MTLJSONAdapter arrayTransformerWithModelClass:[LLAUser class]];
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self) {
        if (!self.hotVideosdataList || !self.hotUsersataList){
            self.hotVideosdataList = [NSMutableArray array];
            self.hotUsersataList = [NSMutableArray array];
        }
    }
    return self;
}


@end
