//
//  LLAInviteView.m
//  LLama
//
//  Created by tommin on 16/3/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAInviteView.h"

#import "LLAUserHeadView.h"

@interface LLAInviteView()
{
    UILabel *inviteLabel;
    
    UIColor *inviteLabelColor;
    UIFont *inviteLabelFont;
    
    NSArray *inviteUsersArray;
    
    CGFloat num;
    
    NSMutableArray<LLAUserHeadView *> *headImageArray;


}
@end

@implementation LLAInviteView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHex:0x2c2a3a];
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
    };
    
    return self;
}

- (void)initVariables
{
    inviteLabelColor = [UIColor colorWithHex:0x8e8d91];
    inviteLabelFont = [UIFont systemFontOfSize:14];
    
    headImageArray = [NSMutableArray array];
}

- (void)initSubViews
{
    inviteLabel = [[UILabel alloc] init];
    inviteLabel.text = @"邀请出演：";
    inviteLabel.textColor = inviteLabelColor;
    inviteLabel.font = inviteLabelFont;
    [self addSubview:inviteLabel];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    CGFloat screenWidth =  [UIScreen mainScreen].bounds.size.width;
    
    // 80:整体距离左边距离 。40，整体距离右边的距离。50,每个用户的宽度。10，每一个之间的间隙
    num = (screenWidth - 100 - 40)/ (23 + 10);

    for (int i = 0 ; i < num; i++) {
        
        UIView *contentView = [[UIView alloc] init];
//        contentView.backgroundColor = [UIColor redColor];
        [self addSubview:contentView];
        [arr addObject:contentView];

        
        LLAUserHeadView *headView = [[LLAUserHeadView alloc] init];
//        [headView.userHeadImageView setImage:[UIImage imageNamed:@"userhead"]];

        headView.translatesAutoresizingMaskIntoConstraints = NO;
//        headView.delegate = self;
        [contentView addSubview:headView];
        [headImageArray addObject:headView];
        
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@23);
            make.centerY.equalTo(contentView);
//            make.top.equalTo(contentView);
            make.centerX.equalTo(contentView);
        }];
        
    }
    
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:100 tailSpacing:40];
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.top.equalTo(@0);
        make.centerY.equalTo(self);
        make.height.equalTo(@23);
        
    }];
    
}

- (void)initSubConstraints
{
    [inviteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@20);
        
    }];

}

- (void)updateInfoWithInfoArray:(NSArray *)infoArray
{
    
    inviteUsersArray = infoArray;
    self.inviteUsersArray = infoArray;
    //
    for (int i = 0; i < num; i++) { // i < hotUsers_UserNameArray.count建设传来的数据没有铺满屏幕，会崩溃
        //
        
        if (i < inviteUsersArray.count) {
            

            headImageArray[i].userInteractionEnabled = YES;
//            headImageArray[i].backgroundColor = [UIColor redColor];
            [headImageArray[i] updateHeadViewWithUser:inviteUsersArray[i]];
            
//            [headImageArray[i].userHeadImageView setImage:[UIImage imageNamed:@"userhead"]];
            
        }else{
            
            [headImageArray[i] updateHeadViewWithUser:nil];
            headImageArray[i].userInteractionEnabled = NO;
            
        }
    }
    


}


@end
