//
//  LLAUserAccountBalanceCell.m
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserAccountBalanceCell.h"
#import "LLAUserHeadView.h"
#import "LLAUser.h"

static const CGFloat headViewHeightWidth = 90;
static const CGFloat headViewToTop = 40;

static const CGFloat balanceLabelToBottom = 20;
static const CGFloat balanceToBalaceTitle = 10;

@interface LLAUserAccountBalanceCell()<LLAUserHeadViewDelegate>
{
    LLAUserHeadView *headView;
    
    UILabel *balanceTitleLabel;
    UILabel *balanceLabel;
    
    //
    UIFont *balanceTitleLabelFont;
    UIColor *balanceTitleLabelTextColor;
    
    UIFont *balanceLabelFont;
    UIColor *balanceLabelTextColor;
    
}

@end

@implementation LLAUserAccountBalanceCell

#pragma mark - Init

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentView.backgroundColor = [UIColor colorWithHex:0x11111e];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
    }
    return self;
}

- (void) initVariables {
    
    balanceTitleLabelFont = [UIFont llaFontOfSize:13];
    balanceTitleLabelTextColor = [UIColor whiteColor];
    
    balanceLabelFont = [UIFont boldLLAFontOfSize:30];
    balanceLabelTextColor = [UIColor whiteColor];

    
}

- (void) initSubViews {
    
    headView = [[LLAUserHeadView alloc] init];
    headView.translatesAutoresizingMaskIntoConstraints = NO;
    headView.delegate = self;
    
    [self.contentView addSubview:headView];
    
    //
    balanceTitleLabel = [[UILabel alloc] init];
    balanceTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    balanceTitleLabel.font = balanceTitleLabelFont;
    balanceTitleLabel.textColor = balanceTitleLabelTextColor;
    balanceTitleLabel.textAlignment = NSTextAlignmentCenter;
    balanceTitleLabel.text = @"帐户余额";
    
    [self.contentView addSubview:balanceTitleLabel];
    
    //
    balanceLabel = [[UILabel alloc] init];
    balanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    balanceLabel.font = balanceLabelFont;
    balanceLabel.textColor = balanceLabelTextColor;
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:balanceLabel];
    
}

- (void) initSubConstraints {
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[headView(height)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(headViewToTop),@"toTop",
               @(headViewHeightWidth),@"height", nil]
      views:NSDictionaryOfVariableBindings(headView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[balanceTitleLabel]-(verSpace)-[balanceLabel]-(toBottom)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(balanceLabelToBottom),@"toBottom",
               @(balanceToBalaceTitle),@"verSpace", nil]
      views:NSDictionaryOfVariableBindings(balanceTitleLabel,balanceLabel)]];
    
    //
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:headView
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0
      constant:headViewHeightWidth]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:headView
      attribute:NSLayoutAttributeCenterX
      relatedBy:NSLayoutRelationEqual
      toItem:self.contentView
      attribute:NSLayoutAttributeCenterX
      multiplier:1.0
      constant:0]];
    
    //horizonal
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(8)-[balanceTitleLabel]-(8)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(balanceTitleLabel)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(8)-[balanceLabel]-(8)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(balanceLabel)]];
    
    [self.contentView addConstraints:constrArray];

    
    
}
#pragma mark - HeadView delegate

- (void) headView:(LLAUserHeadView *)headView clickedWithUserInfo:(LLAUser *)user {
    
}

#pragma mark - Update

- (void) updateCellWithUserInfo:(LLAUser *)userInfo tableWith:(CGFloat)tableWidth {
    
    [headView updateHeadViewWithUser:userInfo];
    
    balanceLabel.text = [NSString stringWithFormat:@"￥ %.2f",userInfo.balance];
    
}

#pragma mark - Calculate height

+ (CGFloat) calculateHeightWithUserInfo:(LLAUser *)userInfo tableWidth:(CGFloat)tableWidth {
    
    return 230;
    
}

@end
