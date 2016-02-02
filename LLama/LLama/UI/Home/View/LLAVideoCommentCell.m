//
//  LLAVideoCommentCell.m
//  LLama
//
//  Created by Live on 16/2/1.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAVideoCommentCell.h"

#import "LLAUserHeadView.h"
#import "TYAttributedLabel.h"
#import "LLAHallVideoCommentItem.h"

static const NSInteger authorNameFontSize = 15;
static const NSInteger replyToUserFontSize = 14;
static const NSInteger userNameNormalColorHex = 0x11111e;

//
static const CGFloat headViewHeightWidth = 40;
static const CGFloat headViewToTop = 9;
static const CGFloat headViewToLeft = 11;
static const CGFloat headViewToCenterHorSpace = 8;

static const CGFloat nameLabelToTop = 9;
static const CGFloat nameLabelHeight = 18;
static const CGFloat timeLabelToRight = 9;
static const CGFloat nameToContent = 8;
static const CGFloat contentToSepLineSpace = 8;
static const CGFloat sepLineHeight = 0.6;

static const CGFloat commentContentToRight = 12;

@interface LLAVideoCommentCell()<LLAUserHeadViewDelegate,TYAttributedLabelDelegate>
{
    LLAUserHeadView *authorHeadView;
    
    TYAttributedLabel *athuorUserNameLabel;
    
    UILabel *timeLabel;
    
    TYAttributedLabel *commentContentLabel;
    
    UIView *sepLineView;
    
    //
    UIFont *timeLabelFont;
    UIColor *timeLabelTextColor;

    UIColor *sepLineColor;
    
    //
    LLAHallVideoCommentItem *currentComment;
    
}

@end

@implementation LLAVideoCommentCell

@synthesize delegate;

#pragma mark - Init

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor whiteColor];
        
        [self initvariables];
        [self initSubViews];
        [self initSubConstraints];
        
    }
    
    return self;
}

- (void) initvariables {
    timeLabelFont = [UIFont llaFontOfSize:13];
    timeLabelTextColor = [UIColor colorWithHex:0x959595];
    
    sepLineColor = [UIColor colorWithHex:0xededed];
}

- (void) initSubViews {
    //
    authorHeadView = [[LLAUserHeadView alloc] init];
    authorHeadView.translatesAutoresizingMaskIntoConstraints = NO;
    authorHeadView.delegate = self;
    
    [self.contentView addSubview:authorHeadView];
    
    //
    athuorUserNameLabel = [[TYAttributedLabel alloc] init];
    athuorUserNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    athuorUserNameLabel.delegate = self;
    athuorUserNameLabel.numberOfLines = 1;
    
    [self.contentView addSubview:athuorUserNameLabel];
    
    //
    timeLabel = [[UILabel alloc] init];
    timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    timeLabel.font = timeLabelFont;
    timeLabel.textColor = timeLabelTextColor;
    
    
    timeLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:timeLabel];
    
    //
    commentContentLabel = [[TYAttributedLabel alloc] init];
    commentContentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    commentContentLabel.delegate = self;
    
    [self.contentView addSubview:commentContentLabel];
    
    //
    sepLineView = [[UIView alloc] init];
    sepLineView.translatesAutoresizingMaskIntoConstraints = NO;
    sepLineView.backgroundColor = sepLineColor;
    
    [self.contentView addSubview:sepLineView];
    
}

- (void) initSubConstraints {
    
    //constraints
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[authorHeadView(height)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toTop":@(headViewToTop),
                @"height":@(headViewHeightWidth)}
      views:NSDictionaryOfVariableBindings(authorHeadView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[athuorUserNameLabel(height)]-(nameToContent)-[commentContentLabel]-(contentToSepLine)-[sepLineView(lineHeight)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toTop":@(nameLabelToTop),
                @"height":@(nameLabelHeight),
                @"nameToContent":@(nameToContent),
                @"contentToSepLine":@(contentToSepLineSpace),
                @"lineHeight":@(sepLineHeight)}
      views:NSDictionaryOfVariableBindings(athuorUserNameLabel,commentContentLabel,sepLineView)]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:timeLabel
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:athuorUserNameLabel
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    //horizonal
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[authorHeadView(headWidth)]-(headToName)-[athuorUserNameLabel]-(2)-[timeLabel]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toLeft":@(headViewToLeft),
                @"headWidth":@(headViewHeightWidth),
                @"headToName":@(headViewToCenterHorSpace),
                @"toRight":@(timeLabelToRight)}
      views:NSDictionaryOfVariableBindings(authorHeadView,athuorUserNameLabel,timeLabel)]];
    
    [timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [timeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [athuorUserNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [athuorUserNameLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    //
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[authorHeadView]-(headToContent)-[commentContentLabel]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"headToContent":@(headViewToCenterHorSpace),
                @"toRight":@(commentContentToRight)}
      views:NSDictionaryOfVariableBindings(authorHeadView,commentContentLabel)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[authorHeadView]-(headToContent)-[sepLineView]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"headToContent":@(headViewToCenterHorSpace),
                @"toRight":@(0)}
      views:NSDictionaryOfVariableBindings(authorHeadView,sepLineView)]];
    
    [self.contentView addConstraints:constrArray];
    
    
}

#pragma mark - LLAUserHeadViewDelegate

- (void) headView:(LLAUserHeadView *)headView clickedWithUserInfo:(LLAUser *)user {
    if (delegate && [delegate respondsToSelector:@selector(toggleUser:commentInfo:)]) {
        [delegate toggleUser:user  commentInfo:currentComment];
    }
}

#pragma mark - TYAttributedLabelDelegate

- (void) attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point {
    
    if ([textStorage isKindOfClass:[TYLinkTextStorage class]]) {
        id linkData = ((TYLinkTextStorage *)textStorage).linkData;
        if ([linkData isKindOfClass:[LLAUser class]]) {
            //
            if (delegate && [delegate respondsToSelector:@selector(toggleUser:commentInfo:)]) {
                [delegate toggleUser:(LLAUser *)linkData commentInfo:currentComment];
            }

        }
    }
}

#pragma mark - Update

- (void) updateCellWithCommentItem:(LLAHallVideoCommentItem *)commentInfo maxWidth:(CGFloat)maxWidth {
    
    currentComment = commentInfo;
    //
    
    [authorHeadView updateHeadViewWithUser:currentComment.authorUser];
    timeLabel.text = commentInfo.commentTimeString;
    
    athuorUserNameLabel.textContainer = [self authorNameTextContainer];
    
    commentContentLabel.textContainer = commentInfo.textContainer;
}

- (TYTextContainer *) authorNameTextContainer {
    
    TYTextContainer *textContainer = [[TYTextContainer alloc] init];
    textContainer.linkColor = [UIColor themeColor];
    textContainer.font = [UIFont systemFontOfSize:authorNameFontSize];
    textContainer.textColor = [UIColor colorWithHex:userNameNormalColorHex];
    textContainer.text = currentComment.authorUser.userName;
    
    [textContainer addLinkWithLinkData:currentComment.authorUser linkColor:nil underLineStyle:kCTUnderlineStyleNone range:NSMakeRange(0, currentComment.authorUser.userName.length)];
    textContainer = [textContainer createTextContainerWithTextWidth:400];
    
    return textContainer;
    
}

#pragma mark - Calculate Height

+ (void) generateTextContainerWithCommentInfo:(LLAHallVideoCommentItem *) commentInfo maxWidth:(CGFloat) maxWidth {
    
    if (commentInfo.textContainer) {
        return;
    }
    //
    TYTextContainer *textContainer = [[TYTextContainer alloc] init];
    textContainer.linkColor = [UIColor themeColor];
    textContainer.font = [UIFont systemFontOfSize:replyToUserFontSize];
    textContainer.textColor = [UIColor colorWithHex:userNameNormalColorHex];
    
    NSMutableString *contentText = [[NSMutableString alloc] init];
    
    if (commentInfo.replyToUser) {
        
        [contentText appendString:[NSString stringWithFormat:@"@%@ ",commentInfo.replyToUser.userName]];
    }
    
    if (commentInfo.commentContent.length >0)
        [contentText appendString:commentInfo.commentContent];
    
    textContainer.text = contentText;
    
    //add arrange
    if (commentInfo.replyToUser.userName.length > 0) {
        [textContainer addLinkWithLinkData:commentInfo.replyToUser linkColor:nil underLineStyle:kCTUnderlineStyleNone range:NSMakeRange(0, commentInfo.replyToUser.userName.length+1)];
    }
    
    textContainer= [textContainer createTextContainerWithTextWidth:maxWidth];
    
    commentInfo.textContainer = textContainer;

    
}

+ (CGFloat) heightForReplayContent:(LLAHallVideoCommentItem *) commentInfo maxWidth:(CGFloat) maxWidth {
    
    if (!commentInfo.textContainer) {
        //generate
        [self generateTextContainerWithCommentInfo:commentInfo maxWidth:maxWidth-headViewToLeft-headViewHeightWidth-headViewToCenterHorSpace-commentContentToRight];
    }
    
    return commentInfo.textContainer.textHeight;
}

+ (CGFloat) calculateHeightWithCommentItem:(LLAHallVideoCommentItem *) commentInfo maxWidth:(CGFloat) maxWidth {
    
    CGFloat height = 0;
    
    height += nameLabelToTop;
    height += nameLabelHeight;
    height += nameToContent;
    
    //calculate content
    height += [self heightForReplayContent:commentInfo maxWidth:maxWidth];
    
    height += contentToSepLineSpace;
    height += sepLineHeight;
    
    height = MAX(59,height);
    
    return height;
    
}

@end
