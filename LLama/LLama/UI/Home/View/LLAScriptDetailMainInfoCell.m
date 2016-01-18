//
//  LLAScriptDetailMainInfoCell.m
//  LLama
//
//  Created by Live on 16/1/17.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAScriptDetailMainInfoCell.h"
#import "LLAUserHeadView.h"
#import "LLARewardMoneyView.h"

//model
#import "LLAScriptHallItemInfo.h"


static const CGFloat scriptLabelFontSize = 14;

//

static const CGFloat headViewToTop = 17;
static const CGFloat headViewHeightWidth = 42;
static const CGFloat headViewToLeft = 23;
static const CGFloat headViewToNameLabelHorSpace = 12;
static const CGFloat publishTimeToPrivateHorSpace = 2;

static const CGFloat rewardViewToTop = 5;
static const CGFloat rewardViewToRight = 12;

static const CGFloat headViewToSepLineVerSpace = 13;

static const CGFloat sepLineHeight = 0.5;
static const CGFloat sepLineToLeft = 14;
static const CGFloat sepLineToRight = 14;
static const CGFloat sepLineToScriptLabelVerSpace = 10;

static const CGFloat scriptLabelToFlexButtonVerSpace = 4;
static const CGFloat flexButtonHeight = 16;
static const CGFloat flexButtonToImageVerSpace = 4;
static const CGFloat flexButtonToRight = 29;
static const CGFloat scriptImageToScriptLineVerSpace = 4;
static const CGFloat scriptLabelToRight = 18;
static const CGFloat scriptLabelToLeft = 18;

static const CGFloat scriptImageViewToPartakeNumberVerSpace = 8;
static const CGFloat partakeNumberToLeft = 24;
static const CGFloat bottomHeight = 54;
static const CGFloat functionButtonHeight = 44;
static const CGFloat functionButtonToRight = 14;

//

static NSString *const isPrivateImageName = @"";

@interface LLAScriptDetailMainInfoCell()<LLAUserHeadViewDelegate>
{
    LLAUserHeadView *headView;
    UILabel *userNameLabel;
    UILabel *publishTimeLabel;
    
    LLARewardMoneyView *rewardView;
    
    UIButton *isPrivateVideoButton;
    
    UIView *seperatorLineView;
    
    UIImageView *scriptImageView;
    UILabel *scriptContentLabel;
    
    UIButton *flexContentButton;
    
    UIView *scriptSepLine;
    
    UILabel *scriptTotalPartakeUserNumberLabel;
    
    UIButton *functionButton;
    
    //
    UIColor *contentViewBKColor;
    
    UIColor *backViewBKColor;
    
    UIFont *userNameLabelFont;
    UIColor *userNameLabelTextColor;
    
    UIFont *publishTimeLabelFont;
    UIColor *publishTimeLabelTextColor;
    
    UIColor *sepLineColor;
    
    UIFont *scriptTotalPartakeUserNumberLabelFont;
    UIColor *scriptTotalPartakeUserNumberLabelTextColor;
    
}

@end

@implementation LLAScriptDetailMainInfoCell

@synthesize delegate;

#pragma mark - Init

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
        
    }
    return self;
    
}

- (void) initVariables {
    
    backViewBKColor = [UIColor whiteColor];
    
    userNameLabelFont = [UIFont boldLLAFontOfSize:15];
    userNameLabelTextColor = [UIColor colorWithHex:0x11111e];
    
    publishTimeLabelFont = [UIFont llaFontOfSize:12];
    publishTimeLabelTextColor = [UIColor colorWithHex:0x959595];
    
    sepLineColor = [UIColor colorWithHex:0xededed];
    
    scriptTotalPartakeUserNumberLabelFont = [UIFont llaFontOfSize:12];
    
    scriptTotalPartakeUserNumberLabelTextColor = [UIColor colorWithHex:0x959595];
    
}

- (void) initSubViews {

    headView = [[LLAUserHeadView alloc] init];
    headView.translatesAutoresizingMaskIntoConstraints = NO;
    headView.delegate = self;
    
    [self.contentView addSubview:headView];
    
    userNameLabel = [[UILabel alloc] init];
    userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    userNameLabel.font = userNameLabelFont;
    userNameLabel.textColor = userNameLabelTextColor;
    
    [self.contentView addSubview:userNameLabel];
    
    publishTimeLabel = [[UILabel alloc] init];
    publishTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    publishTimeLabel.textAlignment = NSTextAlignmentLeft;
    publishTimeLabel.font = publishTimeLabelFont;
    publishTimeLabel.textColor = publishTimeLabelTextColor;
    
    [self.contentView addSubview:publishTimeLabel];
    
    rewardView = [[LLARewardMoneyView alloc] init];
    rewardView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:rewardView];
    
    isPrivateVideoButton = [[UIButton alloc] init];
    isPrivateVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    isPrivateVideoButton.userInteractionEnabled = NO;
    
    [isPrivateVideoButton setImage:[UIImage llaImageWithName:isPrivateImageName] forState:UIControlStateNormal];
    
    [self.contentView addSubview:isPrivateVideoButton];
    
    //
    seperatorLineView = [[UIView alloc] init];
    seperatorLineView.translatesAutoresizingMaskIntoConstraints = NO;
    seperatorLineView.backgroundColor = sepLineColor;
    
    [self.contentView addSubview:seperatorLineView];
    
    scriptImageView = [[UIImageView alloc] init];
    scriptImageView.translatesAutoresizingMaskIntoConstraints = NO;
    scriptImageView.contentMode = UIViewContentModeScaleAspectFill;
    scriptImageView.clipsToBounds = YES;
    
    [self.contentView addSubview:scriptImageView];
    
    scriptContentLabel = [[UILabel alloc] init];
    scriptContentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    scriptContentLabel.numberOfLines = 0;
    scriptContentLabel.textAlignment = NSTextAlignmentLeft;
    scriptContentLabel.contentMode = UIViewContentModeTop;
    
    [self.contentView addSubview:scriptContentLabel];
    
    flexContentButton = [[UIButton alloc] init];
    flexContentButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [flexContentButton addTarget:self action:@selector(flexContentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:flexContentButton];
    
    //
    scriptSepLine = [[UIView alloc] init];
    scriptSepLine.translatesAutoresizingMaskIntoConstraints = NO;
    scriptSepLine.backgroundColor = sepLineColor;
    
    [self.contentView addSubview:scriptSepLine];
    
    scriptTotalPartakeUserNumberLabel = [[UILabel alloc] init];
    scriptTotalPartakeUserNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    scriptTotalPartakeUserNumberLabel.textAlignment = NSTextAlignmentRight;
    scriptTotalPartakeUserNumberLabel.font = scriptTotalPartakeUserNumberLabelFont;
    scriptTotalPartakeUserNumberLabel.textColor = scriptTotalPartakeUserNumberLabelTextColor;
    
    [self.contentView addSubview:scriptTotalPartakeUserNumberLabel];
    
    functionButton = [[UIButton alloc] init];
    functionButton.translatesAutoresizingMaskIntoConstraints = NO;
    functionButton.clipsToBounds = YES;
    functionButton.layer.cornerRadius = 4;
    
    [functionButton setBackgroundColor:[UIColor themeColor] forState:UIControlStateNormal];
    
    [functionButton addTarget:self action:@selector(functionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:functionButton];
}

- (void) initSubConstraints {
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[headView(headViewHeight)]-(headToLine)-[seperatorLineView(lineHeight)]-(lineToScript)-[scriptContentLabel]-(scriptToFlex)-[flexContentButton(flexHeight)]-(flexToImage)-[scriptImageView(10)]-(imageToLine)-[scriptSepLine(lineHeight)]-(0)-[scriptTotalPartakeUserNumberLabel(bottomHeight)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(headViewToLeft),@"toTop",
               @(headViewHeightWidth),@"headViewHeight",
               @(headViewToSepLineVerSpace),@"headToLine",
               @(sepLineHeight),@"lineHeight",
               @(sepLineToScriptLabelVerSpace),@"lineToScript",
               @(scriptLabelToFlexButtonVerSpace),@"scriptToFlex",
               @(flexButtonHeight),@"flexHeight",
               @(flexButtonToImageVerSpace),@"flexToImage",
               @(scriptImageToScriptLineVerSpace),@"imageToLine",
               @(bottomHeight),@"bottomHeight", nil]
      views:NSDictionaryOfVariableBindings(headView,seperatorLineView,scriptContentLabel,flexContentButton,scriptImageView,scriptSepLine,scriptTotalPartakeUserNumberLabel)]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:userNameLabel
      attribute:NSLayoutAttributeTop
      relatedBy:NSLayoutRelationEqual
      toItem:headView
      attribute:NSLayoutAttributeTop
      multiplier:1.0
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:publishTimeLabel
      attribute:NSLayoutAttributeBottom
      relatedBy:NSLayoutRelationEqual
      toItem:headView
      attribute:NSLayoutAttributeBottom
      multiplier:1.0
      constant:0]];
    
    //
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[rewardView(height)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(rewardViewToTop),@"toTop",
               @(videoRewardMoneyViewHeight),@"height", nil]
      views:NSDictionaryOfVariableBindings(rewardView)]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:functionButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:scriptTotalPartakeUserNumberLabel
      attribute:NSLayoutAttributeBottom
      multiplier:1.0
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:functionButton
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0
      constant:functionButtonHeight]];
    
    
    //horizonal
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[headView(headWidth)]-(headToName)-[userNameLabel]-(2)-[rewardView(rewardWidth)]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(headViewToLeft),@"toLeft",
               @(headViewHeightWidth),@"headWidth",
               @(headViewToNameLabelHorSpace),@"headToName",
               @(videoRewardMoneyViewWidth),@"rewardWidth",
               @(rewardViewToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(headView,userNameLabel,rewardView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[headView]-(headToTime)-[publishTimeLabel]-(timeToPrivate)-[isPrivateVideoButton]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(headViewToNameLabelHorSpace),@"headToTime",
               @(publishTimeToPrivateHorSpace),@"timeToPrivate",
               @(rewardViewToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(headView,publishTimeLabel,isPrivateVideoButton)]];
    
//    [constrArray addObject:
//     [NSLayoutConstraint
//      constraintWithItem:publishTimeLabel
//      attribute:NSLayoutAttributeLeading
//      relatedBy:NSLayoutRelationEqual
//      toItem:userNameLabel
//      attribute:NSLayoutAttributeLeading
//      multiplier:1.0
//      constant:0]];
//    
//    [constrArray addObject:
//     [NSLayoutConstraint
//      constraintWithItem:publishTimeLabel
//      attribute:NSLayoutAttributeTrailing
//      relatedBy:NSLayoutRelationEqual
//      toItem:userNameLabel
//      attribute:NSLayoutAttributeTrailing
//      multiplier:1.0
//      constant:0]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[seperatorLineView]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(sepLineToLeft),@"toLeft",
               @(sepLineToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(seperatorLineView)]];
    
   
    
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[scriptContentLabel]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(scriptLabelToLeft),@"toLeft",
               @(scriptLabelToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(scriptContentLabel)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[flexContentButton]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
                @(flexButtonToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(flexContentButton)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[scriptImageView]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(scriptLabelToLeft),@"toLeft",
               @(scriptLabelToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(scriptImageView)]];
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[scriptSepLine]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(0),@"toLeft",
               @(0),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(scriptSepLine)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[scriptTotalPartakeUserNumberLabel(==functionButton)]-(2)-[functionButton]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(partakeNumberToLeft),@"toLeft",
               @(functionButtonToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(scriptTotalPartakeUserNumberLabel,functionButton)]];
    
    
    [self.contentView addConstraints:constrArray];
}


#pragma mark - LLAUserHeadViewDelegate

- (void) headView:(LLAUserHeadView *)headView clickedWithUserInfo:(LLAUser *)user {
    
}

#pragma mark - Button Clicked

- (void) flexContentButtonClicked:(UIButton *) sender {
    
}

- (void) functionButtonClicked:(UIButton *)sender {
    
}


#pragma mark - Update

#pragma mark - Calculate Cell Height

@end
