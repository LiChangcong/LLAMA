//
//  LLAUserOrderListCell.m
//  LLama
//
//  Created by Live on 16/1/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserOrderListCell.h"

#import "LLAUserHeadView.h"
#import "LLARewardMoneyView.h"

//model
#import "LLAScriptHallItemInfo.h"

//

static const CGFloat scriptLabelFontSize = 14;

// 背景到底部距离
static const CGFloat backViewToBottom = 0;

// 头像
static const CGFloat headViewToTop = 26; // 距离顶部
static const CGFloat headViewHeightWidth = 42; // 宽高
static const CGFloat headViewToLeft = 21; // 距离左边
static const CGFloat headViewToNameLabelHorSpace = 12; // 距离用户名间隙

// 片酬
static const CGFloat rewardViewToTop = 13; // 距离顶部
static const CGFloat rewardViewToRight = 14; // 距离右边

static const CGFloat publishTimeToPrivateHorSpace = 2;

// 分隔线
static const CGFloat headViewToSepLineVerSpace = 12; // 距离头像
static const CGFloat sepLineHeight = 0.5; // 高度
static const CGFloat sepLineToLeft = 14; // 距离左边
static const CGFloat sepLineToRight = 14; // 距离右边
static const CGFloat sepLineToImageViewVerSpace = 8; // 距离剧本内容图片

// 剧本图片内容
static const CGFloat scriptImageViewHeightWidth = 84; // 宽高
static const CGFloat scriptImageViewToLeft = 14; // 距离左边
static const CGFloat scriptImageViewToScriptLabelHorSpace = 8; // 距离剧本内容文字

// 剧本文字内容
static const CGFloat scriptLabelToRight = 18; // 距离左边
static const CGFloat scriptLabelToLeftWithoutImage = 18; //距离左边距离（没有剧本图片的情况）

// 参与人数
static const CGFloat scriptImageViewToPartakeNumberVerSpace = 11; // 距离剧本图片内容间隙
static const CGFloat partakeNumberToLeft = scriptImageViewToLeft; // 距离屏幕右边
static const CGFloat partakeNumbersToBottom = 27; // 距离cell底部
static const CGFloat partakeNumbersHeight = 44; // 高度
static const CGFloat functionButtonToRight = sepLineToRight;

//
static NSString *const isPrivateImageName = @"secretvideo";
static NSString *const countingImageName = @"clock";

@interface LLAUserOrderListCell()<LLAUserHeadViewDelegate>
{
    // cell背景
    UIView *backView;
    
    // 用户
    LLAUserHeadView *headView;
    UILabel *userNameLabel;
    UILabel *publishTimeLabel;
    
    // 片酬
    LLARewardMoneyView *rewardView;
    
    // 私密视频
    UIButton *isPrivateVideoButton;
    
    // 分割线
    UIView *seperatorLineView;
    
    // 剧本内容
    UIImageView *scriptImageView;
    UILabel *scriptContentLabel;
    
    // 参与人数
    UILabel *scriptTotalPartakeUserNumberLabel;
    
    UIButton *functionButton;
    
    // 颜色
    UIColor *contentViewBKColor;
    UIColor *backViewBKColor;
    UIColor *userNameLabelTextColor;
    UIColor *publishTimeLabelTextColor;
    UIColor *sepLineColor;
    UIColor *scriptTotalPartakeUserNumberLabelTextColor;
    
    UIColor *functionButtonNormalTextColor;
    UIColor *functionButtonHighlightTextColor;
    UIColor *functionButtonDisableTextColor;
    UIColor *functionButtonNormalBKColor;
    UIColor *functionButtonHighlightBKColor;
    UIColor *functionButtonDisableBKColor;

    
    // 字体
    UIFont *userNameLabelFont;
    UIFont *publishTimeLabelFont;
    UIFont *scriptTotalPartakeUserNumberLabelFont;
    UIFont *functionButtonFont;
    
    //
    NSLayoutConstraint *scriptLabelToLeftConstraints;
    LLAScriptHallItemInfo *currentScriptInfo;
    
}
@end

@implementation LLAUserOrderListCell
@synthesize delegate;

#pragma mark - Init

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
        
    }
    return self;
}

// 设置变量
- (void) initVariables {
    contentViewBKColor = [UIColor colorWithHex:0xf1f1f1];
    
    backViewBKColor = [UIColor whiteColor];
    
    userNameLabelFont = [UIFont boldLLAFontOfSize:15];
    userNameLabelTextColor = [UIColor colorWithHex:0x11111e];
    
    publishTimeLabelFont = [UIFont llaFontOfSize:12];
    publishTimeLabelTextColor = [UIColor colorWithHex:0x959595];
    
    sepLineColor = [UIColor colorWithHex:0xededed];
    
    scriptTotalPartakeUserNumberLabelFont = [UIFont llaFontOfSize:12];
    
    scriptTotalPartakeUserNumberLabelTextColor = [UIColor colorWithHex:0x959595];
    
    functionButtonFont = [UIFont llaFontOfSize:15];
    functionButtonNormalTextColor = [UIColor colorWithHex:0x11111e];
    functionButtonHighlightTextColor = [UIColor colorWithHex:0x11111e];
    functionButtonDisableTextColor = [UIColor colorWithHex:0x11111e];
    functionButtonNormalBKColor = [UIColor themeColor];
    functionButtonHighlightBKColor = [UIColor colorWithHex:0xebebeb];
    functionButtonDisableBKColor = [UIColor colorWithHex:0xebebeb];

}

// 设置Cell内部子控件
- (void) initSubViews {
    // 背景
    backView = [[UIView alloc] init];
    backView.translatesAutoresizingMaskIntoConstraints = NO;
    backView.backgroundColor = backViewBKColor;
    [self.contentView addSubview:backView];
    
    // 头部
    headView = [[LLAUserHeadView alloc] init];
    headView.translatesAutoresizingMaskIntoConstraints = NO;
    headView.delegate = self;
    [backView addSubview:headView];
    
    // 用户名
    userNameLabel = [[UILabel alloc] init];
    userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    userNameLabel.font = userNameLabelFont;
    userNameLabel.textColor = userNameLabelTextColor;
    [backView addSubview:userNameLabel];
    
    // 发布时间
    publishTimeLabel = [[UILabel alloc] init];
    publishTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    publishTimeLabel.textAlignment = NSTextAlignmentLeft;
    publishTimeLabel.font = publishTimeLabelFont;
    publishTimeLabel.textColor = publishTimeLabelTextColor;
    [backView addSubview:publishTimeLabel];
    
    // 片酬
    rewardView = [[LLARewardMoneyView alloc] init];
    rewardView.translatesAutoresizingMaskIntoConstraints = NO;
    [backView addSubview:rewardView];
    
    // 私密视频
    isPrivateVideoButton = [[UIButton alloc] init];
    isPrivateVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    isPrivateVideoButton.userInteractionEnabled = NO;
    [isPrivateVideoButton setImage:[UIImage llaImageWithName:isPrivateImageName] forState:UIControlStateNormal];
    [backView addSubview:isPrivateVideoButton];
    
    // 分割线
    seperatorLineView = [[UIView alloc] init];
    seperatorLineView.translatesAutoresizingMaskIntoConstraints = NO;
    seperatorLineView.backgroundColor = sepLineColor;
    [backView addSubview:seperatorLineView];
    
    // 剧本图片内容
    scriptImageView = [[UIImageView alloc] init];
    scriptImageView.translatesAutoresizingMaskIntoConstraints = NO;
    scriptImageView.contentMode = UIViewContentModeScaleAspectFill;
    scriptImageView.clipsToBounds = YES;
    [backView addSubview:scriptImageView];
    
    // 剧本文字内容
    scriptContentLabel = [[UILabel alloc] init];
    scriptContentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    scriptContentLabel.numberOfLines = 0;
    scriptContentLabel.textAlignment = NSTextAlignmentLeft;
    scriptContentLabel.contentMode = UIViewContentModeTop;
    [backView addSubview:scriptContentLabel];
    
    // 参与人数
    scriptTotalPartakeUserNumberLabel = [[UILabel alloc] init];
    scriptTotalPartakeUserNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    scriptTotalPartakeUserNumberLabel.textAlignment = NSTextAlignmentLeft;
    scriptTotalPartakeUserNumberLabel.font = scriptTotalPartakeUserNumberLabelFont;
    scriptTotalPartakeUserNumberLabel.textColor = scriptTotalPartakeUserNumberLabelTextColor;
    [backView addSubview:scriptTotalPartakeUserNumberLabel];
    
    functionButton = [[UIButton alloc] init];
    functionButton.translatesAutoresizingMaskIntoConstraints = NO;
    functionButton.clipsToBounds = YES;
    functionButton.layer.cornerRadius = 4;
    functionButton.titleLabel.font = functionButtonFont;
    [functionButton setBackgroundColor:functionButtonNormalBKColor forState:UIControlStateNormal];
    [functionButton setBackgroundColor:functionButtonHighlightBKColor forState:UIControlStateHighlighted];
    [functionButton setBackgroundColor:functionButtonDisableBKColor forState:UIControlStateDisabled];
    [functionButton setTitleColor:functionButtonNormalTextColor forState:UIControlStateNormal];
    [functionButton setTitleColor:functionButtonHighlightTextColor forState:UIControlStateHighlighted];
    [functionButton setTitleColor:functionButtonDisableTextColor forState:UIControlStateDisabled];
    [functionButton addTarget:self action:@selector(functionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:functionButton];
    
    
}

// 设置约束
- (void) initSubConstraints {
    
    //***************************backView***************************
    [self.contentView addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[backView]-(toBottom@999)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(backViewToBottom),@"toBottom", nil]
      views:NSDictionaryOfVariableBindings(backView)]];
    
    [self.contentView addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[backView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(backView)]];
    
    //***************************sub view on backView***************************
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //************vertical************
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[headView(headViewHeight)]-(headToLine)-[seperatorLineView(lineHeight)]-(lineToImage)-[scriptContentLabel]-(imageToNumber)-[scriptTotalPartakeUserNumberLabel(numberHeight)]-(toBottom)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(headViewToLeft),@"toTop",
               @(headViewHeightWidth),@"headViewHeight",
               @(headViewToSepLineVerSpace),@"headToLine",
               @(sepLineHeight),@"lineHeight",
               @(sepLineToImageViewVerSpace),@"lineToImage",
               @(scriptImageViewHeightWidth),@"imageHeight",
               @(scriptImageViewToPartakeNumberVerSpace),@"imageToNumber",
               @(partakeNumbersHeight),@"numberHeight",
               @(partakeNumbersToBottom),@"toBottom", nil]
      views:NSDictionaryOfVariableBindings(headView,seperatorLineView,scriptContentLabel,scriptTotalPartakeUserNumberLabel)]];
    
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
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:isPrivateVideoButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:publishTimeLabel
      attribute:NSLayoutAttributeCenterY
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
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[seperatorLineView]-(toLine)-[scriptImageView(height)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(sepLineToImageViewVerSpace),@"toLine",
               @(scriptImageViewHeightWidth),@"height", nil]
      views:NSDictionaryOfVariableBindings(seperatorLineView,scriptImageView)]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:functionButton
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:scriptTotalPartakeUserNumberLabel
      attribute:NSLayoutAttributeHeight
      multiplier:1.0
      constant:0]];
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:functionButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:scriptTotalPartakeUserNumberLabel
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    //************horizonal************
    
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
      constraintsWithVisualFormat:@"H:|-(toLeft)-[scriptImageView(width)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(scriptImageViewToLeft),@"toLeft",
               @(scriptImageViewHeightWidth),@"width", nil]
      views:NSDictionaryOfVariableBindings(scriptImageView)]];
    
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[scriptContentLabel]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(scriptImageViewToLeft+scriptImageViewHeightWidth+scriptImageViewToScriptLabelHorSpace),@"toLeft",
               @(scriptLabelToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(scriptContentLabel)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[scriptTotalPartakeUserNumberLabel]-(2)-[functionButton]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(partakeNumberToLeft),@"toLeft",
               @(functionButtonToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(scriptTotalPartakeUserNumberLabel,functionButton)]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:functionButton
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationGreaterThanOrEqual
      toItem:backView
      attribute:NSLayoutAttributeWidth
      multiplier:0.5
      constant:(-partakeNumberToLeft-functionButtonToRight-2)*0.5]];
    
    NSLayoutConstraint *widthConstraints = [NSLayoutConstraint
                                            constraintWithItem:functionButton
                                            attribute:NSLayoutAttributeWidth
                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                            toItem:backView
                                            attribute:NSLayoutAttributeWidth
                                            multiplier:2.0/3.0
                                            constant:(-partakeNumberToLeft-functionButtonToRight-2)*2/3];
    widthConstraints.priority = UILayoutPriorityDefaultHigh;
    
    [constrArray addObject:widthConstraints];
    
    [functionButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    for (NSLayoutConstraint *constr in constrArray) {
        if (constr.firstItem == scriptContentLabel && constr.firstAttribute == NSLayoutAttributeLeading) {
            scriptLabelToLeftConstraints = constr;
            break;
        }
    }
    
    [backView addConstraints:constrArray];
    
    
}

#pragma mark - LLAUserHeadViewDelegate

- (void) headView:(LLAUserHeadView *)headView clickedWithUserInfo:(LLAUser *)user {
    if (delegate && [delegate respondsToSelector:@selector(userHeadViewTapped:scriptInfo:)]) {
        [delegate userHeadViewTapped:user scriptInfo:currentScriptInfo];
    }
}

#pragma mark - ButtonClick

- (void) functionButtonClicked:(UIButton *)sender {
    if (delegate && [delegate respondsToSelector:@selector(manageScriptWithScriptInfo:)]) {
        [delegate manageScriptWithScriptInfo:currentScriptInfo];
    }
}

#pragma mark - Update
/**
 *  设置剧本cell的数据
 *
 *  @param scriptInfo 对应每行的模型
 *  @param tableWidth tableView的宽度
 */
- (void) updateCellWithScriptInfo:(LLAScriptHallItemInfo *)scriptInfo maxCellWidth:(CGFloat)maxCellWidth {
    
    currentScriptInfo = scriptInfo;
    
    // 头像/时间/用户名/片酬
    [headView updateHeadViewWithUser:currentScriptInfo.directorInfo];
    publishTimeLabel.text = currentScriptInfo.publisthTimeString;
    userNameLabel.text = currentScriptInfo.directorInfo.userName;
    [rewardView updateViewWithRewardMoney:currentScriptInfo.rewardMoney];
    
    // 有无图片的情况下更改剧本文字内容的约束
    if (currentScriptInfo.scriptImageURL) {
        scriptImageView.hidden = NO;
        
        scriptLabelToLeftConstraints.constant = scriptImageViewToLeft + scriptImageViewHeightWidth + scriptImageViewToScriptLabelHorSpace;
        
        [scriptImageView setImageWithURL:[NSURL URLWithString:currentScriptInfo.scriptImageURL] placeholderImage:nil];
        
    }else {
        scriptImageView.hidden = YES;
        scriptLabelToLeftConstraints.constant = scriptLabelToLeftWithoutImage;
    }
    
    scriptContentLabel.attributedText = [[self class] generateScriptAttriuteStingWith:currentScriptInfo];
    
    isPrivateVideoButton.hidden = !currentScriptInfo.isPrivateVideo;
    
    // 参与人数

    NSMutableAttributedString *numAttStr = [[NSMutableAttributedString alloc] initWithString:
                                            [NSString stringWithFormat:@"%ld 人已报名",(long)currentScriptInfo.signupUserNumbers]];
    [numAttStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor themeColor],NSForegroundColorAttributeName, nil] range:NSMakeRange(0, [NSString stringWithFormat:@"%ld",(long)currentScriptInfo.signupUserNumbers].length)];
    scriptTotalPartakeUserNumberLabel.attributedText = numAttStr;

    [self updateFunctionButtonStatus];
    
}

// 设置Function按钮
- (void) updateFunctionButtonStatus {
    
    //update function button
    
    UIImage *normalImage = nil;
    UIImage *highlighImage = nil;
    UIImage *disableImage = nil;
    
    NSString *normalString = nil;
    NSString *highlightString = nil;
    NSString *disabledString = nil;
    
    BOOL buttonEnabled = NO;
    
    switch (currentScriptInfo.status) {
        case LLAScriptStatus_Normal:
        {
            if (currentScriptInfo.currentRole == LLAUserRoleInScript_Director) {
                //director
                
                
                if (currentScriptInfo.partakeUsersArray.count > 0 || currentScriptInfo.signupUserNumbers > 0) {
                    normalString = @"挑选演员";
                    highlightString = @"挑选演员";
                    disabledString = @"挑选演员";
                    if (currentScriptInfo.hasTempChoose) {
                        buttonEnabled = YES;
                    }else {
                        buttonEnabled = NO;
                    }
                }else {
                    
                    normalString = @"一大波演员正在靠近";
                    highlightString = @"一大波演员正在靠近";
                    disabledString = @"一大波演员正在靠近";
                    buttonEnabled = NO;
                }
                
                
            }else if (currentScriptInfo.currentRole == LLAUserRoleInScript_Actor) {
                //actor
                normalString = @"等待导演选择";
                highlightString = @"等待导演选择";
                disabledString = @"等待导演选择";
                
                buttonEnabled = NO;
                
            }else {
                //passer
                
                normalString = @"我要报名";
                highlightString = @"我要报名";
                disabledString = @"我要报名";
                
                buttonEnabled = YES;
            }
        }
            
            break;
        case LLAScriptStatus_PayUnvertified:
        {
            if (currentScriptInfo.currentRole == LLAUserRoleInScript_Director) {
                //director
            }else if (currentScriptInfo.currentRole == LLAUserRoleInScript_Actor) {
                //actor
            }else {
                //passer
            }
        }
            
            break;
        case LLAScriptStatus_PayVertified:
        {
            if (currentScriptInfo.currentRole == LLAUserRoleInScript_Director) {
                //director
                normalString = [NSString stringWithFormat:@"%lld 演员拍摄中",currentScriptInfo.timeOutInterval];
                highlightString = [NSString stringWithFormat:@"%lld 演员拍摄中",currentScriptInfo.timeOutInterval];
                disabledString = [NSString stringWithFormat:@"%lld 演员拍摄中",currentScriptInfo.timeOutInterval];
                
                normalImage = [UIImage llaImageWithName:countingImageName];
                highlighImage = [UIImage llaImageWithName:countingImageName];
                disableImage = [UIImage llaImageWithName:countingImageName];
                
                buttonEnabled = NO;
                
            }else if (currentScriptInfo.currentRole == LLAUserRoleInScript_Actor) {
                //actor
                normalString = [NSString stringWithFormat:@"%@ 上传视频",[LLAScriptHallItemInfo timeIntervalToFormatString:currentScriptInfo.timeOutInterval]];
                highlightString = [NSString stringWithFormat:@"%@ 上传视频",[LLAScriptHallItemInfo timeIntervalToFormatString:currentScriptInfo.timeOutInterval]];
                disabledString = [NSString stringWithFormat:@"%@ 上传视频",[LLAScriptHallItemInfo timeIntervalToFormatString:currentScriptInfo.timeOutInterval]];
                
                normalImage = [UIImage llaImageWithName:countingImageName];
                highlighImage = [UIImage llaImageWithName:countingImageName];
                disableImage = [UIImage llaImageWithName:countingImageName];

                
                buttonEnabled = YES;
                
            }else {
                //passer
                normalString = [NSString stringWithFormat:@"%@ 演员拍摄中",[LLAScriptHallItemInfo timeIntervalToFormatString:currentScriptInfo.timeOutInterval]];
                highlightString = [NSString stringWithFormat:@"%@ 演员拍摄中",[LLAScriptHallItemInfo timeIntervalToFormatString:currentScriptInfo.timeOutInterval]];
                disabledString = [NSString stringWithFormat:@"%@ 演员拍摄中",[LLAScriptHallItemInfo timeIntervalToFormatString:currentScriptInfo.timeOutInterval]];
                
                normalImage = [UIImage llaImageWithName:countingImageName];
                highlighImage = [UIImage llaImageWithName:countingImageName];
                disableImage = [UIImage llaImageWithName:countingImageName];
                
                buttonEnabled = NO;
            }
        }
            break;
            
        case LLAScriptStatus_VideoUploaded:
        {
            if (currentScriptInfo.currentRole == LLAUserRoleInScript_Director) {
                //director
                normalString = @"看视频";
                highlightString = @"看视频";
                disabledString = @"看视频";
                
                buttonEnabled = YES;
            }else if (currentScriptInfo.currentRole == LLAUserRoleInScript_Actor) {
                //actor
                
                normalString = @"看视频";
                highlightString = @"看视频";
                disabledString = @"看视频";
                
                buttonEnabled = YES;
                
            }else {
                //passer
                
                normalString = @"看视频";
                highlightString = @"看视频";
                disabledString = @"看视频";
                
                buttonEnabled = YES;
            }
        }
            
            break;
        case LLAScriptStatus_WaitForUploadTimeOut:
        {
            if (currentScriptInfo.currentRole == LLAUserRoleInScript_Director) {
                //director
                normalString = @"未上传视频";
                highlightString = @"未上传视频";
                disabledString = @"未上传视频";
                
                buttonEnabled = NO;
                
            }else if (currentScriptInfo.currentRole == LLAUserRoleInScript_Actor) {
                //actor
                normalString = @"未上传视频";
                highlightString = @"未上传视频";
                disabledString = @"未上传视频";
                
                buttonEnabled = NO;
            }else {
                //passer
                normalString = @"未上传视频";
                highlightString = @"未上传视频";
                disabledString = @"未上传视频";
                
                buttonEnabled = NO;
            }
        }
            
            break;
            
        default:
        {
            if (currentScriptInfo.currentRole == LLAUserRoleInScript_Director) {
                //director
                normalString = @"未上传视频";
                highlightString = @"未上传视频";
                disabledString = @"未上传视频";
                
                buttonEnabled = NO;
            }else if (currentScriptInfo.currentRole == LLAUserRoleInScript_Actor) {
                //actor
                normalString = @"未上传视频";
                highlightString = @"未上传视频";
                disabledString = @"未上传视频";
                
                buttonEnabled = NO;
            }else {
                //passer
                normalString = @"未上传视频";
                highlightString = @"未上传视频";
                disabledString = @"未上传视频";
                
                buttonEnabled = NO;
            }
        }
            
            break;
    }
    
    functionButton.enabled = buttonEnabled;
    
    [functionButton setTitle:normalString forState:UIControlStateNormal];
    [functionButton setTitle:highlightString forState:UIControlStateHighlighted];
    [functionButton setTitle:disabledString forState:UIControlStateDisabled];
    
    [functionButton setImage:normalImage forState:UIControlStateNormal];
    [functionButton setImage:highlighImage forState:UIControlStateHighlighted];
    [functionButton setImage:disableImage forState:UIControlStateDisabled];
    
    
}


#pragma mark - Calculate Cell Height
/**
 *  剧本内容文字处理
 *
 *  @param scriptInfo 对应每行的模型
 *
 *  @return 带属性的文字
 */
+ (NSAttributedString *) generateScriptAttriuteStingWith:(LLAScriptHallItemInfo*) scriptInfo {
    
    NSString *scriptString = [scriptInfo.scriptContent copy];
    if (!scriptString)
        scriptString = @"";
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"#剧本#%@",scriptString]];;
    
    [attr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                         [UIFont boldLLAFontOfSize:scriptLabelFontSize],NSFontAttributeName,
                         [UIColor colorWithHex:0x11111e],NSForegroundColorAttributeName , nil] range:NSMakeRange(0, 4)];
    [attr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                         [UIFont llaFontOfSize:scriptLabelFontSize],NSFontAttributeName,
                         [UIColor colorWithHex:0x11111e],NSForegroundColorAttributeName , nil] range:NSMakeRange(4, scriptString.length)];
    
    return attr;
    
}
// 计算剧本文字内容占据的尺寸
+ (CGSize) scriptStringSizeWithVideoInfo:(LLAScriptHallItemInfo *)scriptInfo tableWidth:(CGFloat) tableWidth {
    
    NSAttributedString *attr = [[self class] generateScriptAttriuteStingWith:scriptInfo];
    
    CGFloat maxWidth = tableWidth - scriptLabelToLeftWithoutImage - scriptLabelToRight;
    
    if (scriptInfo.scriptImageURL) {
        maxWidth = tableWidth - scriptImageViewToLeft - scriptImageViewHeightWidth - scriptImageViewToScriptLabelHorSpace - scriptLabelToRight;
    }
    
    maxWidth = MAX(0,maxWidth);
    
    CGSize textSize = [attr boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)  options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    return textSize;
}

/**
 *  计算cell高度
 *
 *  @param scriptInfo 对应每行的模型
 *  @param tableWidth tableView的宽度
 *
 *  @return cell的高度
 */
+ (CGFloat) calculateHeightWithScriptInfo:(LLAScriptHallItemInfo *)scriptInfo maxCellWidth:(CGFloat)maxCellWidth {
    
    CGFloat height = 0;
    
    height += headViewToTop;
    height += headViewHeightWidth;
    height += headViewToSepLineVerSpace;
    height += sepLineHeight;
    height += sepLineToImageViewVerSpace;
    // 有图片就加上图片高度，否则只用加上文字高度
    if (scriptInfo.scriptImageURL) {
        height += scriptImageViewHeightWidth;
    }else {
        //get text heigh
        height += ceilf([self scriptStringSizeWithVideoInfo:scriptInfo tableWidth:maxCellWidth].height);
    }
    
    height += scriptImageViewToPartakeNumberVerSpace;
    height += partakeNumbersHeight;
    height += partakeNumbersToBottom;
    height += backViewToBottom;
    
    return height;
}




@end
