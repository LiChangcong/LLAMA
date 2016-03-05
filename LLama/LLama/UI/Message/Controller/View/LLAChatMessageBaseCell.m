//
//  LLAChatMessageBaseCell.m
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAChatMessageBaseCell.h"

#import "LLAUserHeadView.h"
#import "LLAMessageChatConfig.h"
#import "LLAUser.h"
#import "LLAIMMessage.h"

#import "LLAChatMessageTextCell.h"
#import "LLAChatMessageImageCell.h"
#import "LLAChatMessageVoiceCell.h"

@interface LLAChatMessageBaseCell()<LLAUserHeadViewDelegate>
{
    UIActivityIndicatorView *sentingIndicator;
    
    UIButton *sentFailedButton;
    
    NSDateFormatter *dateFormatter;
    
}

@property(nonatomic , readwrite , strong) UILabel *timeLabel;

@property(nonatomic , readwrite , strong) LLAUserHeadView *headView;

@property(nonatomic , readwrite , strong) UIImageView *bubbleImageView;

@property(nonatomic , readwrite , strong) LLAIMMessage *currentMessage;

@property(nonatomic , readwrite , assign) BOOL shouldShowTime;

@property(nonatomic , readwrite , assign) CGFloat cellMaxWidth;


@end

@implementation LLAChatMessageBaseCell

@synthesize headView;
@synthesize bubbleImageView;
@synthesize timeLabel;
@synthesize currentMessage;
@synthesize shouldShowTime;
@synthesize cellMaxWidth;

#pragma mark - Init

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHex:0x211f2c];
        
        [self baseCommonInit];
    }
    
    return self;
    
}

- (void) baseCommonInit {
    [self baseSetup];
    [self baseInitVariables];
    [self baseInitSubViews];
}

- (void) baseSetup {
    self.imageView.image = nil;
    self.imageView.hidden = YES;
    self.textLabel.text = nil;
    self.textLabel.hidden = YES;
    self.detailTextLabel.text = nil;
    self.detailTextLabel.hidden = YES;
}


- (void) baseInitVariables {
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
}

- (void) baseInitSubViews {
    
    timeLabel = [[UILabel alloc] init];
    
    timeLabel.font = [LLAMessageChatConfig shareConfig].timeLabelFont;
    timeLabel.textColor = [LLAMessageChatConfig shareConfig].timeLabelTextColor;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:timeLabel];
    
    headView = [[LLAUserHeadView alloc] init];
    //headView.translatesAutoresizingMaskIntoConstraints = NO;
    headView.delegate = self;
    
    [self.contentView addSubview:headView];
    
    bubbleImageView = [[UIImageView alloc] init];
    bubbleImageView.clipsToBounds = YES;
    
    [self.contentView addSubview:bubbleImageView];
    
    sentingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    sentingIndicator.hidesWhenStopped = YES;
    [sentingIndicator stopAnimating];
    
    [self.contentView addSubview:sentingIndicator];
    
    sentFailedButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [LLAMessageChatConfig shareConfig].sentFailedViewWidth, [LLAMessageChatConfig shareConfig].sentFailedViewHeight)];
    
    [sentFailedButton setImage:[LLAMessageChatConfig shareConfig].sentFailedImage_Normal forState:UIControlStateNormal];
    [sentFailedButton setImage:[LLAMessageChatConfig shareConfig].sentFailedImage_Highlight forState:UIControlStateHighlighted];
    
    [sentFailedButton addTarget:self action:@selector(sentFailedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:sentFailedButton];
    
}

#pragma mark - layout sub view

- (void) layoutSubviews {
    
    [super layoutSubviews];
    
    if (!currentMessage) {
        return;
    }
    
    //
    
    CGSize cellSize = CGSizeMake(MAX(cellMaxWidth,self.bounds.size.width), self.bounds.size.height);
    LLAMessageChatConfig *config = [LLAMessageChatConfig shareConfig];
    CGSize bubbleSize = [[self class] calculateContentSizeWithMessage:currentMessage maxWidth:cellSize.width];
    
    CGFloat offsetY = 0;
    
    if (shouldShowTime) {
        //time Label
        timeLabel.text = [self formatTimeString];
        timeLabel.frame = CGRectMake(0, 0, cellSize.width, config.timeLabelHeight);
        offsetY += config.timeLabelHeight;
        offsetY += config.bubbleToTimeVerSpace;
    }
    
    CGRect headFrame;
    CGRect bubbleImageViewFrame;
    CGRect indicatorFrame;
    CGRect sentFailedFrame;
    
    //bubble
    UIImage *bubbleImage = nil;
    if (currentMessage.ioType == LLAIMMessageIOType_In) {
        //others message
        if (shouldShowTime) {
            bubbleImage = config.othersBubbleWithArrow;
            
            headFrame = CGRectMake(config.headViewToHorBorder,config.timeLabelHeight+config.headViewToTimeVerSpace, config.userHeadViewHeightWidth, config.userHeadViewHeightWidth);
            bubbleImageViewFrame = CGRectMake(headFrame.origin.x+headFrame.size.width+config.headViewToBubbleHorSpace,config.timeLabelHeight+config.bubbleToTimeVerSpace, bubbleSize.width, bubbleSize.height);
            indicatorFrame = CGRectMake(bubbleImageViewFrame.origin.x+bubbleImageView.size.width+config.sentingIndicatorToBubbleHorSapce, bubbleImageViewFrame.origin.y+(bubbleImageView.size.height-sentingIndicator.bounds.size.height)/2, sentingIndicator.bounds.size.width, sentingIndicator.bounds.size.height);
            sentFailedFrame = CGRectMake(bubbleImageViewFrame.origin.x+bubbleImageView.size.width+config.sentFailedViewToBunbbleHorSpace, bubbleImageViewFrame.origin.y+(bubbleImageView.size.height-config.sentFailedViewHeight)/2, config.sentFailedViewWidth, config.sentFailedViewHeight);
            
        }else {
            bubbleImage = config.othersBubbleWithoutArrow;
            
            headFrame = CGRectMake(config.headViewToHorBorder,config.headViewToTopWithoutTime, config.userHeadViewHeightWidth, config.userHeadViewHeightWidth);
            bubbleImageViewFrame = CGRectMake(headFrame.origin.x+headFrame.size.width+config.headViewToBubbleHorSpace,config.bubbleToTop, bubbleSize.width, bubbleSize.height);
            indicatorFrame = CGRectMake(bubbleImageViewFrame.origin.x+bubbleImageView.size.width+config.sentingIndicatorToBubbleHorSapce, bubbleImageViewFrame.origin.y+(bubbleImageView.size.height-sentingIndicator.bounds.size.height)/2, sentingIndicator.bounds.size.width, sentingIndicator.bounds.size.height);
            sentFailedFrame = CGRectMake(bubbleImageViewFrame.origin.x+bubbleImageView.size.width+config.sentFailedViewToBunbbleHorSpace, bubbleImageViewFrame.origin.y+(bubbleImageView.size.height-config.sentFailedViewHeight)/2, config.sentFailedViewWidth, config.sentFailedViewHeight);
            
        }
        
    }else {
        //my message
        
        if (shouldShowTime) {
            bubbleImage = config.myBubbleWithArrow;
            
            headFrame = CGRectMake(cellSize.width - config.headViewToHorBorder - config.userHeadViewHeightWidth,config.timeLabelHeight+config.headViewToTimeVerSpace, config.userHeadViewHeightWidth, config.userHeadViewHeightWidth);
            
            bubbleImageViewFrame = CGRectMake(headFrame.origin.x - config.headViewToBubbleHorSpace - bubbleSize.width,config.timeLabelHeight+config.bubbleToTimeVerSpace, bubbleSize.width, bubbleSize.height);
            
            indicatorFrame = CGRectMake(bubbleImageViewFrame.origin.x - config.sentingIndicatorToBubbleHorSapce-sentingIndicator.bounds.size.width, bubbleImageViewFrame.origin.y+(bubbleImageView.size.height-sentingIndicator.bounds.size.height)/2, sentingIndicator.bounds.size.width, sentingIndicator.bounds.size.height);
            
            sentFailedFrame = CGRectMake(bubbleImageViewFrame.origin.x - config.sentFailedViewWidth - config.sentingIndicatorToBubbleHorSapce-config.sentFailedViewWidth, bubbleImageViewFrame.origin.y+(bubbleImageView.size.height-config.sentFailedViewHeight)/2, config.sentFailedViewWidth, config.sentFailedViewHeight);
            
        }else {
            bubbleImage = config.myBubbleWithoutArrow;
            
            headFrame = CGRectMake(cellSize.width - config.headViewToHorBorder - config.userHeadViewHeightWidth,config.headViewToTopWithoutTime, config.userHeadViewHeightWidth, config.userHeadViewHeightWidth);
            
            bubbleImageViewFrame = CGRectMake(headFrame.origin.x - config.headViewToBubbleHorSpace - bubbleSize.width,config.bubbleToTop, bubbleSize.width, bubbleSize.height);
            
            indicatorFrame = CGRectMake(bubbleImageViewFrame.origin.x - config.sentingIndicatorToBubbleHorSapce-sentingIndicator.bounds.size.width, bubbleImageViewFrame.origin.y+(bubbleImageView.size.height-sentingIndicator.bounds.size.height)/2, sentingIndicator.bounds.size.width, sentingIndicator.bounds.size.height);
            
            sentFailedFrame = CGRectMake(bubbleImageViewFrame.origin.x - config.sentFailedViewWidth - config.sentingIndicatorToBubbleHorSapce-config.sentFailedViewWidth, bubbleImageViewFrame.origin.y+(bubbleImageView.size.height-config.sentFailedViewHeight)/2, config.sentFailedViewWidth, config.sentFailedViewHeight);
        }
        
    }
    
    bubbleImageView.image = bubbleImage;
    
    headView.frame = headFrame;
    bubbleImageView.frame = bubbleImageViewFrame;
    sentingIndicator.frame = indicatorFrame;
    sentFailedButton.frame = sentFailedFrame;
    
    //
    
}

#pragma mark - Resent Message

- (void) sentFailedButtonClicked:(UIButton *) sender {
    
}

#pragma mark - HeadViewDelegate

- (void) headView:(LLAUserHeadView *)headView clickedWithUserInfo:(LLAUser *)user {
    
}

#pragma mark - 

- (void) updateCellWithMessage:(LLAIMMessage *) message maxWidth:(CGFloat) maxWidth showTime:(BOOL) showTime {
    
    if ([UIMenuController sharedMenuController].isMenuVisible) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    
    //
    shouldShowTime = showTime;
    
    cellMaxWidth = maxWidth;
    
    currentMessage = message;
    
    [headView updateHeadViewWithUser:message.authorUser];
    
    if (currentMessage.msgStatus == LLAIMMessageStatusSending) {
        [sentingIndicator startAnimating];
    }else {
        [sentingIndicator stopAnimating];
    }
    
    if (currentMessage.msgStatus == LLAIMMessageStatusFailed) {
        sentFailedButton.hidden = NO;
    }else {
        sentFailedButton.hidden = YES;
    }
    
    if (shouldShowTime) {
        timeLabel.hidden = NO;
        headView.hidden = NO;
    }else {
        timeLabel.hidden = YES;
        headView.hidden = YES;
    }
}

- (NSString *) formatTimeString {
    
    dateFormatter.dateFormat = @"HH:mm";
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:currentMessage.sendTimestamp/1000];
    
    return [dateFormatter stringFromDate:date];
}

+ (CGFloat) calculateHeightWithMessage:(LLAIMMessage *) message maxWidth:(CGFloat) maxWidth showTime:(BOOL) shouldShow {
    
    if (message.mediaType == LLAIMMessageType_Image) {
        
       return [LLAChatMessageImageCell calculateHeightWithMessage:message maxWidth:maxWidth showTime:shouldShow];
        
    }else if (message.mediaType == LLAIMMessageType_Audio) {
        
        return [LLAChatMessageVoiceCell calculateHeightWithMessage:message maxWidth:maxWidth showTime:shouldShow];
        
    }else {
        
        return [LLAChatMessageTextCell calculateHeightWithMessage:message maxWidth:maxWidth showTime:shouldShow];
    }
    
}

+ (CGSize) calculateContentSizeWithMessage:(LLAIMMessage *)message maxWidth:(CGFloat)maxWidth {
    //return  [[self class] calculateContentSizeWithMessage:message maxWidth:maxWidth];
    return CGSizeZero;
}

@end
