//
//  UIButton+LLAImageCache.m
//  LLama
//
//  Created by Live on 16/1/12.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "UIButton+LLAImageCache.h"
#import "UIButton+WebCache.h"


@implementation UIButton (LLAImageCache)

- (void) setImageWithURL:(NSURL *)url forstate:(UIControlState) state placeholder:(UIImage *) placeholder {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder];
}

- (void) setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholder:(UIImage *)placeholder {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder];
}

@end
