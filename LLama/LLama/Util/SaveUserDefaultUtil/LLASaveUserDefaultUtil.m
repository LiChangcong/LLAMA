//
//  LLASaveUserDefaultUtil.m
//  LLama
//
//  Created by Live on 16/1/11.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLASaveUserDefaultUtil.h"
#import "LLAUser.h"

#define LLA_USER_INFO_AUTH_TOKEN_KEY @"LLA_USER_INFO_AUTH_TOKEN_KEY"
#define LLA_USER_INFO_KEY @"LLA_USER_INFO_KEY"



@implementation LLASaveUserDefaultUtil

+ (void) saveUserTokenToUserDefault:(NSString *)token {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:token forKey:LLA_USER_INFO_AUTH_TOKEN_KEY];
    
    [defaults synchronize];
}

+ (void) clearUserToken {
    
    [self saveUserTokenToUserDefault:nil];
}

+ (NSString *) userAuthToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:LLA_USER_INFO_AUTH_TOKEN_KEY];
}

+ (void) saveUserInfo:(LLAUser *)newUser {
    
    if (newUser.userIdString.length > 0){
        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:newUser];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:userData forKey:LLA_USER_INFO_KEY];
        
        [defaults synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LLA_USER_LOGIN_STATE_CHANGED_NOTIFICATION object:nil];
    }
    
}

+ (void) clearUserInfo {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:LLA_USER_INFO_KEY];
    
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LLA_USER_LOGIN_STATE_CHANGED_NOTIFICATION object:nil];
}

+ (NSData *) userInfoData{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults valueForKey:LLA_USER_INFO_KEY];
    
}

@end
