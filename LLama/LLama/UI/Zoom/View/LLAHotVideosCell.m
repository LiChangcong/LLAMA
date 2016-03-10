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
    
    UIImageView *cover;
    
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
//    hotVideoImageView.backgroundColor = [UIColor yellowColor];
    hotVideoImageView.contentMode = UIViewContentModeScaleAspectFill;
    hotVideoImageView.clipsToBounds = YES;
    [self.contentView addSubview:hotVideoImageView];
    
    
    // cover
    // 画出一张cover。可能会影响性能，以后再优化
    cover = [[UIImageView alloc]initWithFrame:CGRectZero];
    cover.backgroundColor=[UIColor lightGrayColor];
    cover.image=[self buttonImageFromColor:[UIColor blackColor]];
    cover.alpha = 0.2;
    [self.contentView addSubview:cover];
    

    // prizeButton
    prizeButton = [[UIButton alloc] init];
    prizeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [prizeButton setImage:[UIImage llaImageWithName:prizeButtonImageName_Normal] forState:UIControlStateNormal];
    [prizeButton setImage:[UIImage llaImageWithName:prizeButtonImageName_Highlight] forState:UIControlStateHighlighted];
//    [prizeButton setTitle:@"688" forState:UIControlStateNormal];
    [prizeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    prizeButton.titleLabel.font = prizeAndLoveButtonTextFont;
    prizeButton.userInteractionEnabled = NO;
    [self.contentView addSubview:prizeButton];
    
    // loveButton
    loveButton = [[UIButton alloc] init];
    loveButton.translatesAutoresizingMaskIntoConstraints = NO;
    [loveButton setImage:[UIImage llaImageWithName:loveButtonImageName_Normal] forState:UIControlStateNormal];
    [loveButton setImage:[UIImage llaImageWithName:loveButtonImageName_Highlight] forState:UIControlStateHighlighted];
//    [loveButton setTitle:@"321" forState:UIControlStateNormal];
    loveButton.titleLabel.font = prizeAndLoveButtonTextFont;
    loveButton.userInteractionEnabled = NO;
    [self.contentView addSubview:loveButton];

}

//通过颜色来生成一个纯色图片
- (UIImage *)buttonImageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, self.contentView.size.width, self.contentView.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
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
    
    
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(-hotVideoImageViewToBottom);
    }];
}

#pragma mark - Update Cell

// 计算高度
+ (CGFloat) calculateHeightWitthUserInfo:(LLAUser *)userInfo maxWidth:(CGFloat)maxWidth  {
    return MAX(0, maxWidth+hotVideoImageViewToBottom);
}

// 设置信息
- (void) updateCellWithInfo:(LLAHotVideoInfo *)info tableWidth:(CGFloat)width
{
    [hotVideoImageView setImageWithURL:[NSURL URLWithString:info.videoThumb] placeholderImage:[UIImage llaImageWithName:@"placeHolder_750"]];
    [prizeButton setTitle:[NSString stringWithFormat:@"%d",info.fee] forState:UIControlStateNormal];
    [loveButton setTitle:[NSString stringWithFormat:@"%d",info.zan] forState:UIControlStateNormal];

}
@end
