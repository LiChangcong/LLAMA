//
//  LLAUser.m
//  LLama
//
//  Created by WanDa on 16/1/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUser.h"
#import "LLASaveUserDefaultUtil.h"

@implementation LLAUser

+ (LLAUser *) parseJsonWidthDic:(NSDictionary *)data {
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:data error:nil];
}


+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{@"userIdString":@"id",
             @"userName":@"name",
             @"mobilePhone":@"mobile",
             @"genderString":@"gender",
             @"gender":@"gender",
             @"headImageURL":@"img",
             @"userVideo":@"myVideo",
             @"userDescription":@"gxqm",
             
             @"sinaWeiBoUid":@"weibouid",
             @"qqOpenId":@"qqopenid",
             @"weChatOpenId":@"wxopenid",
             
             };
}

+ (NSValueTransformer *)genderJSONJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{@"男":@(UserGender_Male),
                                                                           @"女":@(UserGender_Female)}];
    
}

+ (LLAUser *) me {
    
    NSData *userData = [LLASaveUserDefaultUtil userInfoData];
    
    LLAUser *me = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    return me;
    
}

+ (void) updateUserInfo:(LLAUser *)newUser {
    [LLASaveUserDefaultUtil saveUserInfo:newUser];
}

- (BOOL) hasUserProfile {
    if (!self.isLogin || !self.userName || !self.userIdString){
        return NO;
    }else{
        return YES;
    }
}

@end
