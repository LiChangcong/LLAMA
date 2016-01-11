//
//  LLASaveUserDefaultUtil.h
//  LLama
//
//  Created by Live on 16/1/11.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LLAUser;
@interface LLASaveUserDefaultUtil : NSObject

//access Token

+ (void) saveUserTokenToUserDefault:(NSString *) token;
+ (void) clearUserToken;
+ (NSString *) userAuthToken;

+ (void) saveUserInfo:(LLAUser *) newUser;
+ (void) clearUserInfo;
+ (NSData *) userInfoData;

@end
