//
//  LLAMessageCenterConversationCell.m
//  LLama
//
//  Created by Live on 16/2/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAMessageCenterConversationCell.h"

#import "LLAUserHeadView.h"

#import "LLAUser.h"
#import "LLAMessageCenterRoomInfo.h"

static const CGFloat headViewToLeft = 11;
static const CGFloat headViewHeightWidth = 34;

static const CGFloat headViewToCenterContent = 8;
static const CGFloat userNameLabelToTimeLabelHorSpace = 2;
static const CGFloat timeLabelToRight = 12;

static const CGFloat lastMessageLabelToBadgeHorSpace = 2;
static const CGFloat badgeToRight = 16;

static const CGFloat badgeViewHeight = 15;

static const CGFloat lineHeight = 0.6;

@interface LLAMessageCenterConversationCell()<LLAUserHeadViewDelegate>
{
    
    UIView *selectedCoverView;
    
    LLAUserHeadView *headView;
    
    UILabel *userNameLabel;
    UILabel *timeLabel;
    
    UILabel *lastMessageLabel;
    UIButton *badgeButton;
    
    UIView *sepLineView;
    
    //
    UIColor *backColor;
    UIColor *selectedColor;
    
    UIFont *userNameLabelFont;
    UIColor *userNameLabelTextColor;
    
    UIFont *timeLabelFont;
    UIColor *timeLabelTextColor;
    
    UIFont *lastMessageLabelFont;
    UIColor *lastMessageLabelTextColor;
    
    UIColor *badgeBackColor;
    UIFont *badgeFont;
    UIColor *badgeTextColor;
    
    UIColor *lineColor;
    
    LLAMessageCenterRoomInfo *roomInfo;
}

@end

@implementation LLAMessageCenterConversationCell

#pragma mark - Init

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self commonInit];
        
    }
    
    return self;
    
}

- (void) commonInit {
    [self initVariables];
    [self initSubViews];
    [self initConstraints];
    
    self.contentView.backgroundColor = backColor;
}

- (void) initVariables {
    
    backColor = [UIColor colorWithHex:0x211f2c];
    selectedColor = [UIColor colorWithHex:0xfffff alpha:0.2];
    
    userNameLabelFont = [UIFont boldLLAFontOfSize:15];
    userNameLabelTextColor = [UIColor whiteColor];
    
    timeLabelFont = [UIFont llaFontOfSize:12];
    timeLabelTextColor = [UIColor colorWithHex:0x807f87];
    
    lastMessageLabelFont = [UIFont llaFontOfSize:13.5];
    lastMessageLabelTextColor = [UIColor colorWithHex:0x807f87];
    
    badgeBackColor = [UIColor colorWithHex:0xf94848];
    badgeFont = [UIFont llaFontOfSize:12];
    badgeTextColor = [UIColor whiteColor];
    
    lineColor = [UIColor colorWithHex:0x1e1d28];

    
}

- (void) initSubViews {
    
    selectedCoverView = [[UIView alloc] init];
    selectedCoverView.translatesAutoresizingMaskIntoConstraints = NO;
    selectedCoverView.backgroundColor = selectedColor;
    selectedCoverView.hidden = YES;
    [self.contentView addSubview:selectedCoverView];

    
    headView = [[LLAUserHeadView alloc] init];
    headView.translatesAutoresizingMaskIntoConstraints = NO;
    headView.delegate = self;
    [self.contentView addSubview:headView];
    
    userNameLabel = [[UILabel alloc] init];
    userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    userNameLabel.font = userNameLabelFont;
    userNameLabel.textColor = userNameLabelTextColor;
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:userNameLabel];
    
    timeLabel = [[UILabel alloc] init];
    timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    timeLabel.font = timeLabelFont;
    timeLabel.textColor = timeLabelTextColor;
    timeLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:timeLabel];
    
    lastMessageLabel = [[UILabel alloc] init];
    lastMessageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    lastMessageLabel.font = lastMessageLabelFont;
    lastMessageLabel.textColor = lastMessageLabelTextColor;
    lastMessageLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:lastMessageLabel];
    
    badgeButton = [[UIButton alloc] init];
    badgeButton.translatesAutoresizingMaskIntoConstraints = NO;
    badgeButton.userInteractionEnabled = NO;
    badgeButton.titleLabel.font = badgeFont;

    badgeButton.contentEdgeInsets = UIEdgeInsetsMake(0,2,0,2);
    
    [badgeButton setBackgroundColor:badgeBackColor forState:UIControlStateNormal];
    [badgeButton setTitleColor:badgeTextColor forState:UIControlStateNormal];
    
    badgeButton.clipsToBounds = YES;
    badgeButton.layer.cornerRadius = badgeViewHeight / 2;
    
    [self.contentView addSubview:badgeButton];
    
    sepLineView = [[UIView alloc] init];
    sepLineView.translatesAutoresizingMaskIntoConstraints = NO;
    sepLineView.backgroundColor = lineColor;
    
    [self.contentView addSubview:sepLineView];
    
    [self.contentView bringSubviewToFront:selectedCoverView];

    
}

- (void) initConstraints {
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[selectedCoverView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(selectedCoverView)]];

    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:headView
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0
      constant:headViewHeightWidth]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:headView
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self.contentView
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:-(lineHeight)/2]];
    //username
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
      constraintWithItem:timeLabel
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:userNameLabel
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];

    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:lastMessageLabel
      attribute:NSLayoutAttributeBottom
      relatedBy:NSLayoutRelationEqual
      toItem:headView
      attribute:NSLayoutAttributeBottom
      multiplier:1.0
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:badgeButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:lastMessageLabel
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[sepLineView(height)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"height":@(lineHeight)}
      views:NSDictionaryOfVariableBindings(sepLineView)]];

    //horizonal
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[selectedCoverView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(selectedCoverView)]];

    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[headView(headWidth)]-(headViewToCenter)-[userNameLabel]-(nameToTime)-[timeLabel]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toLeft":@(headViewToLeft),
                @"headWidth":@(headViewHeightWidth),
                @"headViewToCenter":@(headViewToCenterContent),
                @"nameToTime":@(userNameLabelToTimeLabelHorSpace),
                @"toRight":@(timeLabelToRight)}
      views:NSDictionaryOfVariableBindings(headView,userNameLabel,timeLabel)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[headView]-(headViewToCenter)-[lastMessageLabel]-(lastToBadge)-[badgeButton(>=minWidth)]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{
                @"headViewToCenter":@(headViewToCenterContent),
                @"lastToBadge":@(lastMessageLabelToBadgeHorSpace),
                @"toRight":@(badgeToRight),
                @"minWidth":@(badgeViewHeight)}
      views:NSDictionaryOfVariableBindings(headView,lastMessageLabel,badgeButton)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[sepLineView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(sepLineView)]];

    [self.contentView addConstraints:constrArray];
    
    [userNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [lastMessageLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [badgeButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [userNameLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [timeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [lastMessageLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [badgeButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
}

#pragma mark - Selection

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    selectedCoverView.hidden = !highlighted;
}


#pragma mark - LLAHeadViewDelegate

- (void) headView:(LLAUserHeadView *)headView clickedWithUserInfo:(LLAUser *)user {
    
}

#pragma mark - Update

- (void) updateCellWithRoomInfo:(LLAMessageCenterRoomInfo *)info tableWidth:(CGFloat)width {
    
    //
    roomInfo = info;
    
    //test
    [headView updateHeadViewWithUser:[LLAUser me]];
    
    userNameLabel.text = [LLAUser me].userName;
    
    timeLabel.text = @"刚刚";
    
    lastMessageLabel.text = @"你妹的";
    
    [badgeButton setTitle:@"12" forState:UIControlStateNormal];
    
}

#pragma mark - CalculateHeight

+ (CGFloat) calculateCellHeight:(LLAMessageCenterRoomInfo *)info tableWidth:(CGFloat)width {
    return 68;
}


@end
