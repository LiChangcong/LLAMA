//
//  UIImage+LLAImage.m
//  LLama
//
//  Created by WanDa on 16/1/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "UIImage+LLAImage.h"

@implementation UIImage (LLAImage)

+ (UIImage *) llaImageWithName:(NSString *)imageName {
    return [UIImage imageNamed:imageName];
}

+ (UIImage *) llaImageWithColor:(UIColor *)color {
    UIColor *paintColor = color;
    if (!paintColor)
        paintColor = [UIColor whiteColor];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 2.0f, 2.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [paintColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;

    
}

@end
