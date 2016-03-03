//
//  LLAChatMessageTextCell.m
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAChatMessageTextCell.h"

#import "LLAMessageChatConfig.h"
#import "LLAIMMessage.h"

@interface LLAChatMessageTextCell()
{
    UITextView *contentTextView;
}

@end

@implementation LLAChatMessageTextCell

#pragma mark - Init

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initContentTextView];
    }
    
    return self;
    
}

- (void) initContentTextView {
    contentTextView = [[UITextView alloc] init];
    contentTextView.font = [LLAMessageChatConfig shareConfig].textMessageFont;
    contentTextView.textColor = [LLAMessageChatConfig shareConfig].textMessageColor;
    contentTextView.scrollEnabled = NO;
    
    [self.contentView addSubview:contentTextView];
}

#pragma mark - layoutSubView

- (void) layoutSubviews {
    [super layoutSubviews];
    
    if (!self.currentMessage) {
        return;
    }
    
    //
    CGSize textSize = [[self class] calculateContentSizeWithMessage:self.currentMessage maxWidth:self.bounds.size.width];
    
    LLAMessageChatConfig *config = [LLAMessageChatConfig shareConfig];
    CGRect bubbleframe = self.bubbleImageView.frame;
    
    if (self.currentMessage.ioType == LLAIMMessageIOType_In) {
        //ohters
        contentTextView.frame = CGRectMake(bubbleframe.origin.x+config.bubbleArrowWidth+config.textMessageToBubbleHorBorder, bubbleframe.origin.y+config.textMessageToBubbleVerBorder, textSize.width, textSize.height);
        
    }else {
        //my
        contentTextView.frame = CGRectMake(bubbleframe.origin.x+config.textMessageToBubbleHorBorder, bubbleframe.origin.y+config.textMessageToBubbleVerBorder, textSize.width, textSize.height);
    }
    
}

#pragma mark - Update

- (void) updateCellWithMessage:(LLAIMMessage *)message maxWidth:(CGFloat)maxWidth showTime:(BOOL)showTime {
    //
    [super updateCellWithMessage:message maxWidth:maxWidth showTime:showTime];
    
    contentTextView.text = message.content;
    
    [self layoutIfNeeded];
}

#pragma mark - CalculateHeight

+ (CGFloat) calculateHeightWithMessage:(LLAIMMessage *)message maxWidth:(CGFloat)maxWidth showTime:(BOOL)shouldShow {
    
    LLAMessageChatConfig *config = [LLAMessageChatConfig shareConfig];
    CGFloat height = 0;
    
    if (shouldShow) {
        height += config.timeLabelHeight;
        height += config.bubbleToTimeVerSpace;
    }
    
    height += config.bubbleToTop;
    
    CGFloat bubbleHeight = 2 * config.textMessageToBubbleVerBorder;
    
    CGSize textSize = [self textSizeWithTextMaxWidth:maxWidth message:message];
    
    bubbleHeight = MAX(bubbleHeight+textSize.height, config.bubbleImageViewMinHeight);
    
    height += bubbleHeight;
    height += config.bubbleToBottom;
    
    return height;
    
}

+ (CGSize) textSizeWithTextMaxWidth:(CGFloat) maxWidth message:(LLAIMMessage *) message{
    
    CGFloat textMaxWith = maxWidth;
    if (textMaxWith <= 0) {
        textMaxWith = [UIScreen mainScreen].bounds.size.width;
    }
    
    LLAMessageChatConfig *config = [LLAMessageChatConfig shareConfig];
    
    textMaxWith -= config.headViewToHorBorder;
    textMaxWith -= config.userHeadViewHeightWidth;
    textMaxWith -= config.headViewToBubbleHorSpace;
    textMaxWith -= config.bubbleArrowWidth;
    textMaxWith -= config.textMessageToBubbleHorBorder*2;
    textMaxWith -= config.sentFailedViewToBunbbleHorSpace;
    textMaxWith -= config.sentFailedViewWidth;
    textMaxWith -= config.sentFailedViewMinSpaceToHorBorder;
    
    NSString *textString = message.content;
    if (!textString) {
        textString = @"";
    }
    
    CGSize textSize = [textString boundingRectWithSize:CGSizeMake(textMaxWith, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:config.textMessageFont,NSFontAttributeName, nil] context:nil].size;
    
    return CGSizeMake(textSize.width, ceilf(textSize.height));
    
}

+ (CGSize) calculateContentSizeWithMessage:(LLAIMMessage *)message maxWidth:(CGFloat)maxWidth {
    
    LLAMessageChatConfig *config = [LLAMessageChatConfig shareConfig];
    
    CGSize textSize = [self calculateContentSizeWithMessage:message maxWidth:maxWidth];
    
    return  CGSizeMake(textSize.width+config.textMessageToBubbleHorBorder*2+config.bubbleArrowWidth, MAX(textSize.height+config.textMessageToBubbleVerBorder*2, config.bubbleImageViewMinHeight));
    
}


@end
