//
//  TMShareButton.m
//  LLama
//
//  Created by tommin on 15/12/10.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMShareButton.h"

@implementation TMShareButton

- (void)awakeFromNib
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片的位置和尺寸
    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    
    // 调整文字的位置和尺寸
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}


@end
