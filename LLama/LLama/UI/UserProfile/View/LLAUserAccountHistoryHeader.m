//
//  LLAUserAccountHistoryHeader.m
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserAccountHistoryHeader.h"

static const CGFloat labelToVerBorder = 14;
static const CGFloat labelToHorBorder = 10;

static const CGFloat labelHeight = 20;

@interface LLAUserAccountHistoryHeader()

{
    UILabel *historyLabel;
    
    UIFont *historyLabelFont;
    UIColor *historyLabelTextColor;
}

@end

@implementation LLAUserAccountHistoryHeader

- (instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHex:0xeaeaea];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self initVariables];
        [self initSubViews];
        [self initSubContraints];
        
    }
    return self;
}

- (void) initVariables {
    historyLabelFont = [UIFont llaFontOfSize:15];
    historyLabelTextColor = [UIColor colorWithHex:0xb7b7b7];
}

- (void) initSubViews {
    
    historyLabel = [[UILabel alloc] init];
    historyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    historyLabel.font = historyLabelFont;
    historyLabel.textColor = historyLabelTextColor;
    historyLabel.text = @"历史明细";
    historyLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:historyLabel];
    
}

- (void) initSubContraints {
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toBorder)-[historyLabel]-(toBorder)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(labelToVerBorder),@"toBorder", nil]
      views:NSDictionaryOfVariableBindings(historyLabel)]];
    
    //horizonal
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toBorder)-[historyLabel]-(toBorder)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(labelToHorBorder),@"toBorder", nil]
      views:NSDictionaryOfVariableBindings(historyLabel)]];
    
    [self.contentView addConstraints:constrArray];
}

+ (CGFloat) calculateHeaderHeight {
    return labelHeight + 2*labelToVerBorder;
}

@end
