//
//  LLACommonUtil.h
//  LLama
//
//  Created by Live on 16/1/11.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLACommonUtil : NSObject

//phone number,password validate
+(BOOL)validateMobile:(NSString *)mobileNum;

+(BOOL) validatePassword:(NSString *) password;

//time formator

+ (NSString *) formatTimeFromTimeInterval:(long long) timeInterval;

//get value from dictionary

+ (id) valueFromDictionary:(NSDictionary *) dic key:(NSString *)key targetClass:(Class) targetClass;

//get height for label when limit lines

+ (CGFloat) calculateHeightWithAttributeDic:(NSDictionary *) attributes maxLine:(NSInteger) maxLine;

@end
