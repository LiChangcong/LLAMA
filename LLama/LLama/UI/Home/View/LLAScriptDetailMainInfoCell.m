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

//util
#import "LLACommonUtil.h"


static const CGFloat scriptLabelFontSize = 14;

// 头像
static const CGFloat headViewToTop = 17;
static const CGFloat headViewHeightWidth = 42;
static const CGFloat headViewToLeft = 23;
static const CGFloat headViewToNameLabelHorSpace = 12;


// 发布时间
static const CGFloat publishTimeToPrivateHorSpace = 2;

// 片酬
static const CGFloat rewardViewToTop = 5;
static const CGFloat rewardViewToRight = 12;

// 分隔线
static const CGFloat headViewToSepLineVerSpace = 13;
static const CGFloat sepLineHeight = 0.6;
static const CGFloat sepLineToLeft = 14;
static const CGFloat sepLineToRight = 14;
static const CGFloat sepLineToScriptLabelVerSpace = 10;

// 更多按钮
static const CGFloat scriptLabelToFlexButtonVerSpace = 4;
static const CGFloat flexButtonHeight = 16; //
static const CGFloat flexButtonToImageVerSpace = 4;
static const CGFloat flexButtonToRight = 29;

// 剧本图片和文字内容
static const CGFloat scriptImageToScriptLineVerSpace = 4;
static const CGFloat scriptLabelToRight = 18;
static const CGFloat scriptLabelToLeft = 18;

// 底部整体（报名人数/功能按钮）
static const CGFloat bottomHeight = 54;
static const CGFloat functionButtonHeight = 44;
static const CGFloat functionButtonToRight = 14;
static const CGFloat partakeNumberToLeft = 24;

// 其他
static const NSInteger maxNumberLinesWhenShrink = 4;
static NSString *const isPrivateImageName = @"secretvideo";
static NSString *const countingImageName = @"clock";

@interface LLAScriptDetailMainInfoCell()<LLAUserHeadViewDelegate>
{
    // 头像/名字/发布时间
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
    
    // 更多按钮
    UIButton *flexContentButton;
    
    // 分割线
    UIView *scriptSepLine;
    
    // 报名人数/功能按钮
    UILabel *scriptTotalPartakeUserNumberLabel;
    UIButton *functionButton;
    
    // 字体
    UIFont *userNameLabelFont;
    UIFont *publishTimeLabelFont;
    UIFont *flexButtonFont;
    UIFont *scriptTotalPartakeUserNumberLabelFont;
    UIColor *scriptTotalPartakeUserNumberLabelTextColor;
    UIFont *functionButtonFont;
    
    // 颜色
    UIColor *contentViewBKColor;
    UIColor *backViewBKColor;
    UIColor *userNameLabelTextColor;
    UIColor *publishTimeLabelTextColor;
    UIColor *flexButtonTextColor;
    UIColor *sepLineColor;
    UIColor *functionButtonNormalTextColor;
    UIColor *functionButtonHighlightTextColor;
    UIColor *functionButtonDisableTextColor;
    UIColor *functionButtonNormalBKColor;
    UIColor *functionButtonHighlightBKColor;
    UIColor *functionButtonDisableBKColor;
    
    // 约束
    NSLayoutConstraint *scriptImageViewHeightConstraint;
    
    //
    LLAScriptHallItemInfo *currentScriptInfo;
    

}

@end

@implementation LLAScriptDetailMainInfoCell

@synthesize delegate;

#pragma mark - Init

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        // 设置变量
        [self initVariables];
        // 设置子控件
        [self initSubViews];
        // 设置子控件约束
        [self initSubConstraints];
        // 设置背景色
        self.contentView.backgroundColor = backViewBKColor;
        
    }
    return self;
    
}

// 设置变量
- (void) initVariables {
    
    // 颜色
    backViewBKColor = [UIColor whiteColor];
    userNameLabelTextColor = [UIColor colorWithHex:0x11111e];
    publishTimeLabelTextColor = [UIColor colorWithHex:0x959595];
    flexButtonTextColor = [UIColor colorWithHex:0x959595];
    sepLineColor = [UIColor colorWithHex:0xededed];
    scriptTotalPartakeUserNumberLabelTextColor = [UIColor colorWithHex:0x959595];
    functionButtonNormalTextColor = [UIColor colorWithHex:0x11111e];
    functionButtonHighlightTextColor = [UIColor colorWithHex:0x11111e];
    functionButtonDisableTextColor = [UIColor colorWithHex:0x11111e];
    functionButtonNormalBKColor = [UIColor themeColor];
    functionButtonHighlightBKColor = [UIColor colorWithHex:0xeaeaea];
    functionButtonDisableBKColor = [UIColor colorWithHex:0xeaeaea];
    
    // 字体
    userNameLabelFont = [UIFont boldLLAFontOfSize:15];
    publishTimeLabelFont = [UIFont llaFontOfSize:12];
    flexButtonFont = [UIFont llaFontOfSize:12];
    scriptTotalPartakeUserNumberLabelFont = [UIFont llaFontOfSize:13];
    functionButtonFont = [UIFont llaFontOfSize:15];


}
// 设置子控件
- (void) initSubViews {

    // 头像
    headView = [[LLAUserHeadView alloc] init];
    headView.translatesAutoresizingMaskIntoConstraints = NO;
    headView.delegate = self;
    [self.contentView addSubview:headView];
    
    // 导演名
    userNameLabel = [[UILabel alloc] init];
    userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    userNameLabel.font = userNameLabelFont;
    userNameLabel.textColor = userNameLabelTextColor;
    [self.contentView addSubview:userNameLabel];
    
    // 发布时间
    publishTimeLabel = [[UILabel alloc] init];
    publishTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    publishTimeLabel.textAlignment = NSTextAlignmentLeft;
    publishTimeLabel.font = publishTimeLabelFont;
    publishTimeLabel.textColor = publishTimeLabelTextColor;
    [self.contentView addSubview:publishTimeLabel];
    
    // 片酬
    rewardView = [[LLARewardMoneyView alloc] init];
    rewardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:rewardView];
    
    // 私密视频
    isPrivateVideoButton = [[UIButton alloc] init];
    isPrivateVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    isPrivateVideoButton.userInteractionEnabled = NO;
    [isPrivateVideoButton setImage:[UIImage llaImageWithName:isPrivateImageName] forState:UIControlStateNormal];
    [self.contentView addSubview:isPrivateVideoButton];
    
    // 分割线
    seperatorLineView = [[UIView alloc] init];
    seperatorLineView.translatesAutoresizingMaskIntoConstraints = NO;
    seperatorLineView.backgroundColor = sepLineColor;
    [self.contentView addSubview:seperatorLineView];
    
    // 剧本图片内容
    scriptImageView = [[UIImageView alloc] init];
    scriptImageView.translatesAutoresizingMaskIntoConstraints = NO;
    scriptImageView.contentMode = UIViewContentModeScaleAspectFill;
    scriptImageView.clipsToBounds = YES;
    [self.contentView addSubview:scriptImageView];
    
    // 剧本文字内容
    scriptContentLabel = [[UILabel alloc] init];
    scriptContentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    scriptContentLabel.numberOfLines = 0;
    scriptContentLabel.textAlignment = NSTextAlignmentLeft;
    //scriptContentLabel.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:scriptContentLabel];
    
    // 更多按钮
    flexContentButton = [[UIButton alloc] init];
    flexContentButton.translatesAutoresizingMaskIntoConstraints = NO;
    flexContentButton.titleLabel.font = flexButtonFont;
    [flexContentButton setTitleColor:flexButtonTextColor forState:UIControlStateNormal];
    [flexContentButton addTarget:self action:@selector(flexContentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[flexContentButton setBackgroundColor:[UIColor purpleColor]];
    [self.contentView addSubview:flexContentButton];
    
    // 分割线
    scriptSepLine = [[UIView alloc] init];
    scriptSepLine.translatesAutoresizingMaskIntoConstraints = NO;
    scriptSepLine.backgroundColor = sepLineColor;
    [self.contentView addSubview:scriptSepLine];
    
    // 报名人数
    scriptTotalPartakeUserNumberLabel = [[UILabel alloc] init];
    scriptTotalPartakeUserNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    scriptTotalPartakeUserNumberLabel.textAlignment = NSTextAlignmentLeft;
    scriptTotalPartakeUserNumberLabel.font = scriptTotalPartakeUserNumberLabelFont;
    scriptTotalPartakeUserNumberLabel.textColor = scriptTotalPartakeUserNumberLabelTextColor;
    [self.contentView addSubview:scriptTotalPartakeUserNumberLabel];
    
    // 功能按钮
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
    [self.contentView addSubview:functionButton];
}

// 设置子控件约束
- (void) initSubConstraints {
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //***************************vertical***************************
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[headView(headViewHeight)]-(headToLine)-[seperatorLineView(lineHeight)]-(lineToScript)-[scriptContentLabel]-(scriptToFlex)-[flexContentButton(flexHeight)]-(flexToImage)-[scriptImageView(10)]-(imageToLine)-[scriptSepLine(lineHeight)]-(0)-[scriptTotalPartakeUserNumberLabel(bottomHeight)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(headViewToTop),@"toTop",
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
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:functionButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:scriptTotalPartakeUserNumberLabel
      attribute:NSLayoutAttributeCenterY
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
    
    
    //***************************horizonal***************************
    
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
    
    //
    for (NSLayoutConstraint *constr in constrArray) {
        if (constr.firstItem == scriptImageView && constr.firstAttribute == NSLayoutAttributeHeight) {
            scriptImageViewHeightConstraint = constr;
            break;
        }
    }
    
    [self.contentView addConstraints:constrArray];
}


#pragma mark - LLAUserHeadViewDelegate

// 点击导演头像
- (void) headView:(LLAUserHeadView *)uheadView clickedWithUserInfo:(LLAUser *)user {
    if (delegate && [delegate respondsToSelector:@selector(directorHeadViewClicked:userInfo:scriptInfo:)]) {
        [delegate directorHeadViewClicked:uheadView userInfo:user scriptInfo:currentScriptInfo];
    }
}

#pragma mark - Button Clicked

// 点击更多按钮
- (void) flexContentButtonClicked:(UIButton *) sender {
    if (delegate && [delegate respondsToSelector:@selector(flexOrShrinkScriptContentWithScriptInfo:)]) {
        [delegate flexOrShrinkScriptContentWithScriptInfo:currentScriptInfo];
    }
}

// 点击功能按钮
- (void) functionButtonClicked:(UIButton *)sender {
    if (delegate && [delegate respondsToSelector:@selector(manageScriptWithScriptInfo:)]) {
        [delegate manageScriptWithScriptInfo:currentScriptInfo];
    }
}


#pragma mark - Update
// 设置数据
- (void) updateCellWithInfo:(LLAScriptHallItemInfo *)scriptInfo maxWidth:(CGFloat)maxWidth {
    
    currentScriptInfo = scriptInfo;
    // 头像/用户名/发布时间
    [headView updateHeadViewWithUser:currentScriptInfo.directorInfo];
    userNameLabel.text = currentScriptInfo.directorInfo.userName;
    publishTimeLabel.text = currentScriptInfo.publisthTimeString;
    
    // 私密视频
    isPrivateVideoButton.hidden = !currentScriptInfo.isPrivateVideo;
    
    // 片酬
    [rewardView updateViewWithRewardMoney:currentScriptInfo.rewardMoney];
    
    // 剧本文字内容
    scriptContentLabel.attributedText = [[self class] generateScriptAttriuteStingWith:currentScriptInfo];
    
    // 有无图片约束不同位置，并是否显示图片
    if (currentScriptInfo.scriptImageURL) {
        
        scriptImageViewHeightConstraint.constant = maxWidth - scriptLabelToLeft - scriptLabelToRight;
        scriptImageView.hidden = NO;
        [scriptImageView setImageWithURL:[NSURL URLWithString:currentScriptInfo.scriptImageURL] placeholderImage:[UIImage llaImageWithName:@"placeHolder_750"]];
        
    }else {
        scriptImageViewHeightConstraint.constant = 0;
        scriptImageView.hidden = YES;
    }
    
    // 展开/收回
    if (currentScriptInfo.isStretched) {
        [flexContentButton setTitle:@"收起" forState:UIControlStateNormal];
    }else {
        [flexContentButton setTitle:@"展开" forState:UIControlStateNormal];
    }
    
    //参与人数
    NSMutableAttributedString *numAttStr = [[NSMutableAttributedString alloc] initWithString:
                                            [NSString stringWithFormat:@"%ld 人参与",(long)currentScriptInfo.partakeUsersArray.count]];
    [numAttStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor themeColor],NSForegroundColorAttributeName, nil] range:NSMakeRange(0, [NSString stringWithFormat:@"%ld",(long)currentScriptInfo.partakeUsersArray.count].length)];
    scriptTotalPartakeUserNumberLabel.attributedText = numAttStr;
    
    // 设置功能按钮
    [self updateFunctionButtonStatus];
    
    //flexButton 是否隐藏
    if (([LLACommonUtil calculateHeightWithAttributeDic:[NSDictionary dictionaryWithObjectsAndKeys:
          [UIFont llaFontOfSize:scriptLabelFontSize],NSFontAttributeName, nil]maxLine:maxNumberLinesWhenShrink]) > ([[self class] scriptStringSizeWithVideoInfo:currentScriptInfo maxWidth:maxWidth shouldFullHeight:YES].height)) {
        flexContentButton.hidden = YES;
    }else {
        flexContentButton.hidden = NO;
    }
    
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
                
                
                if (currentScriptInfo.partakeUsersArray.count > 0) {
                    normalString = @"选演员";
                    highlightString = @"选演员";
                    disabledString = @"选演员";
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
                normalString = [NSString stringWithFormat:@"%@ 演员拍摄中",[LLAScriptHallItemInfo timeIntervalToFormatString:currentScriptInfo.timeOutInterval]];
                highlightString = [NSString stringWithFormat:@"%@ 演员拍摄中",[LLAScriptHallItemInfo timeIntervalToFormatString:currentScriptInfo.timeOutInterval]];
                disabledString = [NSString stringWithFormat:@"%@ 演员拍摄中",[LLAScriptHallItemInfo timeIntervalToFormatString:currentScriptInfo.timeOutInterval]];
                
                normalImage = [UIImage llaImageWithName:countingImageName];
                highlighImage = [UIImage llaImageWithName:countingImageName];
                disableImage = [UIImage llaImageWithName:countingImageName];
                
                buttonEnabled = NO;
                
            }else if (currentScriptInfo.currentRole == LLAUserRoleInScript_Actor) {
                //actor
                normalString = [NSString stringWithFormat:@"%@ 上传视频",[LLAScriptHallItemInfo timeIntervalToFormatString:currentScriptInfo.timeOutInterval]];
                highlightString = [NSString stringWithFormat:@"%@ 上传视频",[LLAScriptHallItemInfo timeIntervalToFormatString:currentScriptInfo.timeOutInterval]];
                disabledString = [NSString stringWithFormat:@"%@ 上传视频",[LLAScriptHallItemInfo timeIntervalToFormatString:currentScriptInfo.timeOutInterval]];
                
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
                normalString = @"好戏上演";
                highlightString = @"好戏上演";
                disabledString = @"好戏上演";
                
                buttonEnabled = YES;
            }else if (currentScriptInfo.currentRole == LLAUserRoleInScript_Actor) {
                //actor
                
                normalString = @"好戏上演";
                highlightString = @"好戏上演";
                disabledString = @"好戏上演";
                
                buttonEnabled = YES;
                
            }else {
                //passer
                
                normalString = @"好戏上演";
                highlightString = @"好戏上演";
                disabledString = @"好戏上演";
        
                buttonEnabled = YES;
            }
        }
            
            break;
        case LLAScriptStatus_WaitForUploadTimeOut:
        {
            if (currentScriptInfo.currentRole == LLAUserRoleInScript_Director) {
                //director
                normalString = @"演员没传片";
                highlightString = @"演员没传片";
                disabledString = @"演员没传片";
                
                buttonEnabled = NO;
                
            }else if (currentScriptInfo.currentRole == LLAUserRoleInScript_Actor) {
                //actor
                normalString = @"已结束";
                highlightString = @"已结束";
                disabledString = @"已结束";
                
                buttonEnabled = NO;
            }else {
                //passer
                normalString = @"已结束";
                highlightString = @"已结束";
                disabledString = @"已结束";
                
                buttonEnabled = NO;
            }
        }
            
            break;
            
        default:
        {
            if (currentScriptInfo.currentRole == LLAUserRoleInScript_Director) {
                //director
                normalString = @"已结束";
                highlightString = @"已结束";
                disabledString = @"已结束";
                
                buttonEnabled = NO;
            }else if (currentScriptInfo.currentRole == LLAUserRoleInScript_Actor) {
                //actor
                normalString = @"已结束";
                highlightString = @"已结束";
                disabledString = @"已结束";
                
                buttonEnabled = NO;
            }else {
                //passer
                normalString = @"已结束";
                highlightString = @"已结束";
                disabledString = @"已结束";
                
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
// 设置剧本内容文字的样式
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
//    
//    NSMutableParagraphStyle *paragaph = [[NSMutableParagraphStyle alloc] init];
//    paragaph.lineSpacing = 0.5;
    //paragaph.lineBreakMode = NSLineBreakByTruncatingHead;
    
    //[attr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:paragaph,NSParagraphStyleAttributeName, nil] range:NSMakeRange(0, attr.length)];
    
    
    return attr;
    
}
// 计算剧本文字的尺寸
+ (CGSize) scriptStringSizeWithVideoInfo:(LLAScriptHallItemInfo *)scriptInfo maxWidth:(CGFloat) maxWidth shouldFullHeight:(BOOL) isFullHeight{
    
    NSAttributedString *attr = [[self class] generateScriptAttriuteStingWith:scriptInfo];
    
    CGFloat textMaxWidth = maxWidth - scriptLabelToLeft - scriptLabelToRight;
    
    //
    CGFloat maxHeight = MAXFLOAT;
    
    if (!scriptInfo.isStretched && !isFullHeight) {
        
        maxHeight = [LLACommonUtil calculateHeightWithAttributeDic:
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      [UIFont llaFontOfSize:scriptLabelFontSize],NSFontAttributeName, nil]
                                                           maxLine:maxNumberLinesWhenShrink];
        
    }else {
        maxHeight = MAXFLOAT;
    }
    
    maxWidth = MAX(0,textMaxWidth);
    
    CGSize textSize = [attr boundingRectWithSize:CGSizeMake(textMaxWidth, maxHeight)  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return textSize;
}

// 计算每个cell的高度
+ (CGFloat) calculateHeightWithInfo:(LLAScriptHallItemInfo *)scriptInfo maxWidth:(CGFloat)maxWidth {
    
    CGFloat height = 0;
    
    height += headViewToTop;
    height += headViewHeightWidth;
    height += headViewToSepLineVerSpace;
    height += sepLineHeight;
    height += sepLineToScriptLabelVerSpace;
    
    //calculate scriptLabelHeight
    height += ceilf ([[self class] scriptStringSizeWithVideoInfo:scriptInfo maxWidth: maxWidth shouldFullHeight:NO].height);
    //
    height += scriptLabelToFlexButtonVerSpace;
    height += flexButtonHeight;
    height += flexButtonToImageVerSpace;
    
    //imageView Height
    if (scriptInfo.scriptImageURL) {
        height += maxWidth - scriptLabelToLeft - scriptLabelToRight;
    }else {
        
    }
    
    height += scriptImageToScriptLineVerSpace;
    height += sepLineHeight;
    height += bottomHeight;
    
    return height;
    
}

@end
