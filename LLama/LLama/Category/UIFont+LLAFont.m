//
//  UIFont+LLAFont.m
//  LLama
//
//  Created by WanDa on 16/1/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "UIFont+LLAFont.h"

@implementation UIFont (LLAFont)

+ (UIFont *) llaFontOfSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size];
}

+ (UIFont *)boldLLAFontOfSize:(CGFloat)size {
    
    return [UIFont boldSystemFontOfSize:size];
}

@end
