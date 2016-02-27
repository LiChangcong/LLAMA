//
//  LLAMessageReceivedPraiseCell.m
//  LLama
//
//  Created by Live on 16/2/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAMessageReceivedPraiseCell.h"

#import "LLAUserHeadView.h"

#import "LLAMessageReceivedPraiseItemInfo.h"

static const CGFloat headViewToLeft = 11;
static const CGFloat headViewHeightWidth = 34;

static const CGFloat headViewToCenterContent = 8;
static const CGFloat messageLabelToImageHorSpace = 2;
static const CGFloat infoImageViewHeightWidth = 46;
static const CGFloat infoImageViewToRight = 8;

static const CGFloat timeLabelToInfoImageHorSpace = 2;

static const CGFloat lineHeight = 0.6;



@interface LLAMessageReceivedPraiseCell()<LLAUserHeadViewDelegate>
{
    
    UIView *selectedCoverView;
    
    LLAUserHeadView *headView;
    
    UILabel *messageLabel;
    UILabel *timeLabel;
    
    UIImageView *infoImageView;
    
    UIView *sepLineView;
    
    //
    UIColor *backColor;
    UIColor *selectedColor;
    
    UIFont *messageLabelFont;
    UIColor *messageLabelTextColor;
    
    UIFont *timeLabelFont;
    UIColor *timeLabelTextColor;
    
    UIColor *lineColor;
    
    //
    NSLayoutConstraint *messageToRightConstraints;
    NSLayoutConstraint *timeToRightConstraints;
    
    //
    LLAMessageReceivedPraiseItemInfo *praiseInfo;
}

@end

@implementation LLAMessageReceivedPraiseCell

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
    
    messageLabelFont = [UIFont boldLLAFontOfSize:15];
    messageLabelTextColor = [UIColor whiteColor];
    
    timeLabelFont = [UIFont llaFontOfSize:12];
    timeLabelTextColor = [UIColor colorWithHex:0x807f87];
    
    lineColor = [UIColor colorWithHex:0x1e1d22];
    
    
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
    
    messageLabel = [[UILabel alloc] init];
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    messageLabel.font = messageLabelFont;
    messageLabel.textColor = messageLabelTextColor;
    messageLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:messageLabel];
    
    timeLabel = [[UILabel alloc] init];
    timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    timeLabel.font = timeLabelFont;
    timeLabel.textColor = timeLabelTextColor;
    timeLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:timeLabel];
    
    infoImageView = [[UIImageView alloc] init];
    infoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    infoImageView.contentMode = UIViewContentModeScaleAspectFill;
    infoImageView.clipsToBounds = YES;
    
    [self.contentView addSubview:infoImageView];
    
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
      constraintWithItem:messageLabel
      attribute:NSLayoutAttributeTop
      relatedBy:NSLayoutRelationEqual
      toItem:headView
      attribute:NSLayoutAttributeTop
      multiplier:1.0
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:timeLabel
      attribute:NSLayoutAttributeBottom
      relatedBy:NSLayoutRelationEqual
      toItem:self.contentView
      attribute:NSLayoutAttributeBottom
      multiplier:1.0
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:infoImageView
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0
      constant:infoImageViewHeightWidth]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:infoImageView
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self.contentView
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:-(lineHeight)/2]];

    
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
      constraintsWithVisualFormat:@"H:|-(toLeft)-[headView(headWidth)]-(headViewToCenter)-[messageLabel]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toLeft":@(headViewToLeft),
                @"headWidth":@(headViewHeightWidth),
                @"headViewToCenter":@(headViewToCenterContent),
                @"toRight":@(infoImageViewToRight+infoImageViewHeightWidth+messageLabelToImageHorSpace)}
      views:NSDictionaryOfVariableBindings(headView,messageLabel)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[headView]-(headViewToCenter)-[timeLabel]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{
                @"headViewToCenter":@(headViewToCenterContent),
                @"toRight":@(infoImageViewToRight+infoImageViewHeightWidth+messageLabelToImageHorSpace)}
      views:NSDictionaryOfVariableBindings(headView,timeLabel)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[sepLineView(width)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toRight":@(infoImageViewToRight),
                @"width":@(infoImageViewHeightWidth)}
      views:NSDictionaryOfVariableBindings(infoImageView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[sepLineView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toLeft":@(headViewToLeft+headViewHeightWidth+headViewToCenterContent)}
      views:NSDictionaryOfVariableBindings(sepLineView)]];
    
    [self.contentView addConstraints:constrArray];
    
    for (NSLayoutConstraint *constr in constrArray) {
        if (constr.secondItem == messageLabel && constr.secondAttribute == NSLayoutAttributeTrailing) {
            messageToRightConstraints = constr;
        }else if (constr.secondItem == timeLabel && constr.secondAttribute == NSLayoutAttributeTrailing) {
            timeToRightConstraints = constr;
        }
    }
}

#pragma mark - Selection

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    selectedCoverView.hidden = !highlighted;
}


#pragma mark - LLAHeadViewDelegate

- (void) headView:(LLAUserHeadView *)headView clickedWithUserInfo:(LLAUser *)user {
    
}

#pragma mark - Update

- (void) updateCellWithInfo:(LLAMessageReceivedPraiseItemInfo *)info tableWidth:(CGFloat)width {
    
    praiseInfo = info;
    //
    
    [self adjustLabelPosition];
    
    [headView updateHeadViewWithUser:praiseInfo.authorUser];
    
    messageLabel.text = praiseInfo.manageContent;
    timeLabel.text = praiseInfo.editTimeString;
    
    [infoImageView setImageWithURL:[NSURL URLWithString:praiseInfo.infoImageURL] placeholderImage:[UIImage llaImageWithName:@"placeHolder_340"]];
    
}

- (void) adjustLabelPosition {
    if (praiseInfo.infoImageURL.length > 0) {
        messageToRightConstraints.constant = messageLabelToImageHorSpace + infoImageViewHeightWidth + infoImageViewToRight;
        timeToRightConstraints.constant =  messageLabelToImageHorSpace + infoImageViewHeightWidth + infoImageViewToRight;
    }else {
        messageToRightConstraints.constant = infoImageViewToRight;
        timeToRightConstraints.constant = infoImageViewToRight;
    }
}

#pragma mark - Calculate Height

+ (CGFloat) calculateHeightWithInfo:(LLAMessageReceivedPraiseItemInfo *)info tableWidth:(CGFloat)width {
    
    return 68;
}


@end
