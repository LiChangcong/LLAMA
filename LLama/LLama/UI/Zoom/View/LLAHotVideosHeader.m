//
//  LLAHotVideosHeader.m
//  LLama
//
//  Created by tommin on 16/2/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHotVideosHeader.h"

@interface LLAHotVideosHeader()
{
    UILabel *headerLabel;
    
    UIFont *titleLabelFont;
    UIColor *titleLabelTextColor;
}
@end

@implementation LLAHotVideosHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 设置
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
    }
    return self;
}

- (void)initVariables
{
    titleLabelFont = [UIFont systemFontOfSize:12];
    titleLabelTextColor = [UIColor colorWithHex:0x807f87];
}

- (void)initSubViews
{
    // 标题
    headerLabel = [[UILabel alloc] init];
    headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    headerLabel.font = titleLabelFont;
    headerLabel.textColor = titleLabelTextColor;
    headerLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:headerLabel];
}

- (void)initSubConstraints
{
    [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).with.offset(17);
        make.right.equalTo(self).with.offset(-6);
    }];
}

- (void) updateHeaderText:(NSString *)headerText
{

    headerLabel.text = headerText;

}


@end
