//
//  TMNoticeView.m
//  LLama
//
//  Created by tommin on 15/12/30.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMNoticeView.h"

#define TMRootView [UIApplication sharedApplication].keyWindow.rootViewController.view

@implementation TMNoticeView

+ (instancetype)noticeView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    TMRootView.userInteractionEnabled = YES;
    
    [self removeFromSuperview];
    
}
@end
