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
    
    
}

@property(nonatomic , readwrite , strong) LLAVideoPlayerView *videoPlayerView;

@end

@implementation LLAHallVideoInfoCell

@synthesize videoPlayerView;

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
    
    scriptLabelFont = [UIFont llaFontOfSize:13];
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
}

#pragma mark - UserHeadViewDelegate

- (void) headView:(LLAUserHeadView *)headView clickedWithUserInfo:(LLAUser *)user {
    
}

#pragma mark - ButtonClicked

- (void)loveButtonClicked:(UIButton *)sender {
    
}

- (void) commentButtonClicked:(UIButton *)sender {
    
}

- (void) shareButtonClicked:(UIButton *) sender {
    
}

#pragma mark - LLAVideoCommentContentViewDelegate

#pragma mark - Update

#pragma mark - Calculate Height



#pragma mark -

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
