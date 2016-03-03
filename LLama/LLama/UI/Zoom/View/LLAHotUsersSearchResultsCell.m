//
//  LLAHotUsersSearchResultsCell.m
//  LLama
//
//  Created by tommin on 16/2/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHotUsersSearchResultsCell.h"
#import "LLAUserHeadView.h"

@interface LLAHotUsersSearchResultsCell()
{
    UIImageView *arrowImageView;

    UIView *containerView;

    // font
    UIFont *hotUsersSearchResultsFont;
    
    // color
    UIColor *hotUsersSearchResultsColor;
    
    NSMutableArray<LLAUserHeadView *> *searchResultUsers_HeadImageArray;
    NSMutableArray<UILabel *> *searchResultUsers_UserNameArray;

}

@end

@implementation LLAHotUsersSearchResultsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.backgroundColor = [UIColor colorWithHex:0x1e1d28];
        self.backgroundColor = [UIColor clearColor];
    
        // 设置
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];

    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        
//
//    }
//    return self;
//}

- (void)initVariables
{
    hotUsersSearchResultsFont = [UIFont systemFontOfSize:12];
    hotUsersSearchResultsColor = [UIColor colorWithHex:0x807f87];
    
    searchResultUsers_UserNameArray = [NSMutableArray array];
    searchResultUsers_HeadImageArray = [NSMutableArray array];

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

    
    NSMutableArray *arr = [NSMutableArray array];
    
    CGFloat screenWidth =  [UIScreen mainScreen].bounds.size.width;
    
    // CGFloat num = (screenWidth- 25 )/(60);
    // 17:整体距离左边距离 。40，整体距离右边的距离。50,每个用户的宽度。20，间隙
    CGFloat num = (screenWidth - 17 - 40)/ (50 + 10);
    
    for (int i = 0 ; i < num; i++) {
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
        userNameLabel.font = hotUsersSearchResultsFont;
        userNameLabel.textColor = hotUsersSearchResultsColor;
        userNameLabel.text = @"Coolprice";
        [hotUserContentView addSubview:userNameLabel];
        [searchResultUsers_UserNameArray addObject:userNameLabel];
        
        LLAUserHeadView *headView = [[LLAUserHeadView alloc] init];
        [headView.userHeadImageView setImage:[UIImage imageNamed:@"userhead"]];
        [hotUserContentView addSubview:headView];
        [searchResultUsers_HeadImageArray addObject:headView];

        
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.centerY.equalTo(self.contentView.mas_centerY).with.offset(4);    }];
}

- (void)updateInfo
{
    
}

@end
