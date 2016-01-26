//
//  LLAUserAccountWithdrawCashCellPhoneInfoCell.m
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserAccountWithdrawCashCellPhoneInfoCell.h"

#import "LLAUser.h"

static NSString *const arrowImageName = @"arrowgreg";

static const CGFloat toLeftSpace = 8;
static const CGFloat toRightSpace = 8;

@interface LLAUserAccountWithdrawCashCellPhoneInfoCell()
{
    UILabel *cellPhoneInfoLabel;
    
    UIImageView *arrowImageView;
    
    //
    UIFont *cellPhoneInfoLabelFont;
    UIColor *cellPhoneInfoLabelTextColor;
}

@end

@implementation LLAUserAccountWithdrawCashCellPhoneInfoCell

#pragma mark - Init

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentView.backgroundColor = [UIColor whiteColor];
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
    }
    return self;
}

- (void) initVariables {
    cellPhoneInfoLabelFont = [UIFont llaFontOfSize:14];
    cellPhoneInfoLabelTextColor = [UIColor colorWithHex:0x11111e];
}

- (void) initSubViews {
    
    cellPhoneInfoLabel = [[UILabel alloc] init];
    cellPhoneInfoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    cellPhoneInfoLabel.font = cellPhoneInfoLabelFont;
    cellPhoneInfoLabel.textColor = cellPhoneInfoLabelTextColor;
    cellPhoneInfoLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:cellPhoneInfoLabel];
    
    arrowImageView = [[UIImageView alloc] init];
    arrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    arrowImageView.image = [UIImage imageNamed:arrowImageName];
    
    [self.contentView addSubview:arrowImageView];

    
}

- (void) initSubConstraints {
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertcial
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[cellPhoneInfoLabel]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(cellPhoneInfoLabel)]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:arrowImageView
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self.contentView
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    //horizoal
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[cellPhoneInfoLabel]-(4)-[arrowImageView]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(toLeftSpace),@"toLeft",@(toRightSpace),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(cellPhoneInfoLabel,arrowImageView)]];
    
    [self.contentView addConstraints:constrArray];
    
}

#pragma mark - Update

- (void) updateCellWithUserInfo:(LLAUser *)userInfo {
    
    if (userInfo.mobilePhone) {
        cellPhoneInfoLabel.text = [NSString stringWithFormat:@"已绑定手机号：%@",userInfo.mobilePhone];
    }else {
        cellPhoneInfoLabel.text = @"还未绑定手机号";
    }
    
}

#pragma mark - Calculate height

+ (CGFloat) calculateHeightWithUserInfo:(LLAUser *)userInfo tableWidth:(CGFloat)tableWidth {
    return  52;
}

@end
