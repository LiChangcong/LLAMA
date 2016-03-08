//
//  LLAInviteToActCell.m
//  LLama
//
//  Created by tommin on 16/3/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAInviteToActCell.h"

#import "LLAUserHeadView.h"


static const CGFloat nameLabelToHeadIcon = 10;
static const CGFloat detailLabelToHeadIcon = 10;

@interface LLAInviteToActCell() <LLAUserHeadViewDelegate>
{
    LLAUserHeadView *userHeadView;
    
    UILabel *nameLabel;
    
    UILabel *detailLabel;
    
    UIButton *selectdButton;
    
    // font
    UIFont *nameLabelTextFont;
    UIFont *detailLabelFont;
    
    // color
    UIColor *nameLabelColor;
    UIColor *detailLabelColor;
    UIColor *bottomLineColor;


}
@end

@implementation LLAInviteToActCell


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
    userHeadView = [[LLAUserHeadView alloc] init];
    userHeadView.translatesAutoresizingMaskIntoConstraints = NO;
    userHeadView.delegate = self;
//    [userHeadView.];
    [self.contentView addSubview:userHeadView];

    
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
    
    selectdButton = [[UIButton alloc] init];
    [selectdButton setImage:[UIImage imageNamed:@"publish_choseactordot"]  forState:UIControlStateNormal];
    [selectdButton setImage:[UIImage imageNamed:@"publish_chosepicdoth"]  forState:UIControlStateSelected];
    [selectdButton addTarget:self action:@selector(selectedButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:selectdButton];
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
//        make.right.equalTo(attentionButton.mas_left).with.offset(5);
    }];
    
    [selectdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
    }];


}

- (void)selectedButtonClick
{
    if ([self.delegate respondsToSelector:@selector(inviteToActCellDidSelectedSelectButton:withIndexPath:)]) {
        [self.delegate inviteToActCellDidSelectedSelectButton:self withIndexPath:self.indexPath];
    }
}

- (void)headView:(LLAUserHeadView *)headView clickedWithUserInfo:(LLAUser *)user
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userHeadViewTapped:)]) {
        [self.delegate userHeadViewTapped:user];
    }

}

- (void) updateCellWithInfo:(LLAInviteToActInfo *) info tableWidth:(CGFloat) width
{
    [userHeadView updateHeadViewWithUser:info.inviteUser];
    nameLabel.text = info.inviteUser.userName;
    detailLabel.text = info.inviteUser.userDescription;
    selectdButton.selected = info.selected;
}


@end
