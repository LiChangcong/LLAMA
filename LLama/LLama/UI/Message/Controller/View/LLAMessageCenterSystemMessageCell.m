//
//  LLAMessageCenterSystemMessageCell.m
//  LLama
//
//  Created by Live on 16/2/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAMessageCenterSystemMessageCell.h"
#import "LLAMessageCenterSystemMsgInfo.h"

static const CGFloat iconViewToLeft = 11;
static const CGFloat iconViewHeightWidth = 34;
static const CGFloat iconViewToTitleHorSpace = 8;

static const CGFloat titleLabelToBadgeHorSpace = 2;
static const CGFloat badgeViewToArrowImageHorSpace = 8;
static const CGFloat arrowImageViewToRight = 16;

static const CGFloat badgeViewHeight = 15;

static const CGFloat lineHeight = 0.6;

//
static NSString *const arrowImageName = @"arrowgreg";

static NSString *const beCommentedIconName = @"MessageCenter_BeComment_Icon";
static NSString *const bePraisedIconName = @"MessageCenter_BePraised_Icon";
static NSString *const orderListIconName = @"MessageCenter_OrderList_Icon";

@interface LLAMessageCenterSystemMessageCell()
{
    UIView *selectedCoverView;
    
    UIImageView *iconImageView;
    
    UILabel *titleLabel;
    
    UIButton *badgeButton;
    
    UIImageView *arrowImageView;
    
    UIView *sepLineView;
    
    //
    UIColor *backColor;
    UIColor *selectedColor;
    
    UIFont *titleLabelFont;
    UIColor *titleLabelTextColor;
    
    UIFont *badgeFont;
    UIColor *badgeTextColor;
    UIColor *badgeBackColor;
    
    UIColor *sepLineColor;
    
    LLAMessageCenterSystemMsgInfo *msgInfo;
    
}

@end

@implementation LLAMessageCenterSystemMessageCell

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
    
    titleLabelFont = [UIFont boldLLAFontOfSize:15];
    titleLabelTextColor = [UIColor whiteColor];
    
    badgeFont = [UIFont llaFontOfSize:12];
    badgeTextColor = [UIColor whiteColor];
    badgeBackColor = [UIColor colorWithHex:0xf94848];
    
    sepLineColor = [UIColor colorWithHex:0x1e1d22];

}

- (void) initSubViews {
    selectedCoverView = [[UIView alloc] init];
    selectedCoverView.translatesAutoresizingMaskIntoConstraints = NO;
    selectedCoverView.backgroundColor = selectedColor;
    selectedCoverView.hidden = YES;
    [self.contentView addSubview:selectedCoverView];
    
    iconImageView = [[UIImageView alloc] init];
    iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    iconImageView.clipsToBounds = YES;
    
    [self.contentView addSubview:iconImageView];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = titleLabelFont;
    titleLabel.textColor = titleLabelTextColor;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:titleLabel];
    
    badgeButton = [[UIButton alloc] init];
    badgeButton.translatesAutoresizingMaskIntoConstraints = NO;
    badgeButton.userInteractionEnabled = NO;
    badgeButton.contentEdgeInsets = UIEdgeInsetsMake(0,2,0,2);
    
    badgeButton.titleLabel.font = badgeFont;
    
    [badgeButton setBackgroundColor:badgeBackColor forState:UIControlStateNormal];
    [badgeButton setTitleColor:badgeTextColor forState:UIControlStateNormal];
    
    badgeButton.clipsToBounds = YES;
    badgeButton.layer.cornerRadius = badgeViewHeight / 2;
    
    [self.contentView addSubview:badgeButton];
    
    arrowImageView = [[UIImageView alloc] init];
    arrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    arrowImageView.image = [UIImage llaImageWithName:arrowImageName];
    
    [self.contentView addSubview:arrowImageView];
    
    sepLineView = [[UIView alloc] init];
    sepLineView.translatesAutoresizingMaskIntoConstraints = NO;
    sepLineView.backgroundColor = sepLineColor;
    
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
      constraintWithItem:iconImageView
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0
      constant:iconViewHeightWidth]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:iconImageView
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self.contentView
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:-(lineHeight)/2]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[titleLabel]-(0)-[sepLineView(lineHeight)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"lineHeight":@(lineHeight)}
      views:NSDictionaryOfVariableBindings(titleLabel,sepLineView)]];
    
    //badge
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:badgeButton
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0
      constant:badgeViewHeight]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:badgeButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self.contentView
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:-(lineHeight)/2]];
    
    //arrow
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:arrowImageView
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self.contentView
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:-(lineHeight)/2]];

    //horizonal
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[selectedCoverView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(selectedCoverView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[iconImageView(iconWidth)]-(iconToTitle)-[titleLabel]-(titleToBadge)-[badgeButton(>=minWidth)]-(badgeToArrow)-[arrowImageView]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toLeft":@(iconViewToLeft),
                @"iconWidth":@(iconViewHeightWidth),
                @"iconToTitle":@(iconViewToTitleHorSpace),
                @"titleToBadge":@(titleLabelToBadgeHorSpace),
                @"badgeToArrow":@(badgeViewToArrowImageHorSpace),
                @"toRight":@(arrowImageViewToRight),
                @"minWidth":@(badgeViewHeight)}
      views:NSDictionaryOfVariableBindings(iconImageView,titleLabel,badgeButton,arrowImageView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[iconImageView]-(horSpace)-[sepLineView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"horSpace":@(iconViewToTitleHorSpace)}
      views:NSDictionaryOfVariableBindings(iconImageView,sepLineView)]];
    
    [self.contentView addConstraints:constrArray];
    
    [titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [badgeButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [arrowImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [badgeButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [arrowImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
}

#pragma mark - Selection

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    selectedCoverView.hidden = !highlighted;
}

#pragma mark - Update

- (void) updateCellWithMsgInfo:(LLAMessageCenterSystemMsgInfo *) info tableWidth:(CGFloat) tableWidth {
    
    msgInfo = info;
    
    //
    NSString *placeHolderImage = nil;
    if (msgInfo.messageType == LLASystemMessageType_BePraised) {
        placeHolderImage = bePraisedIconName;
    }else if (msgInfo.messageType == LLASystemMessageType_BeCommented) {
        placeHolderImage = beCommentedIconName;
    }else if (msgInfo.messageType == LLASystemMessageType_Order) {
        placeHolderImage = orderListIconName;
    }
    
    [iconImageView setImageWithURL:[NSURL URLWithString:info.iconImageURLString] placeholderImage:[UIImage imageNamed:placeHolderImage]];
    titleLabel.text = info.titleString;
    
    NSString *badgeString = nil;
    
    if (msgInfo.unreadNum > 0) {
        badgeButton.hidden = NO;
        
        if (msgInfo.unreadNum > 99) {
            badgeString = @"99+";
        }else {
            badgeString = [NSString stringWithFormat:@"%ld",(long)msgInfo.unreadNum];
        }
        
    }else {
        badgeButton.hidden = YES;
        badgeString = @"";
    }
    
    [badgeButton setTitle:badgeString forState:UIControlStateNormal];
    
}

+ (CGFloat) calculateCellWithMsgInfo:(LLAMessageCenterSystemMsgInfo *) info tableWidth:(CGFloat) tableWidth {
    return 68;
}


@end
