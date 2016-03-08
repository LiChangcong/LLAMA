//
//  LLAChatMessageVoiceCell.m
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAChatMessageVoiceCell.h"

#import "LLAIMVoiceMessage.h"
#import "LLAMessageChatConfig.h"

@interface LLAChatMessageVoiceCell()
{
    UILabel *durationLabel;
    UIImageView *voiceImageView;
}

@end

@implementation LLAChatMessageVoiceCell

#pragma mark - Init

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initVoiceSubViews];
    }
    
    return self;
    
}

- (void) initVoiceSubViews {
    
    durationLabel = [[UILabel alloc] init];
    durationLabel.font = [LLAMessageChatConfig shareConfig].voiceDurationFont;
    durationLabel.textColor = [LLAMessageChatConfig shareConfig].voiceDurationTextColor;
    
    [self.contentView addSubview:durationLabel];
    
    //
    voiceImageView = [[UIImageView alloc] init];
    voiceImageView.clipsToBounds = YES;
    //voiceImageView.image = [LLAMessageChatConfig shareConfig].voicePlayImage;
    //voiceImageView.backgroundColor = [UIColor purpleColor];
    voiceImageView.contentMode = UIViewContentModeCenter;
    voiceImageView.userInteractionEnabled = YES;
    
    [self.bubbleImageView addSubview:voiceImageView];
    
    //
    UITapGestureRecognizer *voiceTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVoice:)];
    [voiceImageView addGestureRecognizer:voiceTapped];
}

#pragma mark - Layout SubViews

- (void) layoutSubviews {
    
    [super layoutSubviews];
    
    //
    if (!self.currentMessage) {
        return;
    }
    
    LLAMessageChatConfig *config = [LLAMessageChatConfig shareConfig];
    
    CGRect bubbleFrame = self.bubbleImageView.frame;
    
    if (self.currentMessage.ioType == LLAIMMessageIOType_In) {
        
        voiceImageView.frame = CGRectMake(config.bubbleArrowWidth+config.voiceToBubbleHorBorder, (self.bubbleImageView.bounds.size.height-config.voicePlayImageHeight)/2, config.voicePlayImageWidth, config.voicePlayImageHeight);
        durationLabel.frame = CGRectMake(bubbleFrame.origin.x+bubbleFrame.size.width+config.sentFailedViewToBunbbleHorSpace, bubbleFrame.origin.y+(bubbleFrame.size.height-durationLabel.bounds.size.height)/2, durationLabel.bounds.size.width, durationLabel.bounds.size.height);
    }else {
        voiceImageView.frame = CGRectMake(bubbleFrame.size.width-config.bubbleArrowWidth-config.voiceToBubbleHorBorder - config.voicePlayImageWidth, (self.bubbleImageView.bounds.size.height-config.voicePlayImageHeight)/2, config.voicePlayImageWidth, config.voicePlayImageHeight);
        durationLabel.frame = CGRectMake(bubbleFrame.origin.x - config.sentFailedViewToBunbbleHorSpace - durationLabel.bounds.size.width, bubbleFrame.origin.y+(bubbleFrame.size.height-durationLabel.bounds.size.height)/2, durationLabel.bounds.size.width, durationLabel.bounds.size.height);
    }
    
    if (self.currentMessage.msgStatus == LLAIMMessageStatusFailed || self.currentMessage.msgStatus == LLAIMMessageStatusSending) {
        durationLabel.hidden = YES;
    }else {
        durationLabel.hidden = NO;
    }
    
}

#pragma mark - 

- (void) tapVoice:(UIGestureRecognizer *) ges {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playStopVoiceWithMessage:)]) {
        [self.delegate playStopVoiceWithMessage:self.currentMessage];
    }
}

#pragma mark - Update

- (void) updateCellWithMessage:(LLAIMMessage *)message maxWidth:(CGFloat)maxWidth showTime:(BOOL)showTime {
    //
    
    [super updateCellWithMessage:message maxWidth:maxWidth showTime:showTime];
    
    durationLabel.text = [self formatDurationString];
    
    if (self.currentMessage.ioType == LLAIMMessageIOType_In) {
        durationLabel.textAlignment = NSTextAlignmentLeft;
    }else {
        durationLabel.textAlignment = NSTextAlignmentRight;
    }
    [durationLabel sizeToFit];
    
    [self layoutIfNeeded];
}

- (void) updateVoiceStausWithIsPlaying:(BOOL)isPlaying {
    
    //
    
    LLAMessageChatConfig *config = [LLAMessageChatConfig shareConfig];

    
    if (isPlaying) {
        
        if (!voiceImageView.isAnimating) {
            if (self.currentMessage.ioType == LLAIMMessageIOType_In) {
                //others
                voiceImageView.animationImages = config.receiverVoicePlayingImages;
                voiceImageView.animationDuration = config.voicePlayingDuration;
                [voiceImageView startAnimating];
                
            }else {
                //my
                voiceImageView.animationImages = config.senderVoicePlayingImages;
                voiceImageView.animationDuration = config.voicePlayingDuration;
                [voiceImageView startAnimating];
                
            }
        }
        
    }else {
        
        voiceImageView.animationImages = nil;
        [voiceImageView stopAnimating];
        
        if (self.currentMessage.ioType == LLAIMMessageIOType_In) {
            //
            voiceImageView.image = config.receiverVoicePlayImage;
        }else {
            voiceImageView.image = config.senderVoicePlayImage;
        }
        
    }
    
    
}

- (NSString *) formatDurationString {
    return [NSString stringWithFormat:@"%.0f''",((LLAIMVoiceMessage *)self.currentMessage).duration+0.5];
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
    
    CGSize voiceSize = [self calculateVoiceSizeWith:(LLAIMVoiceMessage *)message maxWidth:maxWidth];
    
    height += voiceSize.height;
    
    height += config.bubbleToBottom;
    
    return height;
    
}

+ (CGSize) calculateVoiceSizeWith:(LLAIMVoiceMessage *) message maxWidth:(CGFloat) maxWidth {
    
    
    CGFloat voiceMaxWidth = maxWidth;
    if (voiceMaxWidth <= 0) {
        voiceMaxWidth = [UIScreen mainScreen].bounds.size.width;
    }
    
    LLAMessageChatConfig *config = [LLAMessageChatConfig shareConfig];
    
    voiceMaxWidth -= config.headViewToHorBorder;
    voiceMaxWidth -= config.userHeadViewHeightWidth;
    voiceMaxWidth -= config.headViewToBubbleHorSpace;
    voiceMaxWidth -= config.bubbleArrowWidth;
    voiceMaxWidth -= config.textMessageToBubbleHorBorder*2;
    voiceMaxWidth -= config.sentFailedViewToBunbbleHorSpace;
    voiceMaxWidth -= config.sentFailedViewWidth;
    voiceMaxWidth -= config.sentFailedViewMinSpaceToHorBorder;

    if (message.duration <= 0) {
        return CGSizeMake(60, config.bubbleImageViewMinHeight);
    }
    
    CGFloat ratio = message.duration / config.maxRecordVoiceDuration;
    
    CGFloat width = ratio * voiceMaxWidth;
    width = MAX(60, width);
    width = MIN(voiceMaxWidth,width);
    
    return CGSizeMake(width, config.bubbleImageViewMinHeight);
    
}

+ (CGSize) calculateContentSizeWithMessage:(LLAIMMessage *)message maxWidth:(CGFloat)maxWidth {
    CGSize voiceSize = [self calculateVoiceSizeWith:(LLAIMVoiceMessage *)message maxWidth:maxWidth];
    
    LLAMessageChatConfig *config = [LLAMessageChatConfig shareConfig];
    
    return  CGSizeMake(voiceSize.width+2*config.textMessageToBubbleHorBorder*2, voiceSize.height);
}

@end
