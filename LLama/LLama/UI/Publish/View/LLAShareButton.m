//
//  LLAShareButton.m
//  LLama
//
//  Created by tommin on 16/3/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAShareButton.h"

@implementation LLAShareButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHex:0x393748];
        self.titleLabel.textColor = [UIColor colorWithHex:0x807f87];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.x = 17;
    self.imageView.centerY = self.height * 0.5;
    
    self.titleLabel.height = self.height;
    self.titleLabel.y = 0;
    self.titleLabel.x = CGRectGetMaxX(self.imageView.frame);
    self.titleLabel.width = self.width - self.titleLabel.x;
    
}

@end
