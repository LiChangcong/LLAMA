//
//  LLASoicalSharePlatformCell.m
//  LLama
//
//  Created by Live on 16/2/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLASoicalSharePlatformCell.h"
#import "LLASocialSharePlatformItem.h"

static const CGFloat platformImageViewToLabelVerSpace = 12;
static const CGFloat platformLabelHeight = 16;

@interface LLASoicalSharePlatformCell()
{
    UIButton *backControl;
    
    UIImageView *platformImageView;
    UILabel *platformLabel;
    
    //
    UIColor *backControlNormalColor;
    UIColor *backControlHighlightColor;
    
    UIFont *platformLabelFont;
    UIColor *platformLabelNormalTextColor;
    UIColor *platformLabelHighlightTextColor;
    
    //
    LLASocialSharePlatformItem *currentPlatformInfo;
}

@end

@implementation LLASoicalSharePlatformCell
@synthesize delegate;

#pragma mark - Init

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self initVariables];
        [self initViews];
    }
    return self;
}

- (void) initVariables {
    
    backControlNormalColor = [UIColor whiteColor];
    backControlHighlightColor = [UIColor whiteColor];
    
    platformLabelFont = [UIFont llaFontOfSize:13];
    platformLabelNormalTextColor = [UIColor colorWithHex:0x11111e];
    platformLabelHighlightTextColor = [UIColor themeColor];
    
}

- (void) initViews {
    
    backControl = [[UIButton alloc] init];
    backControl.translatesAutoresizingMaskIntoConstraints = NO;
    backControl.backgroundColor = backControlNormalColor;
    
    [backControl addTarget:self action:@selector(platformTouchDown:) forControlEvents:UIControlEventTouchDown];
    [backControl addTarget:self action:@selector(platformTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [backControl addTarget:self action:@selector(platformTouchOutSideUp:) forControlEvents:UIControlEventTouchUpOutside];
    [backControl addTarget:self action:@selector(platformTouchCancel:) forControlEvents:UIControlEventTouchCancel];
    
    [self.contentView addSubview:backControl];
    
    //
    [self.contentView addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[backControl]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(backControl)]];
    
    [self.contentView addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[backControl]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(backControl)]];
    
    //view on control
    
    platformImageView = [[UIImageView alloc] init];
    platformImageView.translatesAutoresizingMaskIntoConstraints = NO;
    //platformImageView.contentMode = UIViewContentModeScaleAspectFill;
    platformImageView.clipsToBounds = YES;
    platformImageView.userInteractionEnabled = NO;
    
    [backControl addSubview:platformImageView];
    
    platformLabel = [[UILabel alloc] init];
    platformLabel.translatesAutoresizingMaskIntoConstraints = NO;
    platformLabel.font = platformLabelFont;
    platformLabel.textColor = platformLabelNormalTextColor;
    platformLabel.highlightedTextColor = platformLabelHighlightTextColor;
    platformLabel.textAlignment = NSTextAlignmentCenter;
    platformLabel.userInteractionEnabled = NO;
    
    [backControl addSubview:platformLabel];
    
    //constraints
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:platformImageView
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:backControl
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:-(platformImageViewToLabelVerSpace+platformLabelHeight)/2]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[platformImageView]-(imageToLabel)-[platformLabel(labelHeight)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"imageToLabel":@(platformImageViewToLabelVerSpace),
                @"labelHeight":@(platformLabelHeight)}
      views:NSDictionaryOfVariableBindings(platformImageView,platformLabel)]];
    
    //
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:platformImageView
      attribute:NSLayoutAttributeCenterX
      relatedBy:NSLayoutRelationEqual
      toItem:backControl
      attribute:NSLayoutAttributeCenterX
      multiplier:1.0
      constant:0]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[platformLabel]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(platformLabel)]];
    
    [backControl addConstraints:constrArray];
    
    
}

#pragma mark - UIControl Event

- (void) platformTouchDown:(UIControl *) sender {
    platformImageView.highlighted = YES;
    platformLabel.highlighted  = YES;
}

- (void) platformTouchOutSideUp:(id ) sender {
    platformImageView.highlighted = NO;
    platformLabel.highlighted = NO;
}

- (void) platformTouchCancel:(UIControl *) sender {
    platformImageView.highlighted = NO;
    platformLabel.highlighted = NO;
}

- (void) platformTouchUp:(id) sender {
    platformImageView.highlighted = NO;
    platformLabel.highlighted  = NO;
    
    //call
    if (delegate && [delegate respondsToSelector:@selector(shareWithPlatformInfo:)]) {
        [delegate shareWithPlatformInfo:currentPlatformInfo];
    }
}

#pragma mark - Update

- (void) updateCellWithPlatformInfo:(LLASocialSharePlatformItem *) platformInfo {
    currentPlatformInfo = platformInfo;
    
    //
    platformImageView.image = currentPlatformInfo.platformImage_Normal;
    platformImageView.highlightedImage = currentPlatformInfo.platformImage_Highlight;
    
    platformLabel.text = currentPlatformInfo.platformName;
}

#pragma mark - Calculate Height

+ (CGFloat) calculateHeightWithPlatformInfo:(LLASocialSharePlatformItem *) platformInfo maxWidth:(CGFloat) maxWidth {
    return 70 + platformImageViewToLabelVerSpace + platformLabelHeight;
}




@end
