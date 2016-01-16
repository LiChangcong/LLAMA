//
//  LLAScriptHallInfoCell.m
//  LLama
//
//  Created by Live on 16/1/16.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAScriptHallInfoCell.h"
#import "LLAUserHeadView.h"
#import "LLARewardMoneyView.h"

//model
#import "LLAScriptHallItemInfo.h"

//

static const CGFloat scriptLabelFontSize = 14;

//

static const CGFloat backViewToBottom = 12;

static const CGFloat headViewToTop = 26;
static const CGFloat headViewHeightWidth = 42;
static const CGFloat headViewToLeft = 21;
static const CGFloat headViewToNameLabelHorSpace = 12;

static const CGFloat rewardViewToTop = 13;
static const CGFloat rewardViewToRight = 14;

static const CGFloat headViewToSepLineVerSpace = 12;

static const CGFloat sepLineHeight = 0.5;
static const CGFloat sepLineToLeft = 14;
static const CGFloat sepLineToRight = 14;
static const CGFloat sepLineToImageViewVerSpace = 8;

static const CGFloat scriptImageViewHeightWidth = 84;
static const CGFloat scriptImageViewToLeft = 14;
static const CGFloat scriptImageViewToScriptLabelHorSpace = 8;
static const CGFloat scriptLabelToRight = 18;
static const CGFloat scriptLabelToLeftWithoutImage = 18;

static const CGFloat scriptImageViewToPartakeNumberVerSpace = 8;
static const CGFloat partakeNumberToRight = 18;
static const CGFloat partakeNumbersToBottom = 17;
static const CGFloat partakeNumbersHeight = 14.5;


@interface LLAScriptHallInfoCell()<LLAUserHeadViewDelegate>
{
    UIView *backView;
    
    LLAUserHeadView *headView;
    UILabel *userNameLabel;
    UILabel *publishTimeLabel;
    
    LLARewardMoneyView *rewardView;
    
    UIView *seperatorLineView;
    
    UIImageView *scriptImageView;
    UILabel *scriptContentLabel;
    
    UILabel *scriptTotalPartakeUserNumberLabel;
    
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
    
    //
    NSLayoutConstraint *scriptLabelToLeftConstraints;
    
    LLAScriptHallItemInfo *currentScriptInfo;
    
}

@end

@implementation LLAScriptHallInfoCell

@synthesize delegate;

#pragma mark - Init

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
        
        self.contentView.backgroundColor = contentViewBKColor;
        
    }
    return self;
}

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
}

- (void) initSubViews {
    
    backView = [[UIView alloc] init];
    backView.translatesAutoresizingMaskIntoConstraints = NO;
    backView.backgroundColor = backViewBKColor;
    
    [self.contentView addSubview:backView];
    
    //
    headView = [[LLAUserHeadView alloc] init];
    headView.translatesAutoresizingMaskIntoConstraints = NO;
    headView.delegate = self;
    
    [backView addSubview:headView];
    
    userNameLabel = [[UILabel alloc] init];
    userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    userNameLabel.font = userNameLabelFont;
    userNameLabel.textColor = userNameLabelTextColor;
    
    [backView addSubview:userNameLabel];
    
    publishTimeLabel = [[UILabel alloc] init];
    publishTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    publishTimeLabel.textAlignment = NSTextAlignmentLeft;
    publishTimeLabel.font = publishTimeLabelFont;
    publishTimeLabel.textColor = publishTimeLabelTextColor;
    
    [backView addSubview:publishTimeLabel];
    
    rewardView = [[LLARewardMoneyView alloc] init];
    rewardView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [backView addSubview:rewardView];
    
    //
    seperatorLineView = [[UIView alloc] init];
    seperatorLineView.translatesAutoresizingMaskIntoConstraints = NO;
    seperatorLineView.backgroundColor = sepLineColor;
    
    [backView addSubview:seperatorLineView];
    
    scriptImageView = [[UIImageView alloc] init];
    scriptImageView.translatesAutoresizingMaskIntoConstraints = NO;
    scriptImageView.contentMode = UIViewContentModeScaleAspectFill;
    scriptImageView.clipsToBounds = YES;
    
    [backView addSubview:scriptImageView];
    
    scriptContentLabel = [[UILabel alloc] init];
    scriptContentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    scriptContentLabel.numberOfLines = 0;
    scriptContentLabel.textAlignment = NSTextAlignmentLeft;
    scriptContentLabel.contentMode = UIViewContentModeTop;
    
    [backView addSubview:scriptContentLabel];
    
    scriptTotalPartakeUserNumberLabel = [[UILabel alloc] init];
    scriptTotalPartakeUserNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    scriptTotalPartakeUserNumberLabel.textAlignment = NSTextAlignmentRight;
    scriptTotalPartakeUserNumberLabel.font = scriptTotalPartakeUserNumberLabelFont;
    scriptTotalPartakeUserNumberLabel.textColor = scriptTotalPartakeUserNumberLabelTextColor;
    
    [backView addSubview:scriptTotalPartakeUserNumberLabel];
    
    
}

- (void) initSubConstraints {
    
    //backView
    
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
    
    //sub view on backView
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    
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
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:publishTimeLabel
      attribute:NSLayoutAttributeLeading
      relatedBy:NSLayoutRelationEqual
      toItem:userNameLabel
      attribute:NSLayoutAttributeLeading
      multiplier:1.0
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:publishTimeLabel
      attribute:NSLayoutAttributeTrailing
      relatedBy:NSLayoutRelationEqual
      toItem:userNameLabel
      attribute:NSLayoutAttributeTrailing
      multiplier:1.0
      constant:0]];
    
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
      constraintsWithVisualFormat:@"H:|-(toLeft)-[scriptTotalPartakeUserNumberLabel]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(scriptLabelToLeftWithoutImage),@"toLeft",
               @(partakeNumberToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(scriptTotalPartakeUserNumberLabel)]];
    
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

#pragma mark - Update

- (void) updateCellWithScriptInfo:(LLAScriptHallItemInfo *)scriptInfo tableWidth:(CGFloat)tableWidth {
    
    currentScriptInfo = scriptInfo;
    
    [headView updateHeadViewWithUser:currentScriptInfo.directorInfo];
    publishTimeLabel.text = currentScriptInfo.publisthTimeString;
    userNameLabel.text = currentScriptInfo.directorInfo.userName;
    
    [rewardView updateViewWithRewardMoney:currentScriptInfo.rewardMoney];
    
    if (currentScriptInfo.scriptImageURL) {
        scriptImageView.hidden = NO;
        
        scriptLabelToLeftConstraints.constant = scriptImageViewToLeft + scriptImageViewHeightWidth + scriptImageViewToScriptLabelHorSpace;
        
        [scriptImageView setImageWithURL:[NSURL URLWithString:currentScriptInfo.scriptImageURL] placeholderImage:nil];
        
    }else {
        scriptImageView.hidden = YES;
        scriptLabelToLeftConstraints.constant = scriptLabelToLeftWithoutImage;
    }
    
    scriptContentLabel.attributedText = [[self class] generateScriptAttriuteStingWith:currentScriptInfo];
    
    NSMutableAttributedString *numAttStr = [[NSMutableAttributedString alloc] initWithString:
                                            [NSString stringWithFormat:@"%ld人参与",(long)currentScriptInfo.partakeUsersArray.count]];
    [numAttStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor themeColor],NSForegroundColorAttributeName, nil] range:NSMakeRange(0, [NSString stringWithFormat:@"%ld",(long)currentScriptInfo.partakeUsersArray.count].length)];
    
    scriptTotalPartakeUserNumberLabel.attributedText = numAttStr;
    
}

#pragma mark - Calculate Cell Height

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

+ (CGSize) scriptStringSizeWithVideoInfo:(LLAScriptHallItemInfo *)scriptInfo tableWidth:(CGFloat) tableWidth {
    
    NSAttributedString *attr = [[self class] generateScriptAttriuteStingWith:scriptInfo];
    
    CGFloat maxWidth = tableWidth - scriptLabelToLeftWithoutImage - scriptLabelToRight;
    
    if (scriptInfo.scriptImageURL) {
        maxWidth = tableWidth - scriptImageViewToLeft - scriptImageViewHeightWidth - scriptImageViewToScriptLabelHorSpace - scriptLabelToRight;
    }
    
    maxWidth = MAX(0,tableWidth);
    
    return [attr boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)  options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}



+ (CGFloat) calculateHeightWithScriptInfo:(LLAScriptHallItemInfo *)scriptInfo tableWidth:(CGFloat)tableWidth {
    
    CGFloat height = 0;
    
    height += headViewToTop;
    height += headViewHeightWidth;
    height += headViewToSepLineVerSpace;
    height += sepLineHeight;
    height += sepLineToImageViewVerSpace;
    if (scriptInfo.scriptImageURL) {
        height += scriptImageViewHeightWidth;
    }else {
        //get text heigh
        height += [self scriptStringSizeWithVideoInfo:scriptInfo tableWidth:tableWidth].height;
    }
    
    height += scriptImageViewToPartakeNumberVerSpace;
    height += partakeNumbersHeight;
    height += partakeNumbersToBottom;
    height += backViewToBottom;
    
    return height;
}

@end
