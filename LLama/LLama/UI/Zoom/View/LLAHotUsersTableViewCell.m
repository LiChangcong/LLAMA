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


@interface LLAHotUsersTableViewCell()
{
    UIButton *headIcon;
    
    UILabel *nameLabel;
    
    UILabel *detailLabel;
    
    UIButton *attentionButton;
    
    UIView *bottomLine;
    
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
    // 头像
    headIcon = [[UIButton alloc] init];
    headIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [headIcon setImage:[UIImage imageNamed:@"userhead"] forState:UIControlStateNormal];
    [self.contentView addSubview:headIcon];

    // 用户名
    nameLabel = [[UILabel alloc] init];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    nameLabel.font = nameLabelTextFont;
    nameLabel.textColor = nameLabelColor;
    nameLabel.text = @"用户名";
    [self.contentView addSubview:nameLabel];
    
    // 详情说说
    detailLabel = [[UILabel alloc] init];
    detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    detailLabel.font = detailLabelFont;
    detailLabel.textColor = detailLabelColor;
    detailLabel.text = @"我是一个好人";
    [self.contentView addSubview:detailLabel];

    // 关注按钮
    attentionButton = [[UIButton alloc] init];
    attentionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [attentionButton setBackgroundImage:[UIImage imageNamed:@"search_hotUsers_unfollow"] forState:UIControlStateNormal];
    [attentionButton setBackgroundImage:[UIImage imageNamed:@"search_hotUsers_follow"] forState:UIControlStateSelected];
    [self.contentView addSubview:attentionButton];
    
    // line
    bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = bottomLineColor;
    [self.contentView addSubview:bottomLine];
}
- (void)initSubConstraints
{
    [headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@34);
        make.height.equalTo(@34);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);

    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headIcon.mas_right).with.offset(nameLabelToHeadIcon);
        make.top.equalTo(headIcon.mas_top);
        
    }];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headIcon.mas_bottom);
        make.left.equalTo(headIcon.mas_right).with.offset(detailLabelToHeadIcon);
    }];
    
    [attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@91);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(- attentionButtonToRight);
        
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.equalTo(headIcon.mas_right);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        
    }];
    

}
@end
