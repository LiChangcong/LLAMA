//
//  TMPhotoView.m
//  LLama
//
//  Created by tommin on 15/12/14.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMPhotoView.h"

@implementation TMPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 内容模式
        self.contentMode = UIViewContentModeScaleAspectFill;
        // 超出边框的内容都剪掉
        self.clipsToBounds = YES;
        
        self.image = [UIImage imageNamed:@"meinv"];
    }
    return self;
}



@end
