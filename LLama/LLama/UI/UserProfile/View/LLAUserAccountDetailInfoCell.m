//
//  LLAUserAccountDetailInfoCell.m
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserAccountDetailInfoCell.h"

#import "LLAUserAccountDetailItemInfo.h"

static const CGFloat contentHeight = 63.5;
static const CGFloat lineHeight = 0.5;

static const CGFloat timeToLeft = 4;
static const CGFloat timeToConentHorSpace = 10;
static const CGFloat contentToMoneyHorSpace = 10;
static const CGFloat moneyToRight = 10;

@interface LLAUserAccountDetailInfoCell()
{
    UILabel *timeAndTypeLabel;
    UILabel *contentLabel;
    UILabel *moneyLabel;
    
    UIView *sepLine;
    
    //
    UIFont *timeAndTypeLabelFont;
    UIColor *timeAndTypeLabelTextColor;
    
    UIFont *contentLabelFont;
    UIColor *contentLabelTextColor;
    
    UIFont *moneyLabelFont;
    UIColor *moneyLabelPayTextColor;
    UIColor *moneyLabelRewardTextColor;
    UIColor *moneyLabelWithdrawCashTextColor;
    
    UIColor *lineColor;
    
    //
    LLAUserAccountDetailItemInfo *currentInfo;
    
}

@end

@implementation LLAUserAccountDetailInfoCell

#pragma mark - Init

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
    }
    
    return self;
    
}

- (void) initVariables {
    
    timeAndTypeLabelFont = [UIFont llaFontOfSize:14];
    timeAndTypeLabelTextColor = [UIColor colorWithHex:0x11111e];
    
    contentLabelFont = [UIFont llaFontOfSize:14];
    contentLabelTextColor = [UIColor colorWithHex:0x11111e];
    
    moneyLabelFont = [UIFont llaFontOfSize:18];
    moneyLabelPayTextColor = [UIColor colorWithHex:0x11111e];
    moneyLabelRewardTextColor = [UIColor colorWithHex:0xf94848];
    moneyLabelWithdrawCashTextColor = [UIColor colorWithHex:0x196eaf];
    
    lineColor = [UIColor colorWithHex:0xebebeb];
    
}

- (void) initSubViews {
    
    timeAndTypeLabel = [[UILabel alloc] init];
    timeAndTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    timeAndTypeLabel.font = timeAndTypeLabelFont;
    timeAndTypeLabel.textColor = timeAndTypeLabelTextColor;
    timeAndTypeLabel.numberOfLines = 2;
    
    [self.contentView addSubview:timeAndTypeLabel];
    
    //
    contentLabel = [[UILabel alloc] init];
    contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    contentLabel.font = contentLabelFont;
    contentLabel.textColor = contentLabelTextColor;
    contentLabel.numberOfLines = 0;
    
    [self.contentView addSubview:contentLabel];
    
    //
    moneyLabel = [[UILabel alloc] init];
    moneyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    moneyLabel.font = moneyLabelFont;
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:moneyLabel];
    
    //
    sepLine = [[UIView alloc] init];
    sepLine.translatesAutoresizingMaskIntoConstraints = NO;
    sepLine.backgroundColor = lineColor;
    
    [self.contentView addSubview:sepLine];
}

- (void) initSubConstraints {
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[timeAndTypeLabel]-(0)-[sepLine(height)]-(0)-|" options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(lineHeight),@"height", nil]
      views:NSDictionaryOfVariableBindings(timeAndTypeLabel,sepLine)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[contentLabel]-(0)-[sepLine]" options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(contentLabel,sepLine)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[moneyLabel]-(0)-[sepLine]" options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(moneyLabel,sepLine)]];
    
    //horizonal
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[timeAndTypeLabel]-(timeToContent)-[contentLabel]-(contentToMoney)-[moneyLabel]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(timeToLeft),@"toLeft",
               @(timeToConentHorSpace),@"timeToContent",
               @(contentToMoneyHorSpace),@"contentToMoney",
               @(moneyToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(timeAndTypeLabel,contentLabel,moneyLabel)]];
    
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[sepLine]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(sepLine)]];
    
    [self.contentView addConstraints:constrArray];
    
    [timeAndTypeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [contentLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [moneyLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
}

#pragma mark - Update

- (void) updateCellWithItemInfo:(LLAUserAccountDetailItemInfo *)info tableWidth:(CGFloat)tableWidth {
    
    currentInfo = info;
    
    //
    timeAndTypeLabel.text = [NSString stringWithFormat:@"%@\n%@",currentInfo.manaTimeString,[LLAUserAccountDetailItemInfo transactionDescFromType:currentInfo.transactionType]];
    
    contentLabel.text = currentInfo.accountManaContent;
    
    if (currentInfo.transactionType == LLAUserAccounTransactionType_WithdrawCashSuccess) {
        moneyLabel.textColor = moneyLabelWithdrawCashTextColor;
    }else if (currentInfo.transactionType == LLAUserAccounTransactionType_BalanceIncom) {
        moneyLabel.textColor = moneyLabelRewardTextColor;
    }else {
        moneyLabel.textColor = moneyLabelPayTextColor;
    }
    
    //money
    if (currentInfo.manaMoney > 0) {
        moneyLabel.text = [NSString stringWithFormat:@"+%.0f",currentInfo.manaMoney];
    }else {
        moneyLabel.text = [NSString stringWithFormat:@"-%.0f",fabs(currentInfo.manaMoney)];
    }
    
}

#pragma mark - Calculate Height

+ (CGFloat) calculateHeightWithItemInfo:(LLAUserAccountDetailItemInfo *)info tableWidth:(CGFloat)tableWidth {
    return contentHeight + lineHeight;
}

@end
