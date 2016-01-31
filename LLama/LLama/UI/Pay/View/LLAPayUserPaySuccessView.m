//
//  LLAPayUserPaySuccessView.m
//  LLama
//
//  Created by Live on 16/1/31.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAPayUserPaySuccessView.h"

#import "MMPopup.h"

static const CGFloat backImageViewHeight = 159;
static const CGFloat backImageViewWidth = 270;

static const CGFloat mentionButtonToTop = 16;

static const CGFloat mentionContentLabelToBottom = 32;
static const CGFloat mentionContentLabelToHorBorder = 16;

//
static NSString *const backImageName = @"darkbg";
static NSString *const mentionButtonImageName = @"yellowdot";

@interface LLAPayUserPaySuccessView()
{
    UIImageView *backImageView;
    
    UIButton *mentionButton;
    UILabel *mentionContentLabel;
    
    //
    UIFont *mentionButtonFont;
    UIColor *mentionButtonTextColor;
    
    UIFont *mentionContentLabelFont;
    UIColor *mentionContentLabelTextColor;

}

@end

@implementation LLAPayUserPaySuccessView

#pragma mark - Init

- (instancetype) init {
    self = [super init];
    if (self) {
        
        self.type = MMPopupTypeCustom;
        
        [self initVariables];
        [self initSubViews];
        [self initSubContraints];
        
        [self initShowAnimation];
        [self initHideAnimation];
        
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        
        //self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}


- (void) initVariables {
    mentionButtonFont = [UIFont llaFontOfSize:18];
    mentionButtonTextColor = [UIColor themeColor];
    
    mentionContentLabelFont = [UIFont llaFontOfSize:14];
    mentionContentLabelTextColor = [UIColor whiteColor];
}

-  (void) initSubViews {
    
    backImageView = [[UIImageView alloc] init];
    backImageView.translatesAutoresizingMaskIntoConstraints = NO;
    backImageView.clipsToBounds = YES;
    backImageView.image = [UIImage imageNamed:backImageName];
    
    [self addSubview:backImageView];
    
    //
    mentionButton = [[UIButton alloc] init];
    mentionButton.translatesAutoresizingMaskIntoConstraints = NO;
    mentionButton.userInteractionEnabled = NO;
    
    mentionButton.titleLabel.font = mentionButtonFont;
    [mentionButton setTitleColor:mentionButtonTextColor forState:UIControlStateNormal];
    [mentionButton setTitle:@"  支付成功" forState:UIControlStateNormal];
    [mentionButton setImage:[UIImage llaImageWithName:mentionButtonImageName] forState:UIControlStateNormal];
    
    [backImageView addSubview:mentionButton];
    
    mentionContentLabel = [[UILabel alloc] init];
    mentionContentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    mentionContentLabel.font = mentionContentLabelFont;
    mentionContentLabel.textColor = mentionContentLabelTextColor;
    mentionContentLabel.textAlignment = NSTextAlignmentCenter;
    mentionContentLabel.numberOfLines = 0;
    
    mentionContentLabel.text = @"24小时内演员未传片\n片酬将退回LLama帐户";
    
    [backImageView addSubview:mentionContentLabel];
}

- (void) initSubContraints {
    
    //vertical
    [self addConstraint:
     [NSLayoutConstraint
      constraintWithItem:backImageView
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0
      constant:backImageViewHeight]];
    
    [self addConstraint:
     [NSLayoutConstraint
      constraintWithItem:backImageView
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    [self addConstraint:
     [NSLayoutConstraint
      constraintWithItem:backImageView
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0
      constant:backImageViewWidth]];
    
    [self addConstraint:
     [NSLayoutConstraint
      constraintWithItem:backImageView
      attribute:NSLayoutAttributeCenterX
      relatedBy:NSLayoutRelationEqual
      toItem:self
      attribute:NSLayoutAttributeCenterX
      multiplier:1.0
      constant:0]];
    //
    
    NSMutableArray *constArr = [NSMutableArray array];
    
    
    [constArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[mentionButton]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(mentionButtonToTop),@"toTop", nil]
      views:NSDictionaryOfVariableBindings(mentionButton)]];
    
    [constArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[mentionContentLabel]-(toBottom)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(mentionContentLabelToBottom),@"toBottom", nil]
      views:NSDictionaryOfVariableBindings(mentionContentLabel)]];
    
    //horizonal
    
    [constArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(8)-[mentionButton]-(8)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(mentionButton)]];
    
    [constArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toBorder)-[mentionContentLabel]-(toBorder)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(mentionContentLabelToHorBorder),@"toBorder", nil]
      views:NSDictionaryOfVariableBindings(mentionContentLabel)]];
    
    [backImageView addConstraints:constArr];
}

- (void) initShowAnimation {
    
    __weak typeof(self) weakSelf = self;
    
    MMPopupBlock block = ^(MMPopupView *popupView) {
        
        __strong typeof(self) strongSelf = weakSelf;
        
        [strongSelf.attachedView.mm_dimBackgroundView addSubview:strongSelf];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        [strongSelf.attachedView.mm_dimBackgroundView addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|-(0)-[strongSelf]-(0)-|"
          options:NSLayoutFormatDirectionLeadingToTrailing
          metrics:nil
          views:NSDictionaryOfVariableBindings(strongSelf)]];
        [strongSelf.attachedView.mm_dimBackgroundView addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-(0)-[strongSelf]-(0)-|"
          options:NSLayoutFormatDirectionLeadingToTrailing
          metrics:nil
          views:NSDictionaryOfVariableBindings(strongSelf)]];
        [strongSelf layoutIfNeeded];
        
        //animation
        
        strongSelf.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             strongSelf.transform = CGAffineTransformMakeScale(1.0,1.0);
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if ( strongSelf.showCompletionBlock )
                             {
                                 strongSelf.showCompletionBlock(strongSelf);
                             }
                             
                         }];
        
        
    };
    
    self.showAnimation = block;
    
}

- (void) initHideAnimation {
    
    __weak typeof(self) weakSelf = self;
    
    MMPopupBlock block = ^(MMPopupView *popupView) {
        
        __strong typeof(self) strongSelf = weakSelf;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             strongSelf.transform = CGAffineTransformMakeScale(0.1,0.1);
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [strongSelf removeConstraints:strongSelf.constraints];
                             [strongSelf removeFromSuperview];
                             
                             if ( strongSelf.hideCompletionBlock )
                             {
                                 strongSelf.hideCompletionBlock(strongSelf);
                             }
                             
                         }];
        
    };
    
    self.hideAnimation = block;
    
}


@end
