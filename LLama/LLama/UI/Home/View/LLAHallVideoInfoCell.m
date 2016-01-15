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

static NSString *const loveVideoImageName_Normal = @"support";
static NSString *const loveVideoImageName_Highlight = @"supportH";

static NSString *const commentVideoImageName_Normal = @"message";
static NSString *const commentVideoImageName_Highlight = @"messageH";

static NSString *const shareVideoButtonImageName_Normal = @"share";
static NSString *const shareVideoButtonImageName_Highlight = @"shareH";

//

static const CGFloat headViewToTop = 5.3;
static const CGFloat headViewToBorder = 30;
static const CGFloat headViewHeightWidth = 32;
static const CGFloat headViewToNameVerSpace = 2;

static const CGFloat directorLabelToLeft = 9;
static const CGFloat directorLabelToNameHorSpace = 1;
static const CGFloat roleLabelWidth = 16;
static const CGFloat nameLabelHeight = 14;

static const CGFloat playerViewToTop = 62;

static const CGFloat functionButtonsHeight = 56;

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

//
static const CGFloat scriptLabelFontSize = 13;

@interface LLAHallVideoInfoCell()<LLAUserHeadViewDelegate,LLAVideoCommentContentViewDelegate>
{
    LLAUserHeadView *directorHeadView;
    UILabel *directorLabel;
    UILabel *directorNameLabel;
    
    LLAUserHeadView *actorHeadView;
    UILabel *actorLabel;
    UILabel *actorNameLabel;
    
    LLARewardMoneyView *rewardView;
    
    UIImageView *videoCoverImageView;
    
    UIButton *loveVideoButton;
    UIButton *commentVideoButton;
    UIButton *shareButton;
    
    UILabel *publishTimeLabel;
    
    UIView *seperatorLine;
    
    UIButton *praiseNumbersButton;
    
    UILabel *scriptLabel;
    
    UILabel *totalCommentLabel;
    
    LLAVideoCommentContentView *commentsView;
    
    //font and color
    
    UIColor *roleBackColor;
    
    UIFont *directorLabelFont;
    UIColor *directorLabelTextColor;
    
    UIFont *actorLabelFont;
    UIColor *actorLabelTextColor;
    
    UIFont *directorNameLabelFont;
    UIColor *directorNameLabelTextColor;
    
    UIFont *actorNameLabelFont;
    UIColor *actorNameLabelTextColor;
    
    UIFont *publishTimeLabelFont;
    UIColor *publishTimeLabelTextColor;
    
    UIColor *seperatorLineColor;
    
    UIFont *praiseNumberButtonFont;
    UIColor *praiseNumberButtonTextColor;
    
    UIFont *scriptLabelFont;
    UIColor *scriptLabelTextColor;
    
    UIFont *totalCommentLabelFont;
    UIColor *totalCommentLabelTextColor;
    
    //
    LLAHallVideoItemInfo *currentVideoInfo;
    
    //
    NSLayoutConstraint *commentContentViewHeightConstraints;
    
}

@property(nonatomic , readwrite , strong) LLAVideoPlayerView *videoPlayerView;

@end

@implementation LLAHallVideoInfoCell

@synthesize videoPlayerView;
@synthesize delegate;

#pragma mark - Init

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
        
    }
    return self;
}

- (void) initVariables {
    
    roleBackColor = [UIColor themeColor];
    
    directorLabelFont = [UIFont llaFontOfSize:12];
    directorLabelTextColor = [UIColor colorWithHex:0x11111e];
    
    actorLabelFont = [UIFont llaFontOfSize:12];
    actorLabelTextColor =[UIColor colorWithHex:0x11111e];
    
    directorNameLabelFont = [UIFont llaFontOfSize:12];
    directorNameLabelTextColor = [UIColor colorWithHex:0x11111e];
    
    actorNameLabelFont = [UIFont llaFontOfSize:12];
    actorNameLabelTextColor = [UIColor colorWithHex:0x11111e];
    
    publishTimeLabelFont = [UIFont llaFontOfSize:12];
    publishTimeLabelTextColor = [UIColor colorWithHex:0x959595];
    
    seperatorLineColor = [UIColor colorWithHex:0x959595];
    
    praiseNumberButtonFont = [UIFont llaFontOfSize:12.5];
    praiseNumberButtonTextColor = [UIColor colorWithHex:0xffc409];
    
    scriptLabelFont = [UIFont llaFontOfSize:scriptLabelFontSize];
    scriptLabelTextColor = [UIColor colorWithHex:0x11111e];
    
    totalCommentLabelFont = [UIFont llaFontOfSize:12.5];
    totalCommentLabelTextColor = [UIColor colorWithHex:0x959595];

}

- (void) initSubViews {
    
    rewardView = [[LLARewardMoneyView alloc] init];
    rewardView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:rewardView];
    
    //
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
    
    //
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
    
    //
    videoCoverImageView = [[UIImageView alloc] init];
    videoCoverImageView.translatesAutoresizingMaskIntoConstraints = NO;
    videoCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.contentView addSubview:videoCoverImageView];
    
    //
    videoPlayerView = [[LLAVideoPlayerView alloc] init];
    
    [self.contentView addSubview:videoPlayerView];
    
    //
    loveVideoButton = [[UIButton alloc] init];
    loveVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [loveVideoButton setImage:[UIImage llaImageWithName:loveVideoImageName_Normal] forState:UIControlStateNormal];
    [loveVideoButton setImage:[UIImage llaImageWithName:loveVideoImageName_Highlight] forState:UIControlStateHighlighted];
    [loveVideoButton setImage:[UIImage llaImageWithName:loveVideoImageName_Highlight] forState:UIControlStateSelected];
    
    [loveVideoButton addTarget:self action:@selector(loveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:loveVideoButton];
    //
    commentVideoButton = [[UIButton alloc] init];
    commentVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [commentVideoButton setImage:[UIImage llaImageWithName:commentVideoImageName_Normal] forState:UIControlStateNormal];
    [commentVideoButton setImage:[UIImage llaImageWithName:commentVideoImageName_Highlight] forState:UIControlStateHighlighted];
    
    [commentVideoButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:commentVideoButton];
    
    //
    shareButton = [[UIButton alloc] init];
    shareButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [shareButton setImage:[UIImage llaImageWithName:shareVideoButtonImageName_Normal] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage llaImageWithName:shareVideoButtonImageName_Highlight] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:shareButton];
    
    publishTimeLabel = [[UILabel alloc] init];
    publishTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    publishTimeLabel.font = publishTimeLabelFont;
    publishTimeLabel.textColor = publishTimeLabelTextColor;
    publishTimeLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:publishTimeLabel];
    
    //
    seperatorLine = [[UIView alloc] init];
    seperatorLine.translatesAutoresizingMaskIntoConstraints = NO;
    seperatorLine.backgroundColor = seperatorLineColor;
    
    [self.contentView addSubview:seperatorLine];
    
    //script Label
    scriptLabel = [[UILabel alloc] init];
    scriptLabel.translatesAutoresizingMaskIntoConstraints = NO;
    scriptLabel.font = scriptLabelFont;
    scriptLabel.textColor = scriptLabelTextColor;
    
    [self.contentView addSubview:scriptLabel];
    
    totalCommentLabel = [[UILabel alloc] init];
    totalCommentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    totalCommentLabel.font = totalCommentLabelFont;
    totalCommentLabel.textColor = totalCommentLabelTextColor;
    totalCommentLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:totalCommentLabel];
    //sub replys
    
    commentsView = [[LLAVideoCommentContentView alloc] init];
    commentsView.translatesAutoresizingMaskIntoConstraints = NO;
    commentsView.delegate = self;
    
    [self.contentView addSubview:commentsView];
    
}

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
      constraintsWithVisualFormat:@"V:|-(toTop)-[directorHeadView(headViewHeight)]-(headViewToName)-[directorNameLabel(nameLabelHeight)]"
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
      constraintsWithVisualFormat:@"V:|-(toTop)-[actorHeadView(headViewHeight)]-(headViewToName)-[actorNameLabel(nameLabelHeight)]"
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
      constraintsWithVisualFormat:@"V:|-(toTop)-[videoCoverImageView]-(0)-[loveVideoButton(loveButtonHeight)]-(0)-[seperatorLine(sepLineHeight)]-(lineToPraiseNumber)-[praiseNumbersButton(praiseNumHeight)]-(praiseNumerToScriptLabel)-[scriptLabel]-(scriptLabelToTotalComment)-[totalCommentLabel(totalCommentHeight)]-(totalCommentToCommentsView)-[commentsView(10)]"
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
      constraintsWithVisualFormat:@"H:|-(0)-[directorHeadView(width)]"
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
      constraintsWithVisualFormat:@"H:[actorLabel(width)]-(directorToName)-[actorNameLabel]-(toRight)-|"
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
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[loveVideoButton]-(0)-[commentVideoButton]-(0)-[shareButton]-(0)-[publishTimeLabel]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(subContentToLeft),@"toLeft",
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
    
    //
    for (NSLayoutConstraint *constr in constrArr) {
        if (constrArr.firstObject == commentsView && constr.firstAttribute == NSLayoutAttributeHeight) {
            commentContentViewHeightConstraints = constr;
            break;
        }
    }
    
    //
    [self.contentView addConstraints:constrArr];
}

#pragma mark - UserHeadViewDelegate

- (void) headView:(LLAUserHeadView *)headView clickedWithUserInfo:(LLAUser *)user {
    
}

#pragma mark - ButtonClicked

- (void)loveButtonClicked:(UIButton *)sender {
    
    if (delegate && [delegate respondsToSelector:@selector(loveVideoWithVideoItemInfo:loveButton:)]) {
        [delegate loveVideoWithVideoItemInfo:currentVideoInfo loveButton:sender];
    }
    
}

- (void) commentButtonClicked:(UIButton *)sender {
    if (delegate && [delegate respondsToSelector:@selector(commentVideoWithVideoItemInfo:)]) {
        [delegate commentVideoWithVideoItemInfo:currentVideoInfo];
    }

}

- (void) shareButtonClicked:(UIButton *) sender {
    if (delegate && [delegate respondsToSelector:@selector(shareVideoWithVideoItemInfo:)]) {
        [delegate shareVideoWithVideoItemInfo:currentVideoInfo];
    }
}

#pragma mark - LLAVideoCommentContentViewDelegate

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

- (void) updateCellWithVideoInfo:(LLAHallVideoItemInfo *)videoInfo tableWidth:(CGFloat)tableWidth {
    
    currentVideoInfo = videoInfo;
    
    //
    
    [rewardView updateViewWithRewardMoney:currentVideoInfo.rewardMoney];
    
    [directorHeadView updateHeadViewWithUser:currentVideoInfo.directorInfo];
    directorNameLabel.text = currentVideoInfo.directorInfo.userName;
    
    [actorHeadView updateHeadViewWithUser:currentVideoInfo.actorInfo];
    actorNameLabel.text = currentVideoInfo.actorInfo.userName;
    
    [videoCoverImageView setImageWithURL:[NSURL URLWithString:currentVideoInfo.videoCoverImageURL] placeholderImage:nil];
    
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
    
}

#pragma mark - Calculate Height

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

+ (CGSize) scriptStringSizeWithVideoInfo:(LLAHallVideoItemInfo *)videoInfo tableWidth:(CGFloat) tableWidth {
    
    NSAttributedString *attr = [[self class] generateScriptAttriuteStingWith:videoInfo];
    
    CGFloat maxWidth = MAX(0,tableWidth - subContentToLeft - timeLabelToRight);
    
    return [attr boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)  options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}

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
