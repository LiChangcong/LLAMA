//
//  LLAHotUsersButton.m
//  LLama
//
//  Created by tommin on 16/2/24.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHotUsersButton.h"

@implementation LLAHotUsersButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setTitleColor:[UIColor colorWithHex:0xb9b9bb] forState:UIControlStateNormal];
    }
    return self;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    self.imageView.y = 0;
//    self.imageView.centerX = self.width * 0.5;
    self.imageView.x = 0;
    
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.bottom;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

@end
