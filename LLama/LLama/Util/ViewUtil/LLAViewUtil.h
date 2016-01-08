//
//  LLAViewUtil.h
//  LLama
//
//  Created by WanDa on 16/1/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBProgressHUD;

@interface LLAViewUtil : NSObject

+ (MBProgressHUD *)showAlter:(UIView *)view withText:(NSString *)text;

+ (MBProgressHUD *)showAlter:(UIView *)view withText:(NSString *)text withOffset:(float)offset;

+ (MBProgressHUD *)showAlter:(UIView *)view withText:(NSString *)text withOffset:(float)offset duration:(CGFloat) duration;

@end
