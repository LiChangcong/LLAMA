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

@interface LLAHotUsersCell()
{
    UIView *containerView;
    
    UILabel *hotUserLabel;
    
//    LLAHotUsersCollectionView *hotUsersCollectionView;
    UIImageView *arrowImageView;
    
//    LLAHotUsersButton *hotUsersButton;
    
    UIFont *hotUserFont;
    UIColor *hotUserColor;
    
}

//@property(nonatomic, strong) NSMutableArray *arr;

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
//    containerView.backgroundColor = [UIColor redColor];
    containerView.backgroundColor = [UIColor yellowColor];
    containerView.contentMode = UIViewContentModeScaleAspectFill;
    containerView.clipsToBounds = YES;
    [self.contentView addSubview:containerView];
    
//    hotUserLabel = [[UILabel alloc] init];
//    hotUserLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    hotUserLabel.contentMode = UIViewContentModeScaleAspectFill;
//    hotUserLabel.clipsToBounds = YES;
//    hotUserLabel.text = @"热门用户";
//    hotUserLabel.textColor = hotUserColor;
//    [hotUserLabel setFont:hotUserFont];
//    [self.contentView addSubview:hotUserLabel];
    
    arrowImageView = [[UIImageView alloc] init];
    arrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    arrowImageView.image = [UIImage imageNamed:@"search_cell_arrow"];
    arrowImageView.highlightedImage = [UIImage imageNamed:@"search_cell_arrowH"];
    [self.contentView addSubview:arrowImageView];

    
    
//    hotUsersButton = [[LLAHotUsersButton alloc] init];
//    hotUsersButton.translatesAutoresizingMaskIntoConstraints = NO;
//    hotUsersButton.backgroundColor = [UIColor redColor];
//    hotUsersButton.frame = CGRectMake(80, 0, 50, 50);
//    [self.contentView addSubview:hotUsersButton];

}

- (void)initSubConstraints
{
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.bottom.equalTo(self.contentView);
        
    }];
    
//    [hotUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).with.offset(7);
//        make.left.equalTo(self.contentView).with.offset(17);
//        
//    }];
    
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(- 7);
        make.centerY.equalTo(self.contentView.mas_centerY).with.offset(4);
        
    }];
    
    
}

- (void)updateInfo
{
    //    hotUsersCollectionView = [[LLAHotUsersCollectionView alloc] initWithFrame:<#(CGRect)#> collectionViewLayout:<#(nonnull UICollectionViewLayout *)#>];
    NSMutableArray *arr = [NSMutableArray array];
    
    CGFloat screenWidth =  [UIScreen mainScreen].bounds.size.width;
    CGFloat num = (screenWidth- 25 )/(60);
    for (int i = 0 ; i < num; i++) {
        LLAHotUsersButton *hotUsersButton = [[LLAHotUsersButton alloc] init];
        //        hotUsersButton.translatesAutoresizingMaskIntoConstraints = NO;
        [hotUsersButton setImage:[UIImage imageNamed:@"userhead"] forState:UIControlStateNormal];
        [hotUsersButton setTitle:@"Coolprice" forState:UIControlStateNormal];
        hotUsersButton.backgroundColor = [UIColor redColor];
        //        hotUsersButton.frame = CGRectMake((50 +20)*i, 0, 0, 0);
        [self.contentView addSubview:hotUsersButton];
        [arr addObject:hotUsersButton];
        

    }
    

    
//    [arr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:20 leadSpacing:5 tailSpacing:5];
    
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:17 tailSpacing:40];
    
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(self.contentView);
//        make.width.equalTo(@40);

        make.top.equalTo(@0);
        make.height.equalTo(@60);
        
    }];

}
@end
