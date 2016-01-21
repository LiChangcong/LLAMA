//
//  LLAVideoCommentView.m
//  LLama
//
//  Created by Live on 16/1/14.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAVideoCommentView.h"
#import "LLAHallVideoCommentItem.h"

#import "TYAttributedLabel.h"

static const CGFloat labelTextFontSize = 13;

static const CGFloat attributeLabelToLeft = 0;
static const CGFloat attributeLabelToRight = 0;

//color hex

static const NSInteger textColorHex = 0x636363;

@interface LLAVideoCommentView()<TYAttributedLabelDelegate>
{
    UIFont *labelFont;
    UIColor *userTextColor;
    UIColor *userSelectedTextBKColor;
    UIColor *contentTextColor;
    
    UIView *highLightView;
    UIColor *highLightViewBKColor;
    
    
}

@property(nonatomic , readwrite , strong) TYAttributedLabel *attrLabel;

@property(nonatomic , readwrite , strong) LLAHallVideoCommentItem *currentCommentInfo;

@end

@implementation LLAVideoCommentView

@synthesize attrLabel;
@synthesize currentCommentInfo;
@synthesize delegate;

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 设置变量
        [self initVariables];
        // 设置子控件
        [self initSubViews];
        
    }
    return self;
}
// 设置变量
- (void) initVariables {
    // 字体
    labelFont = [UIFont systemFontOfSize:labelTextFontSize];
    
    // 颜色
    userTextColor = [UIColor themeColor];
    userSelectedTextBKColor = [UIColor colorWithHex:0xdddddd];
    contentTextColor = [UIColor colorWithHex:textColorHex];
    highLightViewBKColor = [UIColor colorWithHex:0x222222 alpha:0.1];
}

// 设置子控件
- (void) initSubViews {
    attrLabel = [[TYAttributedLabel alloc] init];
    attrLabel.translatesAutoresizingMaskIntoConstraints = NO;
    attrLabel.delegate = self;
    attrLabel.linkColor = userTextColor;
    attrLabel.textColor = contentTextColor;
    attrLabel.highlightedLinkBackgroundColor = userSelectedTextBKColor;
    attrLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:attrLabel];
    
    [self addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[attrLabel]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithFloat:attributeLabelToLeft],@"toLeft",
               [NSNumber numberWithFloat:attributeLabelToRight],@"toRight", nil]
      views:NSDictionaryOfVariableBindings(attrLabel)]];
    
    [self addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[attrLabel]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(attrLabel)]];
    
    //
    highLightView = [[UIView alloc] init];
    highLightView.translatesAutoresizingMaskIntoConstraints = NO;
    highLightView.backgroundColor = highLightViewBKColor;
    highLightView.hidden = YES;
    
    [self addSubview:highLightView];
    
    [self addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[highLightView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(highLightView)]];
    
    [self addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[highLightView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(highLightView)]];
}

#pragma mark - TYAttributedLabelDelegate 

- (void) attributedLabel:(TYAttributedLabel *)attributedLabel labelSingleTappedWithState:(UIGestureRecognizerState)state atPoint:(CGPoint)point {
    
    if (delegate && [delegate respondsToSelector:@selector(singleTappedWithCommentView:)]) {
        [delegate singleTappedWithCommentView:self];
    }
}

- (void) attributedLabel:(TYAttributedLabel *)attributedLabel labelLongPressedWithState:(UIGestureRecognizerState)state atPoint:(CGPoint)point {
    
}

- (void) attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point {
    
    if ([textStorage isKindOfClass:[TYLinkTextStorage class]]) {
        id linkData = ((TYLinkTextStorage *)textStorage).linkData;
        if ([linkData isKindOfClass:[LLAUser class]]) {
            //
            if(delegate && [delegate respondsToSelector:@selector(commentView:userNameClicked:)])  {
                [delegate commentView:self userNameClicked:(LLAUser *)linkData];
            }
        }
    }

    
}

- (void) attributedLabel:(TYAttributedLabel *)attributedLabel textStorageLongPressed:(id<TYTextStorageProtocol>)textStorage onState:(UIGestureRecognizerState)state atPoint:(CGPoint)point {
    
}

#pragma mark - Update

- (void) updateCommentWithInfo:(LLAHallVideoCommentItem *)commentInfo maxWidth:(CGFloat)maxWidth {
    
    currentCommentInfo = commentInfo;
    
    [[self class] generateTextContainerWihtCommentInfo:currentCommentInfo maxWidth:maxWidth];
    
    attrLabel.textContainer = currentCommentInfo.textContainer;
    //attrLabel.backgroundColor = self.backgroundColor;
    
    
    
}

#pragma mark - Generate TextContainer

+ (void) generateTextContainerWihtCommentInfo:(LLAHallVideoCommentItem *) commentInfo maxWidth:(CGFloat) maxWidth {
    
    if (commentInfo.textContainer) {
        return;
    }
    
    TYTextContainer *textContainer = [[TYTextContainer alloc] init];
    textContainer.linkColor = [UIColor themeColor];
    textContainer.font = [UIFont systemFontOfSize:labelTextFontSize];
    textContainer.textColor = [UIColor colorWithHex:textColorHex];
    
    NSRange authorUserNameRange = NSMakeRange(0, 0);
    NSRange replyToUserNameRange = NSMakeRange(0, 0);
    
    NSMutableString *contentText = [[NSMutableString alloc] init];
    
    if (commentInfo.replyToUser.userName && ![commentInfo.replyToUser.userIdString isEqualToString:commentInfo.authorUser.userIdString]) {
        
        NSString *authorString = [NSString stringWithFormat:@"%@",commentInfo.authorUser.userName];
        [contentText appendString:authorString];
        
        authorUserNameRange = NSMakeRange(0, authorString.length);

        [contentText appendString:[NSString stringWithFormat:@"回复%@:",commentInfo.replyToUser.userName]];
        replyToUserNameRange = NSMakeRange(commentInfo.authorUser.userName.length+2, commentInfo.replyToUser.userName.length+1);
        
    }else {
        NSString *authorString = [NSString stringWithFormat:@"%@:",commentInfo.authorUser.userName];
        [contentText appendString:authorString];
        
        authorUserNameRange = NSMakeRange(0, authorString.length);
    }
    
    [contentText appendString:commentInfo.commentContent];
    
    textContainer.text = contentText;
    
    if (authorUserNameRange.length >0 ) {
        [textContainer addLinkWithLinkData:commentInfo.authorUser linkColor:nil underLineStyle:kCTUnderlineStyleNone range:authorUserNameRange];
        
    }
    if (replyToUserNameRange.length >0 ) {
        [textContainer addLinkWithLinkData:commentInfo.replyToUser linkColor:nil underLineStyle:kCTUnderlineStyleNone range:replyToUserNameRange];
    }

    textContainer = [textContainer createTextContainerWithTextWidth:maxWidth-attributeLabelToLeft-attributeLabelToRight];
    
    commentInfo.textContainer = textContainer;

    
}

#pragma mark - CalculateHeight

+ (CGFloat) calculateHeightWihtInfo:(LLAHallVideoCommentItem *)commentInfo maxWidth:(CGFloat)maxWidth {
    [[self class] generateTextContainerWihtCommentInfo:commentInfo maxWidth:maxWidth];
    return commentInfo.textContainer.textHeight;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
