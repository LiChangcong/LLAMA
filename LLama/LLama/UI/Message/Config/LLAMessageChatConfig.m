//
//  LLAMessageChatConfig.m
//  LLama
//
//  Created by Live on 16/3/3.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAMessageChatConfig.h"

@implementation LLAMessageChatConfig

+ (instancetype) shareConfig {
    
    static LLAMessageChatConfig *shareConfig = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareConfig = [[[self class] alloc] init];
    });
    
    return shareConfig;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setToDefaultConfig];
    }
    return self;
}

- (void) setToDefaultConfig {
    self.userHeadViewHeightWidth = 36;
    self.headViewToHorBorder = 10;
    self.headViewToBubbleHorSpace = 8;
    self.headViewToTopWithoutTime = 16;
    self.headViewToTimeVerSpace = 16;
    self.timeLabelHeight = 20;
    self.bubbleToTimeVerSpace = 18;
    self.bubbleToTop = 4;
    self.sentingIndicatorToBubbleHorSapce = 2;
    self.sentFailedViewToBunbbleHorSpace = 2;
    
    self.sentFailedViewWidth = 26;
    self.sentFailedViewHeight = 26;
    self.sentFailedViewMinSpaceToHorBorder = 8;
    self.bubbleArrowWidth = 8;
    self.textMessageToBubbleHorBorder = 10;
    self.textMessageToBubbleVerBorder = 6;
    self.bubbleToBottom = 4;
    self.bubbleImageViewMinHeight = 30;
    
    self.voicePlayImageHeight = 24;
    self.voicePlayImageWidth = 30;
    self.voiceToBubbleHorBorder = 4;
    
    //font
    self.timeLabelFont = [UIFont llaFontOfSize:12];
    self.textMessageFont = [UIFont llaFontOfSize:14];
    self.voiceDurationFont = [UIFont llaFontOfSize:11];
    //color
    self.timeLabelTextColor = [UIColor colorWithHex:0xc2c2c2];
    self.textMessageColor = [UIColor colorWithHex:0x11111e];
    self.voiceDurationTextColor = [UIColor whiteColor];
    
    //bunbble image
    self.othersBubbleWithArrow = [UIImage llaImageWithName:@"other_message_bubble_withArrow"];
    self.othersBubbleWithoutArrow = [UIImage llaImageWithName:@"other_message_bubble_withoutArrow"];
    
    self.myBubbleWithArrow = [UIImage llaImageWithName:@"my_message_bubble_withArrow"];
    self.myBubbleWithoutArrow = [UIImage llaImageWithName:@"my_message_bubble_withoutArrow"];
    
    //sent failed image
    self.sentFailedImage_Normal = [UIImage llaImageWithName:@""];
    self.sentFailedImage_Highlight = [UIImage llaImageWithName:@""];
    
    self.voicePlayImage = [UIImage imageNamed:@""];
    
    self.maxRecordVoiceDuration = 60.0;
    self.minRecordVoiceDuration = 2.0;
    
}

@end
