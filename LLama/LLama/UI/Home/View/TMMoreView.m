//
//  TMMoreView.m
//  LLama
//
//  Created by tommin on 15/12/10.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMMoreView.h"


#define TMRootView [UIApplication sharedApplication].keyWindow.rootViewController.view


@implementation TMMoreView

+ (instancetype)moreView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    TMRootView.userInteractionEnabled = YES;
    
    [self removeFromSuperview];

}
- (IBAction)cancelButtonClick:(UIButton *)sender {
    
    TMRootView.userInteractionEnabled = YES;
    
    [self removeFromSuperview];

}


@end
