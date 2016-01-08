//
//  UIBarButtonItem+Image.h
//  LLama
//
//  Created by WanDa on 16/1/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Image)

+ (instancetype) barItemWithImage:(UIImage *) image highlightedImage:(UIImage *) highlightedImage target:(id) target action:(SEL) action;

@end
