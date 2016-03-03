//
//  LLAHotUsersTableViewCell.m
//  LLama
//
//  Created by tommin on 16/2/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHotUsersTableViewCell.h"



static const CGFloat nameLabelToHeadIcon = 10;
static const CGFloat detailLabelToHeadIcon = 10;
static const CGFloat attentionButtonToRight = 10;

#import "LLAUserHeadView.h"

@interface LLAHotUsersTableViewCell()
{
//    UIButton *headIcon;
    LLAUserHeadView *userHeadView;
    
    UILabel *nameLabel;
    
    UILabel *detailLabel;
    
    UIButton *attentionButton;
    
    UIView *bottomLine;
    
    UIImageView *sexImageView;
    
    // font
    UIFont *nameLabelTextFont;
    UIFont *detailLabelFont;
    
    // color
    UIColor *nameLabelColor;
    UIColor *detailLabelColor;
    UIColor *bottomLineColor;
}

@end

@implementation LLAHotUsersTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor colorWithHex:0x2c2a3a];
        // 设置
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
    }
    
    return self;
}

- (void)initVariables
{
    // font
    nameLabelTextFont = [UIFont systemFontOfSize:15];
    detailLabelFont = [UIFont systemFontOfSize:10];
    
    // color
    nameLabelColor = [UIColor whiteColor];
    detailLabelColor = [UIColor colorWithHex:0x656565];
    bottomLineColor = [UIColor blackColor];
    
}

- (void)initSubViews
{
//    // 头像
//    headIcon = [[UIButton alloc] init];
//    headIcon.translatesAutoresizingMaskIntoConstraints = NO;
//    [headIcon setImage:[UIImage imageNamed:@"userhead"] forState:UIControlStateNormal];
//    [self.contentView addSubview:headIcon];
    
    // 头像
    userHeadView = [[LLAUserHeadView alloc] init];
    userHeadView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:userHeadView];

    // 用户名
    nameLabel = [[UILabel alloc] init];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    nameLabel.font = nameLabelTextFont;
    nameLabel.textColor = nameLabelColor;
//    nameLabel.text = @"用户名";
    [self.contentView addSubview:nameLabel];
    
    // 详情说说
    detailLabel = [[UILabel alloc] init];
    detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    detailLabel.font = detailLabelFont;
    detailLabel.textColor = detailLabelColor;
//    detailLabel.text = @"我是一个好人";
    [self.contentView addSubview:detailLabel];

    // 性别
    sexImageView = [[UIImageView alloc] init];
    sexImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:sexImageView];
    
    // 关注按钮
    attentionButton = [[UIButton alloc] init];
    attentionButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [attentionButton setBackgroundImage:[UIImage imageNamed:@"search_hotUsers_unfollow"] forState:UIControlStateNormal];
//    [attentionButton setBackgroundImage:[UIImage imageNamed:@"search_hotUsers_follow"] forState:UIControlStateSelected];
    [attentionButton addTarget:self action:@selector(attentionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:attentionButton];
    
    // line
    bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = bottomLineColor;
    [self.contentView addSubview:bottomLine];
}
- (void)initSubConstraints
{
    [userHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@34);
        make.height.equalTo(@34);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);

    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userHeadView.mas_right).with.offset(nameLabelToHeadIcon);
        make.top.equalTo(userHeadView.mas_top);
        
    }];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(userHeadView.mas_bottom);
        make.left.equalTo(userHeadView.mas_right).with.offset(detailLabelToHeadIcon);
    }];
    
    [sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).with.offset(5);
        make.centerY.equalTo(nameLabel.mas_centerY);
        make.height.equalTo(nameLabel.mas_height).multipliedBy(0.6);
        make.width.equalTo(sexImageView.mas_height);
    }];
    
    [attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@91);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(- attentionButtonToRight);
        
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.equalTo(userHeadView.mas_right);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        
    }];
    
    

}

- (void)attentionButtonClick
{
    
    if ([self.delegate respondsToSelector:@selector(hotUsersTableViewCellDidSelectedAttentionButton:)]) {
        
        [self.delegate hotUsersTableViewCellDidSelectedAttentionButton:self];
    }
}
//- (void)updateCellWithInfo
//{
//    // 根据模型里面存储的状态是什么，根据状态来判断关注按钮显示什么，已关注/相互关注/点击关注；
//    
////    if (<#condition#>) {
////        <#statements#>
////    }
//}
- (void) updateCellWithInfo:(LLAHotUserInfo *) info tableWidth:(CGFloat) width
{
    
    [userHeadView updateHeadViewWithUser:info.hotUser];
    nameLabel.text = info.hotUser.userName;
    detailLabel.text = info.hotUser.userDescription;
    
    // 性别状态
    if (info.hotUser.gender == UserGender_Male) {
        [sexImageView setImage:[UIImage imageNamed:@"search_hotUsers_sexual-man"]];
    }else if (info.hotUser.gender == UserGender_Female){
        [sexImageView setImage:[UIImage imageNamed:@"search_hotUsers_sexual-woman"]];
    }
    
    // 关注按钮状态
    if (info.attentionType == LLAAttentionType_NotAttention) {
        [attentionButton setImage:[UIImage imageNamed:@"search_hotUsers_unfollow"] forState:UIControlStateNormal];
        attentionButton.userInteractionEnabled = YES;

    }else if (info.attentionType == LLAAttentionType_HasAttention){
        
        [attentionButton setImage:[UIImage imageNamed:@"search_hotUsers_follow"] forState:UIControlStateNormal];
        attentionButton.userInteractionEnabled = NO;

    }else if (info.attentionType == LLAAttentionType_AllAttention){
        
        [attentionButton setImage:[UIImage imageNamed:@"search_hotUsers_bothfollow"] forState:UIControlStateNormal];
        attentionButton.userInteractionEnabled = NO;
    }
    
    
}

@end
