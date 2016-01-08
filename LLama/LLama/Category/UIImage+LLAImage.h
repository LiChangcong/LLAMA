//
//  UIImage+LLAImage.h
//  LLama
//
//  Created by WanDa on 16/1/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LLAImage)

+ (UIImage *) llaImageWithName:(NSString *) imageName;
+ (UIImage *) llaImageWithColor:(UIColor *) color;
@end
