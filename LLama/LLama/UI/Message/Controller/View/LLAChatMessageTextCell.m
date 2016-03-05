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
    //contentTextView.scrollEnabled = NO;
    contentTextView.editable = NO;
    contentTextView.scrollEnabled = YES;
    contentTextView.userInteractionEnabled = YES;
    contentTextView.textContainerInset = UIEdgeInsetsZero;
    contentTextView.textContainer.lineFragmentPadding = 0;
    contentTextView.dataDetectorTypes  = UIDataDetectorTypeAll;
    contentTextView.backgroundColor = [UIColor clearColor];
    //contentTextView.backgroundColor = [UIColor clearColor];
    
    [self.bubbleImageView addSubview:contentTextView];
}

#pragma mark - layoutSubView

- (void) layoutSubviews {
    [super layoutSubviews];
    
    if (!self.currentMessage) {
        return;
    }
    
    //
    CGSize textSize = [[self class] textSizeWithTextMaxWidth:self.cellMaxWidth message:self.currentMessage];
    
    LLAMessageChatConfig *config = [LLAMessageChatConfig shareConfig];
    //CGRect bubbleframe = self.bubbleImageView.frame;
    
    if (self.currentMessage.ioType == LLAIMMessageIOType_In) {
        //ohters
        contentTextView.frame = CGRectMake(config.bubbleArrowWidth+config.textMessageToBubbleHorBorder,(self.bubbleImageView.bounds.size.height - textSize.height)/2, textSize.width, textSize.height);
        
    }else {
        //my
        contentTextView.frame = CGRectMake(config.textMessageToBubbleHorBorder,(self.bubbleImageView.bounds.size.height - textSize.height)/2, textSize.width, textSize.height);
    }
    
}

#pragma mark - Update

- (void) updateCellWithMessage:(LLAIMMessage *)message maxWidth:(CGFloat)maxWidth showTime:(BOOL)showTime {
    //
    [super updateCellWithMessage:message maxWidth:maxWidth showTime:showTime];
    
    //contentTextView.text = message.content;
    
    LLAMessageChatConfig *config = [LLAMessageChatConfig shareConfig];
    
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = config.textLineSpace;

    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:message.content];
    [attr addAttribute:NSFontAttributeName value:config.textMessageFont range:NSMakeRange(0, attr.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:config.textMessageColor range:NSMakeRange(0, attr.length)];
    
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, attr.length)];
    contentTextView.attributedText = attr;

    
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
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = config.textLineSpace;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:textString];
    [attr addAttribute:NSFontAttributeName value:config.textMessageFont range:NSMakeRange(0, attr.length)];
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, attr.length)];
    
    CGSize textSize =  [attr boundingRectWithSize:CGSizeMake(textMaxWith, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    return CGSizeMake(textSize.width, ceilf(textSize.height));
    
}

+ (CGSize) calculateContentSizeWithMessage:(LLAIMMessage *)message maxWidth:(CGFloat)maxWidth {
    
    LLAMessageChatConfig *config = [LLAMessageChatConfig shareConfig];
    
    CGSize textSize = [self textSizeWithTextMaxWidth:maxWidth message:message];
    
    return  CGSizeMake(textSize.width+config.textMessageToBubbleHorBorder*2+config.bubbleArrowWidth, MAX(textSize.height+config.textMessageToBubbleVerBorder*2, config.bubbleImageViewMinHeight));
    
}


@end
