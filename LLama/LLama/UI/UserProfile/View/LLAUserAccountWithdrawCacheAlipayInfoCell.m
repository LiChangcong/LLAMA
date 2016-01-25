//
//  LLAUserAccountWithdrawCacheAlipayInfoCell.m
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserAccountWithdrawCacheAlipayInfoCell.h"

static NSString *const arrowImageName = @"";

static const CGFloat toLeftSpace = 8;
static const CGFloat toRightSpace = 8;

@interface LLAUserAccountWithdrawCacheAlipayInfoCell()
{
    UILabel *alipayInfoLabel;
    
    UIImageView *arrowImageView;
    
    //
    UIFont *alipayInfoLabelFont;
    UIColor *alipayInfoLabelTextColor;
}

@end

@implementation LLAUserAccountWithdrawCacheAlipayInfoCell

#pragma mark - Init

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
    }
    return self;
}

- (void) initVariables {
    alipayInfoLabelFont = [UIFont llaFontOfSize:14];
    alipayInfoLabelTextColor = [UIColor colorWithHex:0x11111e];
}

- (void) initSubViews {
    alipayInfoLabel = [[UILabel alloc] init];
    alipayInfoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    alipayInfoLabel.font = alipayInfoLabelFont;
    alipayInfoLabel.textColor = alipayInfoLabelTextColor;
    alipayInfoLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:alipayInfoLabel];
    
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
      constraintsWithVisualFormat:@"V:|-(0)-[alipayInfoLabel]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(alipayInfoLabel)]];
    
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
      constraintsWithVisualFormat:@"H:|-(toLeft)-[alipayInfoLabel]-(4)-[arrowImageView]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(toLeftSpace),@"toLeft",@(toRightSpace),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(alipayInfoLabel,arrowImageView)]];
    
    [self.contentView addConstraints:constrArray];
    
    
}

@end
