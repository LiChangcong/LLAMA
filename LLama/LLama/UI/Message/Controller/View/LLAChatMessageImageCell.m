//
//  LLAChatMessageImageCell.m
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAChatMessageImageCell.h"

#import "LLAIMImageMessage.h"
#import "LLAMessageChatConfig.h"

@interface LLAChatMessageImageCell()
{
    UIImageView *messageImageView;
}

@end

@implementation LLAChatMessageImageCell

#pragma mark - Init

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initMessageImageView];
    }
    
    return self;
    
}

- (void) initMessageImageView {
    messageImageView = [[UIImageView alloc] init];
    messageImageView.clipsToBounds = YES;
    messageImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.bubbleImageView.clipsToBounds = YES;
    [self.bubbleImageView addSubview:messageImageView];
}

#pragma mark - layout subViews 

- (void) layoutSubviews {
    [super layoutSubviews];
    
    if (!self.currentMessage) {
        return;
    }
    
    messageImageView.frame = CGRectMake(0, 0, self.bubbleImageView.bounds.size.width, self.bubbleImageView.bounds.size.height);
    
}

- (void) updateCellWithMessage:(LLAIMMessage *)message maxWidth:(CGFloat)maxWidth showTime:(BOOL)showTime {
    
    [super updateCellWithMessage:message maxWidth:maxWidth showTime:showTime];
    //
    LLAIMImageMessage *imageMessage = (LLAIMImageMessage *) message;
    
    [messageImageView setImageWithURL:[NSURL URLWithString:imageMessage.imageURL] placeholderImage:[UIImage imageNamed:@"placeHolder_750"]];
    
    //mask image to bounds
    UIImage *maskImage = nil;
    if (message.ioType == LLAIMMessageIOType_In) {
        if (showTime) {
            maskImage = [LLAMessageChatConfig shareConfig].othersBubbleWithArrow;
        }else {
            maskImage = [LLAMessageChatConfig shareConfig].othersBubbleWithoutArrow;
        }
    }else {
        if (showTime) {
            maskImage = [LLAMessageChatConfig shareConfig].myBubbleWithArrow;
        }else {
            maskImage = [LLAMessageChatConfig shareConfig].myBubbleWithoutArrow;
        }
    }
    
    [self makeMaskView:messageImageView withImage:maskImage];
    
    [self layoutIfNeeded];
    
}

- (void) makeMaskView:(UIView *) view withImage:(UIImage *) image {
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(CGRectMake(0, 0, view.frame.size.width, view.frame.size.height), 0.0f, 0.0f);
    view.layer.mask = imageViewMask.layer;

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
    
    //image size
    CGSize imageSize = [self calculateImageSizeWithImageMessage:(LLAIMImageMessage *)message maxWith:maxWidth];
    
    height += MAX(imageSize.height,config.bubbleImageViewMinHeight);
    height += config.bubbleToBottom;

    //
    return height;
}

+ (CGSize) calculateImageSizeWithImageMessage:(LLAIMImageMessage *) message maxWith:(CGFloat) maxWidth {
    
    CGFloat imageMaxWidth = maxWidth;
    if (imageMaxWidth <= 0) {
        imageMaxWidth = [UIScreen mainScreen].bounds.size.width;
    }
    
    LLAMessageChatConfig *config = [LLAMessageChatConfig shareConfig];
    
    imageMaxWidth -= config.headViewToHorBorder;
    imageMaxWidth -= config.userHeadViewHeightWidth;
    imageMaxWidth -= config.headViewToBubbleHorSpace;
    //imageMaxWidth -= config.bubbleArrowWidth;
    //imageMaxWidth -= config.textMessageToBubbleHorBorder*2;
    imageMaxWidth -= config.sentFailedViewToBunbbleHorSpace;
    imageMaxWidth -= config.sentFailedViewWidth;
    imageMaxWidth -= config.sentFailedViewMinSpaceToHorBorder;

    if (message.width == 0 || message.height == 0) {
        return CGSizeMake(220, 220);
    }
    
    //calculate height
    CGFloat width = imageMaxWidth * ((float)message.width/(float)message.height);
    
    CGFloat height = imageMaxWidth / message.width * message.height;
    
    return CGSizeMake(width, height);
    
}

+ (CGSize) calculateContentSizeWithMessage:(LLAIMMessage *)message maxWidth:(CGFloat)maxWidth {
    return [self calculateImageSizeWithImageMessage:(LLAIMImageMessage *)message maxWith:maxWidth];
}

@end
