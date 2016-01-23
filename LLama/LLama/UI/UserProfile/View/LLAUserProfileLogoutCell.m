//
//  LLAUserProfileLogoutCell.m
//  LLama
//
//  Created by Live on 16/1/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserProfileLogoutCell.h"

static const CGFloat logoutButtonToHorBorder = 16;

@interface LLAUserProfileLogoutCell()
{
    UIButton *logoutButton;
    
    UIFont *logoutButtonFont;
    UIColor *logoutButtonNormalTextColor;
    
    UIColor *logoutButtonNormalBackColor;
}

@end

@implementation LLAUserProfileLogoutCell

@synthesize delegate;

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentView.backgroundColor = [UIColor colorWithHex:0xededed];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
        
    }
    
    return self;
}

- (void) initVariables {
    
    logoutButtonFont = [UIFont llaFontOfSize:16];
    
    logoutButtonNormalTextColor = [UIColor colorWithHex:0x11111e];
    
    logoutButtonNormalBackColor = [UIColor themeColor];
}

- (void) initSubViews {
    
    logoutButton = [UIButton new];
    logoutButton.translatesAutoresizingMaskIntoConstraints = NO;
    logoutButton.titleLabel.font = logoutButtonFont;
    logoutButton.clipsToBounds = YES;
    logoutButton.layer.cornerRadius = 6;
    
    [logoutButton setTitle:@"登  出" forState:UIControlStateNormal];
    
    [logoutButton setTitleColor:logoutButtonNormalTextColor forState:UIControlStateNormal];
    [logoutButton setBackgroundColor:logoutButtonNormalBackColor forState:UIControlStateNormal];
    
    [logoutButton addTarget:self action:@selector(logoutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:logoutButton];
    
}

- (void) initSubConstraints {
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[logoutButton]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(logoutButton)]];
    //horizonal
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toBorder)-[logoutButton]-(toBorder)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(logoutButtonToHorBorder),@"toBorder", nil]
      views:NSDictionaryOfVariableBindings(logoutButton)]];
    
    [self.contentView addConstraints:constrArray];
}

#pragma mark - ButtonClick

- (void) logoutButtonClicked:(UIButton *) sender {
    if (delegate && [delegate respondsToSelector:@selector(logoutCurrentUser)]) {
        [delegate logoutCurrentUser];
    }
}

#pragma mark - CalculateHeight

+ (CGFloat) calculateHeight {
    return 56;
}

@end
