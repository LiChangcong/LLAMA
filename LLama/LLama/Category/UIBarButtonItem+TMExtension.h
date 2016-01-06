//
//  UIBarButtonItem+TMExtension.h
//  LLama
//
//  Created by tommin on 15/12/15.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (TMExtension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
