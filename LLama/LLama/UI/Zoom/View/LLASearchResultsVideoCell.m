//
//  LLASearchResultsVideoCell.m
//  LLama
//
//  Created by tommin on 16/2/24.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLASearchResultsVideoCell.h"

#import "LLAUserHeadView.h"

// 图片等


// 数值


@interface LLASearchResultsVideoCell()
{
    // 用户
    LLAUserHeadView *userHead;
    UILabel *userName;
    UILabel *userDesLabel;
    UIButton *watchTimesButton;

    // 片酬
    UIView *rewardView;
    
    // 视频封面
    UIImageView *videoCoverImageView;
    
    // 点赞，评论，分享按钮
    UIButton *loveVideoButton;
    UIButton *commentVideoButton;
    UIButton *shareButton;
    
    
}

@end

@implementation LLASearchResultsVideoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        // 设置
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
    }
    return self;
}

- (void)initVariables
{
    
}

- (void)initSubViews
{
    // 用户
    userHead = [[LLAUserHeadView alloc] init];
    [self.contentView addSubview:userHead];
    
    userName = [[UILabel alloc] init];
    [self.contentView addSubview:userName];
    
    userDesLabel = [[UILabel alloc] init];
    [self.contentView addSubview:userDesLabel];
    
    watchTimesButton = [[UIButton alloc] init];
    [self.contentView addSubview:watchTimesButton];
    
    // 片酬
    rewardView = [[UIView alloc] init];;
    [self.contentView addSubview:rewardView];
    
    // 视频
    videoCoverImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:videoCoverImageView];
    
    // 点赞/评论/分享
    loveVideoButton = [[UIButton alloc] init];
    [self.contentView addSubview:loveVideoButton];
    
    commentVideoButton = [[UIButton alloc] init];
    [self.contentView addSubview:commentVideoButton];
    
    shareButton = [[UIButton alloc] init];;
    [self.contentView addSubview:shareButton];
    
    
}

- (void)initSubConstraints
{

}

@end
