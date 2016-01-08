//
//  UIColor+LLAColorWithHex.h
//  LLama
//
//  Created by WanDa on 16/1/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LLAColorWithHex)

+ (UIColor *)colorWithHex:(NSInteger)hexValue;
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end
