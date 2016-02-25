//
//  LLAHotUsersSearchResultsHeader.m
//  LLama
//
//  Created by tommin on 16/2/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHotUsersSearchResultsHeader.h"

@interface LLAHotUsersSearchResultsHeader()
{
    UILabel *headerNameLabel;
    
    // font
    UIFont *headerNameLabelFont;
    
    // color
    UIColor *headerNameLabelColor;
}
@end

@implementation LLAHotUsersSearchResultsHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        // 设置
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
        
    }
    return self;
}

- (void)initVariables
{
    headerNameLabelColor = [UIColor colorWithHex:0x807f87];
    headerNameLabelFont = [UIFont systemFontOfSize:12];
}

- (void)initSubViews
{
    headerNameLabel = [[UILabel alloc] init];
    headerNameLabel.textColor = headerNameLabelColor;
    headerNameLabel.font = headerNameLabelFont;
    [self addSubview:headerNameLabel];
    
    
}
- (void)initSubConstraints
{
    [headerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(17);
        make.right.equalTo(self.mas_right);
    }];
}

- (void)updateInfo:(NSString *)searchResultsHeaderText
{
    headerNameLabel.text = searchResultsHeaderText;
}
@end
