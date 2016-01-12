//
//  UIImageView+LLAImageCache.h
//  LLama
//
//  Created by Live on 16/1/12.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LLAImageCache)

- (void) setImageWithURL:(NSURL *)url placeholderImage:(UIImage *) placeholder;

@end