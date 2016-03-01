//
//  LLAHotUsersCell.m
//  LLama
//
//  Created by tommin on 16/2/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHotUsersCell.h"

#import "LLAHotUsersCollectionView.h"
#import "LLAHotUsersButton.h"

#import "LLAUserHeadView.h"

#import "LLAHotUserInfo.h"

@interface LLAHotUsersCell()
{
    UIView *containerView;
    
    UILabel *hotUserLabel;
    
    UIImageView *arrowImageView;
    
    // font
    UIFont *hotUserFont;
    
    // color
    UIColor *hotUserColor;
    
}


@end

@implementation LLAHotUsersCell

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
    hotUserFont = [UIFont systemFontOfSize:12];
    hotUserColor = [UIColor colorWithHex:0x807f87];
}
- (void)initSubViews
{
    containerView = [[UIView alloc] init];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    containerView.contentMode = UIViewContentModeScaleAspectFill;
    containerView.clipsToBounds = YES;
    [self.contentView addSubview:containerView];
    
    
    arrowImageView = [[UIImageView alloc] init];
    arrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    arrowImageView.image = [UIImage imageNamed:@"search_cell_arrow"];
    arrowImageView.highlightedImage = [UIImage imageNamed:@"search_cell_arrowH"];
    [self.contentView addSubview:arrowImageView];


}

- (void)initSubConstraints
{
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.bottom.equalTo(self.contentView);
        
    }];
    
    
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(- 7);
        make.centerY.equalTo(self.contentView.mas_centerY).with.offset(4);
        
    }];
    
    
}

- (void) updateCellWithInfo:(NSMutableArray <LLAHotUserInfo *> *)info tableWidth:(CGFloat)width
{

    NSMutableArray *arr = [NSMutableArray array];
    
    CGFloat screenWidth =  [UIScreen mainScreen].bounds.size.width;
    
    // CGFloat num = (screenWidth- 25 )/(60);
    // 17:整体距离左边距离 。40，整体距离右边的距离。50,每个用户的宽度。10，每一个之间的间隙
    CGFloat num = (screenWidth - 17 - 40)/ (50 + 10);
    NSLog(@"%d,%d",info.count,(int)num);
    // 解决热门用户小于显示的个数时候崩溃问题
    int times = info.count > num ? num:info.count;
    for (int i = 0 ; i < times; i++) {
/*
        LLAHotUsersButton *hotUsersButton = [[LLAHotUsersButton alloc] init];
        [hotUsersButton setImage:[UIImage imageNamed:@"userhead"] forState:UIControlStateNormal];
        [hotUsersButton setTitle:@"Coolprice" forState:UIControlStateNormal];
        hotUsersButton.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:hotUsersButton];
        [arr addObject:hotUsersButton];
*/
        
        UIView *hotUserContentView = [[UIView alloc] init];
        [self.contentView addSubview:hotUserContentView];
        [arr addObject:hotUserContentView];

        UILabel *userNameLabel = [[UILabel alloc] init];
        userNameLabel.font = hotUserFont;
        userNameLabel.textColor = hotUserColor;
        userNameLabel.text = info[i].hotUser.userName;

        userNameLabel.textAlignment = NSTextAlignmentCenter;
        [hotUserContentView addSubview:userNameLabel];
        
        
        LLAUserHeadView *headView = [[LLAUserHeadView alloc] init];
        headView.translatesAutoresizingMaskIntoConstraints = NO;
        [headView updateHeadViewWithUser:info[i].hotUser];
        [hotUserContentView addSubview:headView];

        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@34);
            make.top.equalTo(hotUserContentView).with.offset(5);
            make.centerX.equalTo(hotUserContentView);
        }];
        
        [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(hotUserContentView.mas_left);
            make.right.equalTo(hotUserContentView.mas_right);
            make.top.equalTo(headView.mas_bottom).with.offset(5);
        }];

    }
    

    
    
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:17 tailSpacing:40];
    
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@0);
        make.height.equalTo(@60);
        
    }];

}
@end
