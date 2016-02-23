//
//  LLAScriptHallItemInfo.m
//  LLama
//
//  Created by Live on 16/1/16.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAScriptHallItemInfo.h"

#import "LLACommonUtil.h"

@implementation LLAScriptHallItemInfo

@synthesize isStretched;
@synthesize hasTempChoose;

+ (LLAScriptHallItemInfo *) parseJsonWithDic:(NSDictionary *)data {
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:data error:nil];
    
}

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    
    return @{@"scriptIdString":@"id",
             @"directorInfo":@"creater",
             @"scriptContent":@"content",
             @"rewardMoney":@"fee",
             @"scriptImageURL":@"imageURL",
             @"isPrivateVideo":@"secret",
             @"status":@"stats",
             @"partakeUsersArray":@"signups",
             @"signupUserNumbers":@"signupNum",
             @"choosedUserIdString":@"chosen",
             @"publishTimeInterval":@"createTime",
             @"publisthTimeString":@"createTime",
             @"timeOutInterval":@"countDown",
             

             };
    
}

+ (NSValueTransformer *)directorInfoJSONTransformer {
    [LLAUser setIsSimpleUserModel:YES];
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:LLAUser.class];
}

+ (NSValueTransformer *)partakeUsersArrayJSONTransformer {
    [LLAUser setIsSimpleUserModel:YES];
    return [MTLJSONAdapter arrayTransformerWithModelClass:LLAUser.class];
}

+ (NSValueTransformer *)publisthTimeStringJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [LLACommonUtil formatTimeFromTimeInterval:[value longLongValue]];
    }];
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {

    self = [super initWithDictionary:dictionaryValue error:error];
    
    if (self) {
        
//        LLAUser *directorInfo = [LLAUser new];
//        directorInfo.userIdString = @"5690d4371411cd4050d4ca56";
//        directorInfo.headImageURL = @"http://source.hillama.com/5690d4411411cd4050d4ca58";
//        directorInfo.userName = @"heheh";
//        
//        self.directorInfo = directorInfo;
        
        LLAUser *me = [LLAUser me];
        
        if ([self.directorInfo isEqual:me]) {
            self.currentRole = LLAUserRoleInScript_Director;
            
        }else if ([self.partakeUsersArray containsObject:me] || [self.choosedUserIdString isEqualToString:me.userIdString]) {
            self.currentRole = LLAUserRoleInScript_Actor;
        }else {
            self.currentRole = LLAUserRoleInScript_Passer;
        }
    }
    
    return self;
    
}

#pragma mark - format String

+ (NSString *) timeIntervalToFormatString:(long long) timeOutInterval {
    
    if (timeOutInterval > 3600) {
        NSString *formatedString = [NSString stringWithFormat:@"%02lld:%02lld:%02lld",timeOutInterval /3600,(timeOutInterval % 3600)/60,(timeOutInterval % 60)];
        return formatedString;
    }else {
       NSString *formatedString = [NSString stringWithFormat:@"%02lld:%02lld",(timeOutInterval % 3600)/60,(timeOutInterval % 60)];
        return formatedString;
    }
    
}

@end
