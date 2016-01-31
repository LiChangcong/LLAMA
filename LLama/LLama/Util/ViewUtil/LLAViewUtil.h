//
//  LLAViewUtil.h
//  LLama
//
//  Created by WanDa on 16/1/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBProgressHUD;
@class LLALoadingView;

@interface LLAViewUtil : NSObject

+ (MBProgressHUD *)showAlter:(UIView *)view withText:(NSString *)text;

+ (MBProgressHUD *)showAlter:(UIView *)view withText:(NSString *)text withOffset:(float)offset;

+ (MBProgressHUD *)showAlter:(UIView *)view withText:(NSString *)text withOffset:(float)offset duration:(CGFloat) duration;

//loading view

+ (LLALoadingView *) addLLALoadingViewToView:(UIView *) view;

//
+ (void) showLoveSuccessAnimationInView:(UIView *) inView
                               fromView:(UIView *) fromView
                               duration:(CGFloat) duration
                         compeleteBlock:(void(^)(BOOL finished)) complete;


@end
