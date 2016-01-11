//
//  LLACommonUtil.m
//  LLama
//
//  Created by Live on 16/1/11.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLACommonUtil.h"

@implementation LLACommonUtil

+(BOOL)validateMobile:(NSString *)mobileNum{
    NSString * MOBILE = @"^((13[0-9])|(15[0-9])|(17[^0,\\D])|(18[0-9]))\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    //    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    //    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    if ([regextestmobile evaluateWithObject:mobileNum] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL) validatePassword:(NSString *)password {
    if (password.length<1) {
        return NO;
    }else if(password.length > 16) {
        return NO;
    }else {
        return YES;
    }
}


@end
