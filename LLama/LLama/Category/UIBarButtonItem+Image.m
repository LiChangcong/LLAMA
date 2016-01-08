//
//  UIBarButtonItem+Image.m
//  LLama
//
//  Created by WanDa on 16/1/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "UIBarButtonItem+Image.h"

@implementation UIBarButtonItem (Image)

+ (instancetype) barItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action {
    
    if (!image){
        return nil;
    }
    UIButton *button = [UIButton new];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
    
}

@end
