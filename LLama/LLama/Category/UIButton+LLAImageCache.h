//
//  UIButton+LLAImageCache.h
//  LLama
//
//  Created by Live on 16/1/12.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LLAImageCache)

- (void) setImageWithURL:(NSURL *)url forstate:(UIControlState) state placeholder:(UIImage *) placeholder;

- (void) setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholder:(UIImage *)placeholder;

@end
