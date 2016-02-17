//
//  LLAHallVideoInfoCell.m
//  LLama
//
//  Created by Live on 16/1/14.
//  Copyright © 2016年 heihei. All rights reserved.
//

//view
#import "LLAHallVideoInfoCell.h"
#import "LLARewardMoneyView.h"
#import "LLAUserHeadView.h"
#import "LLAVideoCommentContentView.h"

//model
#import "LLAUser.h"
#import "LLAHallVideoItemInfo.h"

// 普通/高亮图片
static NSString *const loveVideoImageName_Normal = @"support";
static NSString *const loveVideoImageName_Highlight = @"supportH";

static NSString *const commentVideoImageName_Normal = @"message";
static NSString *const commentVideoImageName_Highlight = @"messageH";

static NSString *const shareVideoButtonImageName_Normal = @"share";
static NSString *const shareVideoButtonImageName_Highlight = @"shareH";

static NSString *const praiseNumberImageName = @"";

// 头像
static const CGFloat headViewToTop = 5.3;
static const CGFloat headViewToBorder = 30;
static const CGFloat headViewHeightWidth = 32;
static const CGFloat headViewToNameVerSpace = 2;

// 导演/演员
static const CGFloat directorLabelToLeft = 9;
static const CGFloat directorLabelToNameHorSpace = 1;
static const CGFloat roleLabelWidth = 27;
static const CGFloat nameLabelHeight = 14;

// 播放器
static const CGFloat playerViewToTop = 62;

// function按钮
static const CGFloat functionButtonsHeight = 56;
static const CGFloat functionButtonsWidth = 60;

static const CGFloat subContentToLeft = 17;
static const CGFloat timeLabelToRight = 13;

static const CGFloat seperatorLineHeight = 0.5;

static const CGFloat seperatorLineToPraiseNumbersButtonVerSpace = 4;
static const CGFloat praiseNumbersButtonHeight = 20;

static const CGFloat praiseNumbersButtonToScriptLabelVerSpace = 4;

static const CGFloat scriptLabelToTotalCommentLabelVerSpace = 17;
static const CGFloat totalCommentLabelHeight = 16;

static const CGFloat totalCommentLabelToCommentsViewVerSpace = 9;

static const CGFloat scriptLabelToBottom = 10;
static const CGFloat commentsViewToBottom = 10;

static const CGFloat bottomSepLineHeight = 0.5;

//
static const CGFloat scriptLabelFontSize = 13;

@interface LLAHallVideoInfoCell()<LLAUserHeadViewDelegate,LLAVideoCommentContentViewDelegate>
{
    // 导演
    LLAUserHeadView *directorHeadView;
    UILabel *directorLabel;
    UILabel *directorNameLabel;
    
    // 演员
    LLAUserHeadView *actorHeadView;
    UILabel *actorLabel;
    UILabel *actorNameLabel;
    
    // 片酬
    LLARewardMoneyView *rewardView;
    
    // 视频封面
    UIImageView *videoCoverImageView;

    // 点赞/评论/分享按钮
    UIButton *loveVideoButton;
    UIButton *commentVideoButton;
    UIButton *shareButton;
    
    // 发布时间
    UILabel *publishTimeLabel;
    
    // 分隔线
    UIView *seperatorLine;
    
    // 点赞数
    UIButton *praiseNumbersButton;
    
    // 剧本
    UILabel *scriptLabel;
    
    // 评论总数
    UILabel *totalCommentLabel;
    
    //
    LLAVideoCommentContentView *commentsView;
    
    // 分割线
    UIView *bottomSepLine;
    
    //font and color
    // 颜色
    UIColor *roleBackColor;
    UIColor *directorLabelTextColor;
    UIColor *actorLabelTextColor;
    UIColor *directorNameLabelTextColor;
    UIColor *actorNameLabelTextColor;
    UIColor *publishTimeLabelTextColor;
    UIColor *seperatorLineColor;
    UIColor *praiseNumberButtonTextColor;
    UIColor *scriptLabelTextColor;
    UIColor *totalCommentLabelTextColor;
    UIColor *bottomSepLineColor;
    
    // 字体
    UIFont *directorLabelFont;
    UIFont *actorLabelFont;
    UIFont *directorNameLabelFont;
    UIFont *actorNameLabelFont;
    UIFont *publishTimeLabelFont;
    UIFont *praiseNumberButtonFont;
    UIFont *scriptLabelFont;
    UIFont *totalCommentLabelFont;
    
    //
    LLAHallVideoItemInfo *currentVideoInfo;
    //
    NSLayoutConstraint *commentContentViewHeightConstraints;
    NSLayoutConstraint *actorLabelWidthConstraint;
    
}

@property(nonatomic , readwrite , strong) LLAVideoPlayerView *videoPlayerView;
@property(nonatomic , readwrite , strong) LLAVideoInfo *shouldPlayVideoInfo;

@end

@implementation LLAHallVideoInfoCell

@synthesize videoPlayerView;
@synthesize delegate;
@synthesize shouldPlayVideoInfo;

#pragma mark - Init

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 设置变量
        [self initVariables];
        // 设置子控件
        [self initSubViews];
        // 设置子控件约束
        [self initSubConstraints];
        
    }
    return self;
}

// 设置变量
- (void) initVariables {
    
    // 颜色
    roleBackColor = [UIColor themeColor];
    directorLabelTextColor = [UIColor colorWithHex:0x11111e];
    actorLabelTextColor =[UIColor colorWithHex:0x11111e];
    directorNameLabelTextColor = [UIColor colorWithHex:0x11111e];
    actorNameLabelTextColor = [UIColor colorWithHex:0x11111e];
    publishTimeLabelTextColor = [UIColor colorWithHex:0x959595];
    seperatorLineColor = [UIColor colorWithHex:0x959595];
    praiseNumberButtonTextColor = [UIColor colorWithHex:0xffc409];
    scriptLabelTextColor = [UIColor colorWithHex:0x11111e];
    totalCommentLabelTextColor = [UIColor colorWithHex:0x959595];
    bottomSepLineColor = [UIColor colorWithHex:0xededed];
    
    // 字体
    directorLabelFont = [UIFont llaFontOfSize:12];
    actorLabelFont = [UIFont llaFontOfSize:12];
    directorNameLabelFont = [UIFont llaFontOfSize:12];
    actorNameLabelFont = [UIFont llaFontOfSize:12];
    publishTimeLabelFont = [UIFont llaFontOfSize:12];
    praiseNumberButtonFont = [UIFont llaFontOfSize:12.5];
    scriptLabelFont = [UIFont llaFontOfSize:scriptLabelFontSize];
    totalCommentLabelFont = [UIFont llaFontOfSize:12.5];

}

// 设置子控件
- (void) initSubViews {
    
    // 片酬
    rewardView = [[LLARewardMoneyView alloc] init];
    rewardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:rewardView];
    
    // 导演
    directorHeadView  = [[LLAUserHeadView alloc] init];
    directorHeadView.translatesAutoresizingMaskIntoConstraints = NO;
    directorHeadView.delegate = self;
    [self.contentView addSubview:directorHeadView];
    
    directorLabel = [[UILabel alloc] init];
    directorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    directorLabel.font = directorLabelFont;
    directorLabel.textColor = directorLabelTextColor;
    directorLabel.textAlignment = NSTextAlignmentCenter;
    directorLabel.backgroundColor = roleBackColor;
    directorLabel.clipsToBounds = YES;
    directorLabel.layer.cornerRadius = 3;
    directorLabel.text = @"导演";
    [self.contentView addSubview:directorLabel];
    
    directorNameLabel = [UILabel new];
    directorNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    directorNameLabel.font = directorNameLabelFont;
    directorNameLabel.textColor = directorNameLabelTextColor;
    directorNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:directorNameLabel];
    
    // 演员
    actorHeadView = [[LLAUserHeadView alloc] init];
    actorHeadView.translatesAutoresizingMaskIntoConstraints = NO;
    actorHeadView.delegate = self;
    [self.contentView addSubview:actorHeadView];
    
    actorLabel = [UILabel new];
    actorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    actorLabel.font = actorLabelFont;
    actorLabel.textColor = actorLabelTextColor;
    actorLabel.textAlignment = NSTextAlignmentCenter;
    actorLabel.backgroundColor = roleBackColor;
    actorLabel.clipsToBounds = YES;
    actorLabel.layer.cornerRadius = 3;
    actorLabel.text = @"演员";
    [self.contentView addSubview:actorLabel];
    
    actorNameLabel = [UILabel new];
    actorNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    actorNameLabel.font = actorNameLabelFont;
    actorNameLabel.textColor = actorNameLabelTextColor;
    actorNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:actorNameLabel];
    
    // 视频封面
    videoCoverImageView = [[UIImageView alloc] init];
    videoCoverImageView.translatesAutoresizingMaskIntoConstraints = NO;
    videoCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
    videoCoverImageView.clipsToBounds = YES;
    [self.contentView addSubview:videoCoverImageView];
    
    // 视频播放器
    videoPlayerView = [[LLAVideoPlayerView alloc] init];
    videoPlayerView.translatesAutoresizingMaskIntoConstraints = NO;
    videoPlayerView.hidden = NO;
    videoPlayerView.delegate = delegate;
    [self.contentView addSubview:videoPlayerView];
    
    // 点赞按钮
    loveVideoButton = [[UIButton alloc] init];
    loveVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [loveVideoButton setImage:[UIImage llaImageWithName:loveVideoImageName_Normal] forState:UIControlStateNormal];
    [loveVideoButton setImage:[UIImage llaImageWithName:loveVideoImageName_Highlight] forState:UIControlStateHighlighted];
    [loveVideoButton setImage:[UIImage llaImageWithName:loveVideoImageName_Highlight] forState:UIControlStateSelected];
    [loveVideoButton addTarget:self action:@selector(loveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:loveVideoButton];

    // 评论按钮
    commentVideoButton = [[UIButton alloc] init];
    commentVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [commentVideoButton setImage:[UIImage llaImageWithName:commentVideoImageName_Normal] forState:UIControlStateNormal];
    [commentVideoButton setImage:[UIImage llaImageWithName:commentVideoImageName_Highlight] forState:UIControlStateHighlighted];
    [commentVideoButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:commentVideoButton];
    
    // 分享按钮
    shareButton = [[UIButton alloc] init];
    shareButton.translatesAutoresizingMaskIntoConstraints = NO;
    [shareButton setImage:[UIImage llaImageWithName:shareVideoButtonImageName_Normal] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage llaImageWithName:shareVideoButtonImageName_Highlight] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:shareButton];
    
    // 发布时间
    publishTimeLabel = [[UILabel alloc] init];
    publishTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    publishTimeLabel.font = publishTimeLabelFont;
    publishTimeLabel.textColor = publishTimeLabelTextColor;
    publishTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:publishTimeLabel];
    
    // 分割线
    seperatorLine = [[UIView alloc] init];
    seperatorLine.translatesAutoresizingMaskIntoConstraints = NO;
    seperatorLine.backgroundColor = seperatorLineColor;
    [self.contentView addSubview:seperatorLine];
    
    // 点赞数
    praiseNumbersButton = [[UIButton alloc] init];
    praiseNumbersButton.translatesAutoresizingMaskIntoConstraints = NO;
    praiseNumbersButton.userInteractionEnabled = NO;
    [praiseNumbersButton setImage:[UIImage llaImageWithName:praiseNumberImageName] forState:UIControlStateNormal];
    [praiseNumbersButton setTitleColor:praiseNumberButtonTextColor forState:UIControlStateNormal];
    praiseNumbersButton.titleLabel.font = praiseNumberButtonFont;
    [self.contentView addSubview:praiseNumbersButton];
    
    
    // 剧本
    scriptLabel = [[UILabel alloc] init];
    scriptLabel.translatesAutoresizingMaskIntoConstraints = NO;
    scriptLabel.font = scriptLabelFont;
    scriptLabel.textColor = scriptLabelTextColor;
    scriptLabel.numberOfLines = 0;
    [self.contentView addSubview:scriptLabel];
    
    // 评论总数
    totalCommentLabel = [[UILabel alloc] init];
    totalCommentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    totalCommentLabel.font = totalCommentLabelFont;
    totalCommentLabel.textColor = totalCommentLabelTextColor;
    totalCommentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:totalCommentLabel];
    
    // 评论
    commentsView = [[LLAVideoCommentContentView alloc] init];
    commentsView.translatesAutoresizingMaskIntoConstraints = NO;
    commentsView.backgroundColor = self.backgroundColor;
    commentsView.delegate = self;
    commentsView.clipsToBounds = YES;
    [self.contentView addSubview:commentsView];
    
    // 分隔线
    bottomSepLine = [[UIView alloc] init];
    bottomSepLine.translatesAutoresizingMaskIntoConstraints = NO;
    bottomSepLine.backgroundColor = bottomSepLineColor;
    [self.contentView addSubview:bottomSepLine];
    
}

// 设置子控件约束
- (void) initSubConstraints {
    
    NSMutableArray *constrArr = [NSMutableArray array];
    
    //vertical
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[rewardView(height)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(videoRewardMoneyViewHeight),@"height", nil]
      views:NSDictionaryOfVariableBindings(rewardView)]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[directorHeadView(headViewHeight)]-(headViewToName)-[directorNameLabel(nameHeight)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(headViewToTop),@"toTop",
               @(headViewHeightWidth),@"headViewHeight",
               @(headViewToNameVerSpace),@"headViewToName",
               @(nameLabelHeight),@"nameHeight", nil]
      views:NSDictionaryOfVariableBindings(directorHeadView,directorNameLabel)]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[directorHeadView]-(headViewToName)-[directorLabel(nameHeight)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(headViewToNameVerSpace),@"headViewToName",
               @(nameLabelHeight),@"nameHeight", nil]
      views:NSDictionaryOfVariableBindings(directorHeadView,directorLabel)]];
    
    //
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[actorHeadView(headViewHeight)]-(headViewToName)-[actorNameLabel(nameHeight)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(headViewToTop),@"toTop",
               @(headViewHeightWidth),@"headViewHeight",
               @(headViewToNameVerSpace),@"headViewToName",
               @(nameLabelHeight),@"nameHeight", nil]
      views:NSDictionaryOfVariableBindings(actorHeadView,actorNameLabel)]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[actorHeadView]-(headViewToName)-[actorLabel(nameHeight)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(headViewToNameVerSpace),@"headViewToName",
               @(nameLabelHeight),@"nameHeight", nil]
      views:NSDictionaryOfVariableBindings(actorHeadView,actorLabel)]];
    
    //
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[videoCoverImageView]-(0)-[loveVideoButton(loveButtonHeight)]-(0)-[seperatorLine(sepLineHeight)]-(lineToPraiseNumber)-[praiseNumbersButton(praiseNumHeight)]-(praiseNumerToScriptLabel)-[scriptLabel]-(scriptLabelToTotalComment)-[totalCommentLabel(totalCommentHeight)]-(totalCommentToCommentsView)-[commentsView(15)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(playerViewToTop),@"toTop",
               @(functionButtonsHeight),@"loveButtonHeight",
               @(seperatorLineHeight),@"sepLineHeight",
               @(seperatorLineToPraiseNumbersButtonVerSpace),@"lineToPraiseNumber",
               @(praiseNumbersButtonHeight),@"praiseNumHeight",
               @(praiseNumbersButtonToScriptLabelVerSpace),@"praiseNumerToScriptLabel",
               @(scriptLabelToTotalCommentLabelVerSpace),@"scriptLabelToTotalComment",
               @(totalCommentLabelHeight),@"totalCommentHeight",
               @(totalCommentLabelToCommentsViewVerSpace),@"totalCommentToCommentsView", nil]
      views:NSDictionaryOfVariableBindings(videoCoverImageView,loveVideoButton,seperatorLine,praiseNumbersButton,scriptLabel,totalCommentLabel,commentsView)]];
    
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:videoCoverImageView
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:self.contentView
      attribute:NSLayoutAttributeWidth
      multiplier:1.0
      constant:0]];
    
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:videoPlayerView
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:videoCoverImageView
      attribute:NSLayoutAttributeHeight
      multiplier:1.0
      constant:0]];
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:videoPlayerView
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:videoCoverImageView
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[videoCoverImageView]-(0)-[commentVideoButton]-(0)-[seperatorLine]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(videoCoverImageView,commentVideoButton,seperatorLine)]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[videoCoverImageView]-(0)-[shareButton]-(0)-[seperatorLine]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(videoCoverImageView,shareButton,seperatorLine)]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[videoCoverImageView]-(0)-[publishTimeLabel]-(0)-[seperatorLine]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(videoCoverImageView,publishTimeLabel,seperatorLine)]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[bottomSepLine(height)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(bottomSepLineHeight),@"height", nil]
      views:NSDictionaryOfVariableBindings(bottomSepLine)]];
    
    //horizonal
    
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:rewardView
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0
      constant:videoRewardMoneyViewWidth]];
    
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:rewardView
      attribute:NSLayoutAttributeCenterX
      relatedBy:NSLayoutRelationEqual
      toItem:self.contentView
      attribute:NSLayoutAttributeCenterX
      multiplier:1.0
      constant:0]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[directorHeadView(width)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(headViewToBorder),@"toLeft",
               @(headViewHeightWidth),@"width", nil]
      views:NSDictionaryOfVariableBindings(directorHeadView)]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[directorLabel(width)]-(directorToName)-[directorNameLabel]-(0)-[rewardView]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(directorLabelToLeft),@"toLeft",
               @(roleLabelWidth),@"width",
               @(directorLabelToNameHorSpace),@"directorToName", nil]
      views:NSDictionaryOfVariableBindings(directorLabel,directorNameLabel,rewardView)]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[actorHeadView(width)]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(headViewToBorder),@"toRight",
               @(headViewHeightWidth),@"width", nil]
      views:NSDictionaryOfVariableBindings(actorHeadView)]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[actorLabel(width)]-(directorToName)-[actorNameLabel(<=100)]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(directorLabelToLeft),@"toRight",
               @(roleLabelWidth),@"width",
               @(directorLabelToNameHorSpace),@"directorToName", nil]
      views:NSDictionaryOfVariableBindings(actorLabel,actorNameLabel,rewardView)]];
    
    //
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[videoCoverImageView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(videoCoverImageView)]];
    
    [constrArr addObject:
     [NSLayoutConstraint
      constraintWithItem:videoPlayerView
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:videoCoverImageView
      attribute:NSLayoutAttributeWidth
      multiplier:1.0
      constant:0]];
    
    //
    
//    [publishTimeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    [loveVideoButton setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
//    [commentVideoButton setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
//    [shareButton setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [publishTimeLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [loveVideoButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [commentVideoButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [shareButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[loveVideoButton(width)]-(0)-[commentVideoButton(width)]-(0)-[shareButton(width)]-(0)-[publishTimeLabel]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(subContentToLeft),@"toLeft",
               @(functionButtonsWidth),@"width",
               @(timeLabelToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(loveVideoButton,commentVideoButton,shareButton,publishTimeLabel)]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[seperatorLine]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(subContentToLeft),@"toLeft",
               @(timeLabelToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(seperatorLine)]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[praiseNumbersButton]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(subContentToLeft),@"toLeft",nil]
      views:NSDictionaryOfVariableBindings(praiseNumbersButton)]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[scriptLabel]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(subContentToLeft),@"toLeft",
               @(timeLabelToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(scriptLabel)]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[totalCommentLabel]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(subContentToLeft),@"toLeft",
               @(timeLabelToRight),@"toRight",nil]
      views:NSDictionaryOfVariableBindings(totalCommentLabel)]];
    
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[commentsView]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(subContentToLeft),@"toLeft",
               @(timeLabelToRight),@"toRight",nil]
      views:NSDictionaryOfVariableBindings(commentsView)]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[bottomSepLine]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(bottomSepLine)]];
    
    //
    for (NSLayoutConstraint *constr in constrArr) {
        if (constr.firstItem == commentsView && constr.firstAttribute == NSLayoutAttributeHeight) {
            commentContentViewHeightConstraints = constr;
        }else if (constr.firstAttribute == NSLayoutAttributeWidth && constr.firstItem == actorNameLabel) {
            actorLabelWidthConstraint = constr;
        }else {
            if (actorLabelWidthConstraint && commentContentViewHeightConstraints) {
                break;
            }
        }
        
    }
    
    //
    [self.contentView addConstraints:constrArr];
}

#pragma mark - UserHeadViewDelegate
// 点击头像
- (void) headView:(LLAUserHeadView *)headView clickedWithUserInfo:(LLAUser *)user {
    if (delegate && [delegate respondsToSelector:@selector(userHeadViewClickedWithUserInfo:itemInfo:)]) {
        [delegate userHeadViewClickedWithUserInfo:user itemInfo:currentVideoInfo];
    }
}

#pragma mark - ButtonClicked
// 点击点赞按钮
- (void)loveButtonClicked:(UIButton *)sender {
    
    if (delegate && [delegate respondsToSelector:@selector(loveVideoWithVideoItemInfo:loveButton:)]) {
        [delegate loveVideoWithVideoItemInfo:currentVideoInfo loveButton:sender];
    }
    
}
// 点击评论按钮
- (void) commentButtonClicked:(UIButton *)sender {
    if (delegate && [delegate respondsToSelector:@selector(commentVideoWithVideoItemInfo:)]) {
        [delegate commentVideoWithVideoItemInfo:currentVideoInfo];
    }

}
// 点击分享按钮
- (void) shareButtonClicked:(UIButton *) sender {
    if (delegate && [delegate respondsToSelector:@selector(shareVideoWithVideoItemInfo:)]) {
        [delegate shareVideoWithVideoItemInfo:currentVideoInfo];
    }
}

#pragma mark - LLAVideoCommentContentViewDelegate
// 点击用户名
- (void) commentViewUserNameClickedWithUserInfo:(LLAUser *)userInfo commentInfo:(LLAHallVideoCommentItem *)commentInfo {
    if (delegate && [delegate respondsToSelector:@selector(chooseUserFromComment:userInfo:videoInfo:)]) {
        [delegate chooseUserFromComment:commentInfo userInfo:userInfo videoInfo:currentVideoInfo];
    }
}

- (void) commentViewClickedWithCommentInfo:(LLAHallVideoCommentItem *)commentInfo {
    if (delegate && [delegate respondsToSelector:@selector(commentVideoChooseWithCommentInfo:videoItemInfo:)]) {
        [delegate commentVideoChooseWithCommentInfo:commentInfo videoItemInfo:currentVideoInfo];
    }
}

#pragma mark - Update
// 设置数据
- (void) updateCellWithVideoInfo:(LLAHallVideoItemInfo *)videoInfo tableWidth:(CGFloat)tableWidth {
    
    currentVideoInfo = videoInfo;
    
    //
    
    [rewardView updateViewWithRewardMoney:currentVideoInfo.rewardMoney];
    
    [directorHeadView updateHeadViewWithUser:currentVideoInfo.directorInfo];
    directorNameLabel.text = currentVideoInfo.directorInfo.userName;
    
    [actorHeadView updateHeadViewWithUser:currentVideoInfo.actorInfo];
    actorNameLabel.text = currentVideoInfo.actorInfo.userName;
    
    //update constraint
    actorLabelWidthConstraint.constant = (tableWidth - videoRewardMoneyViewWidth)/2 - directorLabelToLeft - roleLabelWidth;
    
    [videoCoverImageView setImageWithURL:[NSURL URLWithString:currentVideoInfo.videoCoverImageURL] placeholderImage:[UIImage llaImageWithName:@"placeHolder_750"]];
    
    loveVideoButton.selected = currentVideoInfo.hasPraised;
    if (loveVideoButton.selected) {
        loveVideoButton.userInteractionEnabled = NO;
    }else {
        loveVideoButton.userInteractionEnabled = YES;
    }
    
    publishTimeLabel.text = currentVideoInfo.videoUploadTimeString;
    
    [praiseNumbersButton setTitle:[NSString stringWithFormat:@" %ld次赞",(long)currentVideoInfo.praiseNumbers] forState:UIControlStateNormal];
    
    scriptLabel.attributedText = [[self class] generateScriptAttriuteStingWith:currentVideoInfo];
    
    totalCommentLabel.text = [NSString stringWithFormat:@"总共%ld条评论",(long)currentVideoInfo.commentNumbers];
    
    if (currentVideoInfo.commentArray > 0) {
        
        commentsView.hidden = NO;
        
        CGFloat maxWidth = tableWidth-subContentToLeft-timeLabelToRight;
        
        commentContentViewHeightConstraints.constant = [LLAVideoCommentContentView calculateHeightWithCommentsInfo:currentVideoInfo.commentArray maxWidth:maxWidth];
        
        [commentsView updateCommentContentViewWithInfo:currentVideoInfo.commentArray maxWidth:maxWidth];
        
    }else {
        commentsView.hidden = YES;
    }
    
    //player view
    //videoPlayerView.playingVideoInfo = videoInfo.videoInfo;
    shouldPlayVideoInfo = videoInfo.videoInfo;
    
    [videoPlayerView updateCoverImageWithVideoInfo:shouldPlayVideoInfo];
    
    //
}

#pragma mark - Calculate Height
// 返回属性文字
+ (NSAttributedString *) generateScriptAttriuteStingWith:(LLAHallVideoItemInfo *) videoInfo {
    
    NSString *scriptString = [videoInfo.scriptContent copy];
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

// 返回文字尺寸
+ (CGSize) scriptStringSizeWithVideoInfo:(LLAHallVideoItemInfo *)videoInfo tableWidth:(CGFloat) tableWidth {
    
    NSAttributedString *attr = [[self class] generateScriptAttriuteStingWith:videoInfo];
    
    CGFloat maxWidth = MAX(0,tableWidth - subContentToLeft - timeLabelToRight);
    
    return [attr boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)  options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}

// 返回cell高度
+ (CGFloat) calculateHeightWithVideoInfo:(LLAHallVideoItemInfo *)videoInfo tableWidth:(CGFloat)tableWith {
    
    CGFloat height = 0;
    
    height += playerViewToTop;
    height += tableWith;
    height += functionButtonsHeight;
    height += seperatorLineHeight;
    height += seperatorLineToPraiseNumbersButtonVerSpace;
    height += praiseNumbersButtonHeight;
    height += praiseNumbersButtonToScriptLabelVerSpace;
    
    height += [self scriptStringSizeWithVideoInfo:videoInfo tableWidth:tableWith].height;
    height += scriptLabelToTotalCommentLabelVerSpace;
    height += totalCommentLabelHeight;
    
    if (videoInfo.commentArray.count > 0) {
        
        height += totalCommentLabelToCommentsViewVerSpace;
        height += [LLAVideoCommentContentView calculateHeightWithCommentsInfo:videoInfo.commentArray maxWidth:tableWith-subContentToLeft-timeLabelToRight];
        height += commentsViewToBottom;
        
    }else {
        height += scriptLabelToBottom;
    }
    
    height += bottomSepLineHeight;
    
    return height;
    
}

#pragma mark -

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
