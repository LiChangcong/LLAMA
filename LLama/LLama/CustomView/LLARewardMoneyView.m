//
//  LLARewardMoneyView.m
//  LLama
//
//  Created by Live on 16/1/14.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLARewardMoneyView.h"

CGFloat videoRewardMoneyViewWidth = 78.0f;
CGFloat videoRewardMoneyViewHeight = 64.0f;

static NSString *const rewardBackImageName_Normal = @"actor_pay";
static NSString *const rewardBackImageName_High = @"actor_pay_red";

@interface LLARewardMoneyView()
{
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
        
        [self initVariables];
        [self initSubViews];
        self.contentMode = UIViewContentModeScaleToFill;
    }
    return self;
}

- (void) initVariables {
    showMoneyLabelFont = [UIFont llaFontOfSize:14];
    showMoneyLabelTextColor = [UIColor whiteColor];
}

- (void) initSubViews {
    
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
    //horizonal
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[showMoneyLabel]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(showMoneyLabel)]];
    
    [self addConstraints:constrArr];
    
}

#pragma mark - Update Info

- (void) updateViewWithRewardMoney:(NSInteger)money {
    
    showingMoney = money;
    
    if (showingMoney > 100) {
        [self setImage:[UIImage llaImageWithName:rewardBackImageName_Normal]];
    }else{
        [self setImage:[UIImage llaImageWithName:rewardBackImageName_High]];
    }
    
    //
    showMoneyLabel.text = [NSString stringWithFormat:@"%ld",showingMoney];
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
