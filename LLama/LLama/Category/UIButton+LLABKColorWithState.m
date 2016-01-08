//
//  UIButton+LLABKColorWithState.m
//  LLama
//
//  Created by WanDa on 16/1/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "UIButton+LLABKColorWithState.h"

@implementation UIButton (LLABKColorWithState)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    
    [self setBackgroundImage:[UIImage llaImageWithColor:backgroundColor] forState:state];
    
}

@end
