//
//  LLAUserAccountWithdrawCashCellPhoneInfoCell.m
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserAccountWithdrawCashCellPhoneInfoCell.h"

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
    
}

- (void) initSubConstraints {
    
}

@end
