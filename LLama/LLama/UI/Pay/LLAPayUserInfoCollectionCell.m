//
//  LLAPayUserInfoCollectionCell.m
//  LLama
//
//  Created by Live on 16/1/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAPayUserInfoCollectionCell.h"

#import "LLAPayUserPayInfo.h"

static const CGFloat userImageViewHeightWidth = 290;

static const CGFloat userImageViewToInfoLabelVerSpace = 10;

@interface LLAPayUserInfoCollectionCell()
{
    UIImageView *userImageView;
    
    UILabel *payInfoLabel;
    
    //
    UIFont *payInfoLabelFont;
    UIColor *payInfoLabelTextColor;
}

@end

@implementation LLAPayUserInfoCollectionCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];

    }
    return self;
}

- (void) initVariables {
    payInfoLabelFont = [UIFont llaFontOfSize:17];
    payInfoLabelTextColor = [UIColor colorWithHex:0x11111e];
}

- (void) initSubViews {
    
    userImageView = [[UIImageView alloc] init];
    userImageView.translatesAutoresizingMaskIntoConstraints = NO;
    userImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.contentView addSubview:userImageView];
    
    payInfoLabel = [[UILabel alloc] init];
    payInfoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    payInfoLabel.font = payInfoLabelFont;
    payInfoLabel.textColor = payInfoLabelTextColor;
    payInfoLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:payInfoLabel];
    
}

- (void) initSubConstraints {
    
    //
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[userImageView(imageHeight)]-(imageToLabel)-[payInfoLabel]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"imageHeight":@(userImageViewHeightWidth),
                @"imageToLabel":@(userImageViewToInfoLabelVerSpace)}
      views:NSDictionaryOfVariableBindings(userImageView,payInfoLabel)]];
    
    //horizonal
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[userImageView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(userImageView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[payInfoLabel]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(payInfoLabel)]];
    
    [self addConstraints:constrArray];
    
}

#pragma mark - Update

- (void) updateCellWithPayInfo:(LLAPayUserPayInfo *)payInfo {
    
    [userImageView setImageWithURL:[NSURL URLWithString:payInfo.payToUser.headImageURL] placeholderImage:[UIImage llaImageWithName:@"placeHolder_1080"]];
    payInfoLabel.text = [NSString stringWithFormat:@"支付给%@%.0f元片酬",payInfo.payToUser.userName,payInfo.payMoney];
    
}

#pragma mark - Calculate Height

+ (CGFloat) calculateHeightWithPayInfo:(LLAPayUserPayInfo *)payInfo tableWidth:(CGFloat)tableWidth {
    return userImageViewHeightWidth + 30;
}

@end
