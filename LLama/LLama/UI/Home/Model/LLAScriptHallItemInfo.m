//
//  LLAScriptHallItemInfo.m
//  LLama
//
//  Created by Live on 16/1/16.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAScriptHallItemInfo.h"

@implementation LLAScriptHallItemInfo

+ (LLAScriptHallItemInfo *) parseJsonWithDic:(NSDictionary *)data {
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:data error:nil];
    
}

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    
    return @{@"scriptIdString":@"id",
             @"directorInfo":@"creater",
             @"scriptContent":@"content",
             @"rewardMoney":@"fee",
             @"scriptImageURL":@"imageURL",
             @"isPrivateVideo":@"isPrivate",
             @"status":@"stats",
             @"partakeUsersArray":@"signups",
             @"choosedUserIdString":@"chosen",
             @"publishTimeInterval":@"createTime",
             @"publisthTimeString":@"createTime",
             @"timeOutInterval":@"countDown",
             
             
             
             };
    
}

+ (NSValueTransformer *)directorInfoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:LLAUser.class];
}

+ (NSValueTransformer *)partakeUsersArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:LLAUser.class];
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {

    self = [super initWithDictionary:dictionaryValue error:error];
    
    if (self) {
        
        LLAUser *directorInfo = [LLAUser new];
        directorInfo.userIdString = @"5690d4371411cd4050d4ca56";
        directorInfo.headImageURL = @"http://source.hillama.com/5690d4411411cd4050d4ca58";
        directorInfo.userName = @"heheh";
        
        self.directorInfo = directorInfo;
        
    }
    
    return self;
    
}

@end
