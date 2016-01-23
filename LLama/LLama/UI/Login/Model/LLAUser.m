//
//  LLAUser.m
//  LLama
//
//  Created by WanDa on 16/1/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUser.h"
#import "LLASaveUserDefaultUtil.h"

//用来标识解析

static BOOL isSimpleUserModel;

@implementation LLAUser

@synthesize hasBeenSelected;

+ (LLAUser *) parseJsonWidthDic:(NSDictionary *)data {
    isSimpleUserModel = NO;
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:data error:nil];
    
}


+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    
    if (isSimpleUserModel) {
        return @{@"userIdString":@"uid",
                 @"userName":@"uname",
                 @"headImageURL":@"imgUrl"};
    }else {
        return @{@"userIdString":@"id",
                 @"userName":@"name",
                 @"mobilePhone":@"mobile",
                 @"genderString":@"gender",
                 @"gender":@"gender",
                 @"headImageURL":@"img",
                 //@"userVideo":@"myVideo",
                 @"userDescription":@"gxqm",
                 @"balance":@"balance",
                 @"bePraisedNumber":@"zan",
                 
                 @"sinaWeiBoUid":@"weibouid",
                 @"qqOpenId":@"qqopenid",
                 @"weChatOpenId":@"wxopenid",
                 
                 //for temp
                 @"videoCoverImageURL":@"videoThumb",
                 @"videoPlayURL":@"myVideo",
                 
                 };

    }
}

+ (NSValueTransformer *)genderStringJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{@"男":@(UserGender_Male),
                                                                           @"女":@(UserGender_Female)}];
    
}

+ (NSValueTransformer *)userVideoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[LLAVideoInfo class]];
    
}

+ (NSValueTransformer *)balanceJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *value, BOOL *success, NSError *__autoreleasing *error) {
        return @(((float)value.integerValue) / 100);
    }];
    
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {

    self = [super initWithDictionary:dictionaryValue error:error];
    
    if (self) {
        if (self.videoPlayURL) {
            LLAVideoInfo *videoInfo = [LLAVideoInfo new];
            
            videoInfo.videoPlayURL = self.videoPlayURL;
            videoInfo.videoCoverImageURL = self.videoCoverImageURL;
            
            self.userVideo = videoInfo;
        }
        
        //test data
        //self.userDescription = @"lalfklsdfasldfksadlfasdfkljsadlfkjsaldfjksdkfjsadlkfjksdfjsdkfjasdfkadslflasdfjsdklfjsdf";
    }
    return self;
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

- (BOOL) isEqual:(id)object {
    if (!object || ![object isKindOfClass:[LLAUser class]]) {
        return NO;
    }
    
    LLAUser *user = (LLAUser *) object;
    
    if ([user.userIdString isEqualToString:self.userIdString]) {
        return YES;
    }else {
        return NO;
    }
    
}

//logout
+ (void) logout {
    [LLASaveUserDefaultUtil clearUserInfo];
    [LLASaveUserDefaultUtil clearUserToken];
}

////用来标识解析

+ (BOOL) isSimpleUserModel {
    return isSimpleUserModel;
}

+ (void) setIsSimpleUserModel:(BOOL)isSimple {
    isSimpleUserModel = isSimple;
}

@end
