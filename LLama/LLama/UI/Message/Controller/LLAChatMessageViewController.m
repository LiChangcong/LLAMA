//
//  LLAChatMessageViewController.m
//  LLama
//
//  Created by Live on 16/3/1.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLAChatMessageViewController.h"
#import "LLAChatInputViewController.h"
#import "LLAUserProfileViewController.h"


//view
#import "LLATableView.h"
#import "LLALoadingView.h"
#import "LLAChatMessageTextCell.h"
#import "LLAChatMessageImageCell.h"
#import "LLAChatMessageVoiceCell.h"
#import "HZPhotoBrowser.h"

//model
#import "LLAIMConversation.h"
#import "LLAIMMessage.h"
#import "LLAIMImageMessage.h"
#import "LLAIMVoiceMessage.h"

//category
#import "UIScrollView+SVPullToRefresh.h"

//util
#import "LLAInstantMessageDispatchManager.h"
#import "LLAInstantMessageStorageUtil.h"
#import "LLAInstantMessageService.h"

#import "LLAIMCommonUtil.h"
#import "LLAAudioCacheUtil.h"
#import "XHVoiceCommonHelper.h"
#import "LLAMessageCountManager.h"
#import "YYShowAlertUtil.h"


#import "XHAudioPlayerHelper.h"

@interface LLAChatMessageViewController()<UITableViewDataSource,UITableViewDelegate,LLAChatInputViewControllerDelegate,LLAIMEventObserver,LLAChatMessageCellDelegate,XHAudioPlayerHelperDelegate,HZPhotoBrowserDelegate>
{
    LLATableView *dataTableView;
    
    LLAChatInputViewController *inputController;
    
    NSMutableArray<LLAIMMessage *> *messageArray;
    
    NSLayoutConstraint *inputViewHeightConstraints;
    
    LLAIMConversation *currentConversation;
    
    //should play audio message
    
    LLAIMVoiceMessage *willPlayAudioMessage;
    
    //playing audio message
    
    LLAIMVoiceMessage *playingAudioMessage;
    
    //show full image
    NSMutableArray<LLAIMImageMessage *> *showingImageMessages;
    
}

@end

@implementation LLAChatMessageViewController

#pragma mark - Life Cycle

- (void) dealloc {
    
    [[LLAInstantMessageDispatchManager sharedInstance] removeEventObserver:self forConversation:currentConversation.conversationId];
    [[LLAInstantMessageService shareService] removeChattinCoversation:currentConversation];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LLA_AUDIO_CACHE_DOWNLOAD_AUDIO_FINISH_NOTIFICATION object:nil];
}

- (instancetype) initWithConversation:(LLAIMConversation *)conversation {
    
    self = [super init];
    if (self) {
        currentConversation = conversation ;
    }
    
    return self;
}

- (void) resetChatControllerWihtConversation:(LLAIMConversation *)newConversation {
    //remove chatting conversation
    [[LLAInstantMessageService shareService] removeChattinCoversation:currentConversation];
    [[LLAInstantMessageService shareService] addChattingCoversation:newConversation];
    
    //
    currentConversation = newConversation;
    [self updateNavigationItems];
    
    [inputController resignInputView];
    [self loadMessageData];
    [self scrollTableToBottom];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioDownloadFinished:) name:LLA_AUDIO_CACHE_DOWNLOAD_AUDIO_FINISH_NOTIFICATION object:nil];
    
    //
    [[LLAInstantMessageService shareService] addChattingCoversation:currentConversation];
    
    [[LLAInstantMessageStorageUtil shareInstance] clearUnreadWithConvid:currentConversation.conversationId];
    [[LLAMessageCountManager shareManager] unReadIMNumChanged];

    
    //
    [self initVariables];
    [self updateNavigationItems];
    [self initSubViews];
    [self addIMEventObserver];
    
    [self loadMessageData];
    
    [self scrollTableToBottom];
    
    //
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHide:)];
    
    [dataTableView addGestureRecognizer:tapGesture];
    
    XHAudioPlayerHelper *sharePlayer = [XHAudioPlayerHelper shareInstance];
    
    sharePlayer.delegate = self;
    
}


#pragma mark - Init

- (void) initVariables {
    
    messageArray = [NSMutableArray array];
    showingImageMessages = [NSMutableArray arrayWithCapacity:1];
    
}

- (void) updateNavigationItems {
    
    LLAUser *targetUser = [LLAIMCommonUtil findTheOtherWithConversation:currentConversation mainUser:[LLAUser me]];
    
    self.navigationItem.title = targetUser.userName;
    
}

- (void) initSubViews {
    
    dataTableView = [[LLATableView alloc] init];
    dataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dataTableView.backgroundColor = [UIColor colorWithHex:0x211f2c];
    [self.view addSubview:dataTableView];
    
    WEAKSELF
    
    [dataTableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadMessageData];
    }];
    
    inputController = [[LLAChatInputViewController alloc] init];
    inputController.delegate = self;
    
    [self addChildViewController:inputController];
    [inputController didMoveToParentViewController:self];
    
    //
    UIView *inputView = inputController.view;
    inputView.backgroundColor = dataTableView.backgroundColor;
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:inputView];
    
    //constraints
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[dataTableView]-(0)-[inputView(height)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"height":@([LLAChatInputViewController normalHeight])}
      views:NSDictionaryOfVariableBindings(dataTableView,inputView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[dataTableView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataTableView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[inputView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(inputView)]];
    
    //
    for (NSLayoutConstraint *constr in self.view.constraints) {
        if (constr.firstItem == inputView && constr.firstAttribute == NSLayoutAttributeHeight) {
            
            inputViewHeightConstraints = constr;
            break;
        }
    }
    
}

- (void) addIMEventObserver {
    
    [[LLAInstantMessageDispatchManager sharedInstance] addEventObserver:self forConversation:currentConversation.conversationId];
}

#pragma mark - Load Message

- (void) loadMessageData {
    
    long long timestamps = [[NSDate date] timeIntervalSince1970]*1000;
    
    //last message
    LLAIMMessage *lastMessage = [messageArray firstObject];
    if (lastMessage) {
        timestamps = lastMessage.sendTimestamp;
    }
    
    //
    NSArray *msgs = [[LLAInstantMessageStorageUtil shareInstance] getMsgsWithConvid:currentConversation.conversationId maxTime:timestamps limit:LLACONVERSATION_LOAD_HISTORY_MESSAGE_NUMPERTIME];
    
    for (int i = (int)msgs.count - 1;i >=0 ;i--) {
        
        LLAIMMessage *newMessage = msgs[i];
        [messageArray insertObject:newMessage atIndex:0];
    }
    
    //[messageArray addObjectsFromArray:msgs];
    
    CGFloat preContentHeight = dataTableView.contentSize.height;
    CGFloat preOffsetY = dataTableView.contentOffset.y;
    [dataTableView reloadData];
    CGFloat newOffsetY = dataTableView.contentSize.height - preContentHeight + preOffsetY;
    dataTableView.contentOffset = CGPointMake(dataTableView.contentOffset.x, newOffsetY);
    
    [dataTableView.pullToRefreshView stopAnimating];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messageArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LLAIMMessage *message = messageArray[indexPath.row];
    
    UITableViewCell *cell = nil;
    
    BOOL showTime = [self shouldShowTimeAtIndex:indexPath.row];
    
    if (message.mediaType == LLAIMMessageType_Image) {
        
        static NSString *imageIden = @"imageIden";
        
        LLAChatMessageImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:imageIden];
        if (!imageCell) {
            imageCell = [[LLAChatMessageImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageIden];
            imageCell.delegate = self;
        }
        [imageCell updateCellWithMessage:message maxWidth:tableView.bounds.size.width showTime:showTime];
        
        cell = imageCell;
        
    }else if (message.mediaType == LLAIMMessageType_Audio) {
        
        static NSString *voiceIden = @"voiceIden";
        
        LLAChatMessageVoiceCell *voiceCell = [tableView dequeueReusableCellWithIdentifier:voiceIden];
        if (!voiceCell) {
            voiceCell = [[LLAChatMessageVoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:voiceIden];
            voiceCell.delegate = self;
        }
        
        [voiceCell updateCellWithMessage:message maxWidth:tableView.bounds.size.width showTime:showTime];
        
        [voiceCell updateVoiceStausWithIsPlaying:message == playingAudioMessage];
        
        cell = voiceCell;
        
        
    }else {
        //text
        
        static NSString *textIden = @"textIden";
        
        LLAChatMessageTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:textIden];
        if (!textCell) {
            textCell = [[LLAChatMessageTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textIden];
            textCell.delegate = self;
        }
        
        [textCell updateCellWithMessage:message maxWidth:tableView.bounds.size.width showTime:showTime];
        
        cell = textCell;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    BOOL showTime = [self shouldShowTimeAtIndex:indexPath.row];
    
    return [LLAChatMessageBaseCell calculateHeightWithMessage:messageArray[indexPath.row] maxWidth:tableView.bounds.size.width showTime:showTime];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LLAIMMessage *message = messageArray[indexPath.row];
    
    if (message.mediaType == LLAIMMessageType_Audio) {
        
        LLAIMVoiceMessage *voiceMessage = (LLAIMVoiceMessage *)message;
        
        [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:voiceMessage.audioURL toPlay:YES];
    }
    
}

#pragma mark - MessageCellDelegate

- (void) resentFailedMessage:(LLAIMMessage *) message {
    if (message) {
        
        [YYShowAlertUtil showAlertViewWithTitle:@"重发该消息" message:@"" cancelButtonTitle:@"取消" alertType:YYShowAlertType_AlertView destructiveButtonTitle:nil inViewController:self buttonClickedBlock:^(NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                message.msgStatus = LLAIMMessageStatusSending;
                [dataTableView reloadData];
                
                [self sendMessage:message isResent:YES];

            }
            
        } otherButtonTitles:@"确定", nil];
        
            }
}

- (void) showUserDetailWithUserInfo:(LLAUser *) userInfo {
    [self pushToUserProfileWithUserInfo:userInfo];
}

//for image cell
- (void) showFullImageWithMessage:(LLAIMMessage *) message imageView:(UIImageView *)imageView{
    
    //show full image
    [showingImageMessages removeAllObjects];
    
    if (message.mediaType == LLAIMMessageType_Image) {
        LLAIMImageMessage *imageMessage = (LLAIMImageMessage *) message;
        
        [showingImageMessages addObject:imageMessage];
        
        //show
        HZPhotoBrowser *photoBrower = [[HZPhotoBrowser alloc] init];
        photoBrower.sourceImagesContainerView = imageView;
        photoBrower.imageCount = showingImageMessages.count;
        
        photoBrower.delegate = self;
        
        [photoBrower show];
    }
    
}
//for voice cell

- (void) playStopVoiceWithMessage:(LLAIMMessage *) message {
    
    LLAIMVoiceMessage *voiceMessage = (LLAIMVoiceMessage *) message;

    //
    if (message == playingAudioMessage) {
        
        [[XHAudioPlayerHelper shareInstance] stopAudio];
        playingAudioMessage = nil;
        return;
        
    }else {
        
        [[XHAudioPlayerHelper shareInstance] stopAudio];
        playingAudioMessage = nil;
    }
    
    //
    if ([LLAAudioCacheUtil isFilePathURLString:voiceMessage.audioURL]) {
        //for tmp message,play
        
        playingAudioMessage = (LLAIMVoiceMessage *)message;
        
        NSString *key = [XHVoiceCommonHelper keyFromPath:voiceMessage.audioURL];
        NSString *playPath = [XHVoiceCommonHelper audioPathWithKey:key];
        
        [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:playPath toPlay:YES];
        //
        
        
    }else {

        if ([[LLAAudioCacheUtil shareInstance] isCachedForAudioURL:[NSURL URLWithString:voiceMessage.audioURL]] ) {
            
            //cached,play it
            NSURL *filePathURL = [[LLAAudioCacheUtil shareInstance] cacheURLForAudioURL:[NSURL URLWithString:voiceMessage.audioURL]];
            
            playingAudioMessage = (LLAIMVoiceMessage *)message;
            
            [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:filePathURL.path toPlay:YES];
            
            
        }else {
            //download it
            
            [[LLAAudioCacheUtil shareInstance] cacheAudioWithURL:[NSURL URLWithString:voiceMessage.audioURL]];
            
            //set to play it
            willPlayAudioMessage = (LLAIMVoiceMessage *)message;
        }
        
    }
    
}

#pragma mark - LLAChatInputViewControllerDelegate

- (void) sendMessageWithContent:(NSString *) textContent {
    
    if (textContent.length < 1) {
        return;
    }
    
    LLAIMMessage *message = [LLAIMMessage textMessageWithContent:textContent];
    
    [self sendMessage:message isResent:NO];
    
}

- (void) sendMessageWithImage:(UIImage *) image {
    
    
    if (!image) {
        return;
    }
    
    LLAIMImageMessage *message = [LLAIMImageMessage imageMessageWithImage:image];
    
    [self sendMessage:message isResent:NO];
    
}

- (void) sendMessageWithVoiceURL:(NSString *)voiceFilePath withDuration:(CGFloat)duration {
    
    LLAIMVoiceMessage *voiceMessage = [LLAIMVoiceMessage voiceMessageWithAudioFilePath:voiceFilePath withDuration:duration];
    
    [self sendMessage:voiceMessage isResent:NO];
}

- (void) sendMessage:(LLAIMMessage *) message isResent:(BOOL) isResent{
    
    [currentConversation sendMessage:message isResent:(BOOL) isResent progressBlock:NULL callback:^(BOOL succeeded, LLAIMMessage *newMessage, NSError *error) {
        
        NSInteger index = [messageArray indexOfObject:message];
        
        if (index != NSNotFound) {
            
            [messageArray replaceObjectAtIndex:index withObject:newMessage];
            //[dataTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [dataTableView reloadData];
        }
        
    }];

    
}

- (void) inputViewController:(LLAChatInputViewController *) inputViewController
                   newHeight:(CGFloat) newHeight
                    duration:(NSTimeInterval) duration
              animationCurve:(UIViewAnimationCurve) animationCurve {
    
//    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        
//        inputViewHeightConstraints.constant = newHeight;
//        [self.view layoutIfNeeded];
//        
//    } completion:^(BOOL finished) {
//        
//    }];
    
    //
    CGFloat changeHeight = newHeight - inputController.view.frame.size.height;
    
    BOOL shouldOffset = ceilf(dataTableView.contentOffset.y+dataTableView.frame.size.height) == ceilf(dataTableView.contentSize.height);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:duration];
    
    inputViewHeightConstraints.constant = newHeight;
    
    //
    
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
    
    //---计算tableView应该滚动的高度,以viewoffset来计算相对变化的高度
    if (!(shouldOffset && changeHeight<0)){
        CGFloat maxOffset = MAX(dataTableView.contentSize.height - dataTableView.frame.size.height,0);
        CGFloat changeOffset = dataTableView.contentOffset.y+changeHeight;
        
        CGFloat actualOffset = MIN(changeOffset,maxOffset);
        actualOffset = MAX(actualOffset,0);
        
        dataTableView.contentOffset = CGPointMake(dataTableView.contentOffset.x, actualOffset);
    }


    
}

#pragma mark - LLAIMEventObserver

- (void) newMessageArrived:(LLAIMMessage *)message conversation:(LLAIMConversation *)conversation {
    
    if ([currentConversation.conversationId isEqualToString:conversation.conversationId] && message) {
        
//        BOOL shouldScroll = NO;
//        
//        if (messageArray.count > 0) {
//            
//            NSArray *visibleArray = [dataTableView indexPathsForVisibleRows];
//            
//            for (NSIndexPath *indexPath in  visibleArray) {
//                if (indexPath.row == messageArray.count - 1) {
//                    shouldScroll = YES;
//                    break;
//                }
//            }
//            
//        }
        
        [messageArray addObject:message];
        [dataTableView reloadData];
        
        //if (shouldScroll) {
        [self scrollTableToBottom];
        //}
        
    }
}

- (void) messageDelivered:(LLAIMMessage *)message conversation:(LLAIMConversation *)conversation {
    
}

- (void) imClientStatusChanged:(IMClientStatus)status {
    
}

#pragma mark - XHAudioPlayerHelperDelegate

- (void)didAudioPlayerBeginPlay:(AVAudioPlayer*)audioPlayer {
    //set start playing video
    NSInteger index = [messageArray indexOfObject:playingAudioMessage];
    
    
    //update status
    
    if (index != NSNotFound) {
        
        LLAChatMessageVoiceCell *voiceCell = [dataTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [voiceCell updateVoiceStausWithIsPlaying:YES];
        
        
    }
    

    
    
    
}

- (void)didAudioPlayerStopPlay:(AVAudioPlayer*)audioPlayer {
    //stop the playing video
    
    NSInteger index = [messageArray indexOfObject:playingAudioMessage];
    
    if (index != NSNotFound) {
        
        LLAChatMessageVoiceCell *voiceCell = [dataTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        [voiceCell updateVoiceStausWithIsPlaying:NO];
        
    }

    playingAudioMessage = nil;
    
}

- (void)didAudioPlayerPausePlay:(AVAudioPlayer*)audioPlayer {
    
}


#pragma mark - audioDownloadFinished notification

- (void) audioDownloadFinished:(NSNotification *) noti {
    //
    if (self.isVisible) {
        //
        NSURL *finishedURL = noti.object;
        
        if ([finishedURL isEqual:[NSURL URLWithString:willPlayAudioMessage.audioURL]]) {
            
            //play
            [self playStopVoiceWithMessage:willPlayAudioMessage];
            willPlayAudioMessage = nil;
            
        }
        
    }else {
        //
        willPlayAudioMessage = nil;
    }
    
}

#pragma mark - Photo Browser Delegate

- (UIImage *) photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    if (index < showingImageMessages.count) {
        
        LLAIMImageMessage *imageMessage = [showingImageMessages objectAtIndex:index];
        //if is temp image
        if ([imageMessage.imageURL isFileURL]) {
            
            //get temp file
            NSString *filePath = [LLAIMMessage filePathForKey:imageMessage.messageId];
            
            return [UIImage imageWithContentsOfFile:filePath];
            
        }else {
            return [UIImage llaImageWithName:@"placeHolder_750"];
            
        }
        
    }else {
        return nil;
    }
}

- (NSURL *) photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    if (index < showingImageMessages.count) {
        
        LLAIMImageMessage *imageMessage = [showingImageMessages objectAtIndex:index];
        return imageMessage.imageURL;
        
    }else {
        return nil;
    }
}

#pragma mark - ScrollToBottom

- (void) scrollTableToBottom {
    if (messageArray.count > 0) {
        
        [dataTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Should Show Time

- (BOOL) shouldShowTimeAtIndex:(NSInteger) index {
    
    if (index > messageArray.count-1) {
        return NO;
    }
    
    if (index == 0) {
        return YES;
    }
    
    LLAIMMessage *curMsg = messageArray[index];
    LLAIMMessage *preMsg = messageArray[index - 1];
    
    if (curMsg.ioType != preMsg.ioType) {
        return YES;
    }
    
    if ((curMsg.sendTimestamp - preMsg.sendTimestamp)/1000 >120) {
        return YES;
    }else {
        return NO;
    }
    
}

#pragma mark - Reset input controller

- (void) tapToHide:(UITapGestureRecognizer *) ges {
    [self resetInputController];
}

- (void) resetInputController {
    [inputController resignInputView];
}

#pragma mark - Private Method

- (void) pushToUserProfileWithUserInfo:(LLAUser *) userInfo {
    if (userInfo.userIdString.length > 0) {
        LLAUserProfileViewController *userProfile = [[LLAUserProfileViewController alloc] initWithUserIdString:userInfo.userIdString];
        [self.navigationController pushViewController:userProfile animated:YES];
    }
}


@end
