//
//  UIImageView+LLAImageCache.m
//  LLama
//
//  Created by Live on 16/1/12.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "UIImageView+LLAImageCache.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (LLAImageCache)

- (void) setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url placeholderImage:placeholder];
}

@end
