//
//  LLAHotVideosCell.m
//  LLama
//
//  Created by tommin on 16/2/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHotVideosCell.h"


static NSString *const prizeButtonImageName_Normal = @"search_cell_prize";
static NSString *const prizeButtonImageName_Highlight = @"search_cell_prize";

static NSString *const loveButtonImageName_Normal = @"search_cell_like";
static NSString *const loveButtonImageName_Highlight = @"search_cell_like";


static const CGFloat hotVideoImageViewToBottom = 0;
static const CGFloat prizeButtonToLeftAndBottom = 7;


@interface LLAHotVideosCell()
{
    UIImageView *hotVideoImageView;
    
    UIButton *prizeButton;
    
    UIButton *loveButton;
    
    //
    UIFont *prizeAndLoveButtonTextFont;
    UIColor *prizeButtonTextColor;
}
@end

@implementation LLAHotVideosCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        // 设置
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];

    }
    return self;
}

// 设置变量
- (void)initVariables
{
    prizeAndLoveButtonTextFont = [UIFont systemFontOfSize:12];
    prizeButtonTextColor = [UIColor colorWithHex:0xfe016b];
}

// 设置子控件
- (void)initSubViews
{
    // hotVideoImageView
    hotVideoImageView = [[UIImageView alloc] init];
    hotVideoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    hotVideoImageView.backgroundColor = [UIColor yellowColor];
    hotVideoImageView.contentMode = UIViewContentModeScaleAspectFill;
    hotVideoImageView.clipsToBounds = YES;
    [self.contentView addSubview:hotVideoImageView];
    
    // prizeButton
    prizeButton = [[UIButton alloc] init];
    prizeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [prizeButton setImage:[UIImage llaImageWithName:prizeButtonImageName_Normal] forState:UIControlStateNormal];
    [prizeButton setImage:[UIImage llaImageWithName:prizeButtonImageName_Highlight] forState:UIControlStateHighlighted];
    [prizeButton setTitle:@"688" forState:UIControlStateNormal];
    [prizeButton setTitleColor:prizeButtonTextColor forState:UIControlStateNormal];
    prizeButton.titleLabel.font = prizeAndLoveButtonTextFont;
    prizeButton.userInteractionEnabled = NO;
    [self.contentView addSubview:prizeButton];
    
    // loveButton
    loveButton = [[UIButton alloc] init];
    loveButton.translatesAutoresizingMaskIntoConstraints = NO;
    [loveButton setImage:[UIImage llaImageWithName:loveButtonImageName_Normal] forState:UIControlStateNormal];
    [loveButton setImage:[UIImage llaImageWithName:loveButtonImageName_Highlight] forState:UIControlStateHighlighted];
    [loveButton setTitle:@"321" forState:UIControlStateNormal];
    loveButton.titleLabel.font = prizeAndLoveButtonTextFont;
    loveButton.userInteractionEnabled = NO;
    [self.contentView addSubview:loveButton];

}

// 设置约束
- (void)initSubConstraints
{
    [hotVideoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(-hotVideoImageViewToBottom);
    }];
    
    [prizeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hotVideoImageView).with.offset(prizeButtonToLeftAndBottom);
        make.bottom.equalTo(hotVideoImageView).with.offset(- prizeButtonToLeftAndBottom);
    }];
    
    [loveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(prizeButton.mas_right).with.offset(14);
        make.centerY.equalTo(prizeButton.mas_centerY);
    }];
}

#pragma mark - Update Cell
// 设置信息
//- (void) updateCellWithUserInfo:(LLAUser *)userInfo {
//    //
//    currentUserInfo = userInfo;
//    
//    // 设置头像
//    [userHeadImageView setImageWithURL:[NSURL URLWithString:currentUserInfo.headImageURL] placeholderImage:[UIImage llaImageWithName:@"placeHolder_200"]];
//    // 遥远名字
//    userNameLabel.text = currentUserInfo.userName;
//    // 选中按钮选中与否
//    selectedImageCoverView.hidden = !currentUserInfo.hasBeenSelected;
//    
//}

// 计算高度
+ (CGFloat) calculateHeightWitthUserInfo:(LLAUser *)userInfo maxWidth:(CGFloat)maxWidth  {
    return MAX(0, maxWidth+hotVideoImageViewToBottom);
}

@end
