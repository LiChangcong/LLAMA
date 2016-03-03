//
//  LLAFollowViewInChattingView.m
//  LLama
//
//  Created by Live on 16/3/3.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAFollowViewInChattingView.h"

static const CGFloat mentionLabelToLeft = 10;
static const CGFloat mentionLabelToFollowHorSpace = 2;
static const CGFloat followButtonWidth = 80;
static const CGFloat followButtonHeight = 32;
static const CGFloat followButtonToRight = 10;

@interface LLAFollowViewInChattingView()
{
    UILabel *mentionLabel;
    UIButton *followButton;
    
    UIColor *backColor;
    
    UIFont *metionLabelFont;
    UIColor *metionLabelTextColor;
    
    UIColor *followButtonBKColor;
    UIColor *followButtonTitleColor;
    
    UIFont *followButtonFont;
}

@end

@implementation LLAFollowViewInChattingView

@synthesize delegate;

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit {
    [self initVariables];
    [self initSubViews];
}

- (void) initVariables {
    
    backColor = [UIColor colorWithHex:0x1e1d28];
    
    metionLabelFont = [UIFont llaFontOfSize:14];
    metionLabelTextColor = [UIColor colorWithHex:0xa6a6a7];
    
    followButtonBKColor = [UIColor themeColor];
    followButtonBKColor = [UIColor colorWithHex:0xffffff];
    
    followButtonFont = [UIFont llaFontOfSize:15];
    
}

- (void) initSubViews {
    
    mentionLabel = [[UILabel alloc] init];
    mentionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    mentionLabel.font = metionLabelFont;
    mentionLabel.textColor = metionLabelTextColor;
    mentionLabel.textAlignment = NSTextAlignmentLeft;
    mentionLabel.text = @"喜欢Ta就关注Ta吧";
    
    [self addSubview:mentionLabel];
    
    followButton = [[UIButton alloc] init];
    followButton.translatesAutoresizingMaskIntoConstraints = NO;
    followButton.layer.cornerRadius = 2;
    followButton.clipsToBounds = YES;
    
    followButton.titleLabel.font = followButtonFont;
    
    [followButton setTitle:@"＋关注" forState:UIControlStateNormal];
    [followButton addTarget:self action:@selector(followButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [followButton setTitleColor:followButtonTitleColor forState:UIControlStateNormal];
    [followButton setBackgroundColor:followButtonBKColor forState:UIControlStateNormal];
    
    [self addSubview:followButton];
    
    //constr
    
    NSMutableArray *constrArr = [NSMutableArray arrayWithCapacity:10];
    
    //vertical
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[mentionLabel]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(mentionLabel)]];
    
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:followButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:followButton
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0
      constant:followButtonHeight]];
    
    //horizonal
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[mentionLabel]-(mentionToFollow)-[followButton(width)]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toLeft":@(mentionLabelToLeft),
                @"mentionToFollow":@(mentionLabelToFollowHorSpace),
                @"width":@(followButtonWidth),
                @"toRight":@(followButtonToRight)}
      views:NSDictionaryOfVariableBindings(mentionLabel,followButton)]];
    
    [self addConstraints:constrArr];

    
}
#pragma mark - follow

- (void) followButtonClicked:(UIButton *) sender {
    if (delegate && [delegate respondsToSelector:@selector(followCurrentUser)]) {
        [delegate followCurrentUser];
    }
}

#pragma mark -
+ (CGFloat) calculateHeight {
    return 36.5;
}

@end
