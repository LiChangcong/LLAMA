//
//  LLAMessageChatConfig.h
//  LLama
//
//  Created by Live on 16/3/3.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLAMessageChatConfig : NSObject

@property(nonatomic , assign) CGFloat userHeadViewHeightWidth;

@property(nonatomic , assign) CGFloat headViewToHorBorder;

@property(nonatomic , assign) CGFloat headViewToBubbleHorSpace;

@property(nonatomic , assign) CGFloat headViewToTopWithoutTime;

@property(nonatomic , assign) CGFloat headViewToTimeVerSpace;

@property(nonatomic , assign) CGFloat timeLabelHeight;

@property(nonatomic , assign) CGFloat bubbleToTimeVerSpace;

@property(nonatomic , assign) CGFloat bubbleToTop;

@property(nonatomic , assign) CGFloat sentingIndicatorToBubbleHorSapce;

@property(nonatomic , assign) CGFloat sentFailedViewToBunbbleHorSpace;

@property(nonatomic , assign) CGFloat sentFailedViewWidth;

@property(nonatomic , assign) CGFloat sentFailedViewHeight;

@property(nonatomic , assign) CGFloat sentFailedViewMinSpaceToHorBorder;

@property(nonatomic , assign) CGFloat bubbleArrowWidth;

@property(nonatomic , assign) CGFloat textMessageToBubbleHorBorder;

@property(nonatomic , assign) CGFloat textMessageToBubbleVerBorder;

@property(nonatomic , assign) CGFloat bubbleToBottom;

@property(nonatomic , assign) CGFloat bubbleImageViewMinHeight;

@property(nonatomic , assign) CGFloat voicePlayImageHeight;

@property(nonatomic , assign) CGFloat voicePlayImageWidth;

@property(nonatomic , assign) CGFloat voiceToBubbleHorBorder;

//font

@property(nonatomic , strong) UIFont *timeLabelFont;
@property(nonatomic , strong) UIFont *textMessageFont;
@property(nonatomic , strong) UIFont *voiceDurationFont;

//textColor

@property(nonatomic , strong) UIColor *timeLabelTextColor;
@property(nonatomic , strong) UIColor *textMessageColor;
@property(nonatomic , strong) UIColor *voiceDurationTextColor;

//bubble image

@property(nonatomic , strong) UIImage *othersBubbleWithArrow;
@property(nonatomic , strong) UIImage *othersBubbleWithoutArrow;

@property(nonatomic , strong) UIImage *myBubbleWithArrow;
@property(nonatomic , strong) UIImage *myBubbleWithoutArrow;

@property(nonatomic , strong) UIImage *voicePlayImage;

//sent failimage

@property(nonatomic , strong) UIImage *sentFailedImage_Normal;

@property(nonatomic , strong) UIImage *sentFailedImage_Highlight;

//max recordVoice duration

@property(nonatomic , assign) CGFloat maxRecordVoiceDuration;
@property(nonatomic , assign) CGFloat minRecordVoiceDuration;


+ (instancetype) shareConfig;

@end
