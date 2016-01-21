//
//  LLARewardMoneyView.m
//  LLama
//
//  Created by Live on 16/1/14.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLARewardMoneyView.h"

CGFloat videoRewardMoneyViewWidth = 78.0f;
CGFloat videoRewardMoneyViewHeight = 55.0f;

static NSString *const rewardBackImageName_Normal = @"actor_pay";
static NSString *const rewardBackImageName_High = @"actor_pay_red";

static const CGFloat currencyLabelHeight = 18;

@interface LLARewardMoneyView()
{
    // 片酬
    UILabel *currencyLabel;
    UIFont *currencyFont;
    UIColor *currencyNormalTextColor;
    UIColor *currencyHighTextColor;
    
    // 金额
    UILabel *showMoneyLabel;
    UIFont *showMoneyLabelFont;
    UIColor *showMoneyLabelTextColor;
}

@property(nonatomic , readwrite , assign) NSInteger showingMoney;

@end

@implementation LLARewardMoneyView

@synthesize showingMoney;

#pragma mark - Init

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // 设置变量
        [self initVariables];
        // 设置子控件
        [self initSubViews];
        self.contentMode = UIViewContentModeScaleToFill;
    }
    return self;
}

- (void) initVariables {
    
    currencyFont = [UIFont systemFontOfSize:12.5];
    currencyNormalTextColor = [UIColor themeColor];
    currencyHighTextColor = [UIColor colorWithHex:0xfd4646];
    
    showMoneyLabelFont = [UIFont boldLLAFontOfSize:15];
    showMoneyLabelTextColor = [UIColor colorWithHex:0x11111e];
}

- (void) initSubViews {
    
    currencyLabel = [[UILabel alloc] init];
    currencyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    currencyLabel.font = currencyFont;
    currencyLabel.textColor = currencyNormalTextColor;
    currencyLabel.textAlignment = NSTextAlignmentCenter;
    currencyLabel.text = @"片酬(元)";
    
    [self addSubview:currencyLabel];
    
    //
    showMoneyLabel = [[UILabel alloc] init];
    showMoneyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    showMoneyLabel.font = showMoneyLabelFont;
    showMoneyLabel.textColor = showMoneyLabelTextColor;
    showMoneyLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:showMoneyLabel];
    
    //constraints
    NSMutableArray *constrArr = [NSMutableArray array];
    
    //vertical
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:showMoneyLabel
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:currencyLabel
      attribute:NSLayoutAttributeTop
      relatedBy:NSLayoutRelationEqual
      toItem:self
      attribute:NSLayoutAttributeTop
      multiplier:1.0
      constant:0]];
    
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:currencyLabel
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0
      constant:currencyLabelHeight]];
    
    //horizonal
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[showMoneyLabel]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(showMoneyLabel)]];
    
    [self addConstraints:constrArr];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[currencyLabel]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(currencyLabel)]];
    
    [self addConstraints:constrArr];
    
}

#pragma mark - Update Info

- (void) updateViewWithRewardMoney:(NSInteger)money {
    
    showingMoney = money;
    
    if (showingMoney >= 100) {
        [self setImage:[UIImage llaImageWithName:rewardBackImageName_High]];
        currencyLabel.textColor = currencyHighTextColor;
    }else{
        [self setImage:[UIImage llaImageWithName:rewardBackImageName_Normal]];
        currencyLabel.textColor = currencyNormalTextColor;
    }
    
    //
    showMoneyLabel.text = [NSString stringWithFormat:@"%ld",(long)showingMoney];
    showMoneyLabel.adjustsFontSizeToFitWidth = YES;
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
