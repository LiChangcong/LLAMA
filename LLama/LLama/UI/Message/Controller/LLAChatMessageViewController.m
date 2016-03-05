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


//view
#import "LLATableView.h"
#import "LLALoadingView.h"
#import "LLAChatMessageTextCell.h"
#import "LLAChatMessageImageCell.h"
#import "LLAChatMessageVoiceCell.h"

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
#import "LLAIMCommonUtil.h"

#import "XHAudioPlayerHelper.h"

@interface LLAChatMessageViewController()<UITableViewDataSource,UITableViewDelegate,LLAChatInputViewControllerDelegate,LLAIMEventObserver>
{
    LLATableView *dataTableView;
    
    LLAChatInputViewController *inputController;
    
    NSMutableArray<LLAIMMessage *> *messageArray;
    
    NSLayoutConstraint *inputViewHeightConstraints;
    
    LLAIMConversation *currentConversation;
}

@end

@implementation LLAChatMessageViewController

#pragma mark - Life Cycle

- (void) dealloc {
    [[LLAInstantMessageDispatchManager sharedInstance] removeEventObserver:self forConversation:currentConversation.conversationId];
}

- (instancetype) initWithConversation:(LLAIMConversation *)conversation {
    
    self = [super init];
    if (self) {
        currentConversation = conversation ;
    }
    
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //
    [self initVariables];
    [self updateNavigationItems];
    [self initSubViews];
    [self addIMEventObserver];
    
    [self loadMessageData];
    
    [self scrollTableToBottom];
    
    //
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHide:)];
    
    [self.view addGestureRecognizer:tapGesture];
    
}


#pragma mark - Init

- (void) initVariables {
    messageArray = [NSMutableArray array];
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
    
    [messageArray addObjectsFromArray:msgs];
    [dataTableView reloadData];
    
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
        }
        [imageCell updateCellWithMessage:message maxWidth:tableView.bounds.size.width showTime:showTime];
        
        cell = imageCell;
        
    }else if (message.mediaType == LLAIMMessageType_Audio) {
        
        static NSString *voiceIden = @"voiceIden";
        
        LLAChatMessageVoiceCell *voiceCell = [tableView dequeueReusableCellWithIdentifier:voiceIden];
        if (!voiceCell) {
            voiceCell = [[LLAChatMessageVoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:voiceIden];
        }
        
        [voiceCell updateCellWithMessage:message maxWidth:tableView.bounds.size.width showTime:showTime];
        
        cell = voiceCell;
        
        
    }else {
        //text
        
        static NSString *textIden = @"textIden";
        
        LLAChatMessageTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:textIden];
        if (!textCell) {
            textCell = [[LLAChatMessageTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textIden];
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

#pragma mark - LLAChatInputViewControllerDelegate

- (void) sendMessageWithContent:(NSString *) textContent {
    
    if (textContent.length < 1) {
        return;
    }
    
    LLAIMMessage *message = [LLAIMMessage textMessageWithContent:textContent];
    
    [currentConversation sendMessage:message progressBlock:NULL callback:^(BOOL succeeded, LLAIMMessage *newMessage, NSError *error) {
        
        NSInteger index = [messageArray indexOfObject:message];
        
        if (index != NSNotFound) {
            
            [messageArray replaceObjectAtIndex:index withObject:newMessage];
            [dataTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }];
    
    //[[LLAInstantMessageDispatchManager sharedInstance] dispatchNewMessageArrived:message conversation:currentConversation];
    
}

- (void) sendMessageWithImage:(UIImage *) image {
    
    
    if (!image) {
        return;
    }
    
    LLAIMImageMessage *message = [LLAIMImageMessage imageMessageWithImage:image];
    
    [currentConversation sendMessage:message progressBlock:NULL callback:^(BOOL succeeded, LLAIMMessage *newMessage, NSError *error) {
        
        NSInteger index = [messageArray indexOfObject:message];
        
        if (index != NSNotFound) {
            
            [messageArray replaceObjectAtIndex:index withObject:newMessage];
            [dataTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            //[dataTableView reloadData];
        }
        
    }];

    
}

- (void) sendMessageWithVoiceURL:(NSString *)voiceFilePath withDuration:(CGFloat)duration {
    
    LLAIMVoiceMessage *voiceMessage = [LLAIMVoiceMessage voiceMessageWithAudioFilePath:voiceFilePath withDuration:duration];
    
    [currentConversation sendMessage:voiceMessage progressBlock:NULL callback:^(BOOL succeeded, LLAIMMessage *newMessage, NSError *error) {
        
        NSInteger index = [messageArray indexOfObject:voiceMessage];
        
        if (index != NSNotFound) {
            
            [messageArray replaceObjectAtIndex:index withObject:newMessage];
            [dataTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            //[dataTableView reloadData];
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
    
    [self.view layoutIfNeeded];
    [UIView commitAnimations];

    
    //---计算tableView应该滚动的高度,以viewoffset来计算相对变化的高度
    if (!(shouldOffset && changeHeight<0)){
        CGFloat maxOffset = MAX(dataTableView.contentSize.height - dataTableView.frame.size.height,0);
        CGFloat changeOffset = dataTableView.contentOffset.y+changeHeight;
        
        CGFloat actualOffset = MIN(changeOffset,maxOffset);
        actualOffset = MAX(actualOffset,0);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:animationCurve];
        [UIView setAnimationDuration:duration];
        dataTableView.contentOffset = CGPointMake(dataTableView.contentOffset.x, actualOffset);
        [self.view layoutIfNeeded];
        [UIView commitAnimations];
    }

    
}

#pragma mark - LLAIMEventObserver

- (void) newMessageArrived:(LLAIMMessage *)message conversation:(LLAIMConversation *)conversation {
    
    if ([currentConversation.conversationId isEqualToString:conversation.conversationId] && message) {
        
        BOOL shouldScroll = NO;
        
        if (messageArray.count > 0) {
            
            NSArray *visibleArray = [dataTableView indexPathsForVisibleRows];
            
            for (NSIndexPath *indexPath in  visibleArray) {
                if (indexPath.row == messageArray.count - 1) {
                    shouldScroll = YES;
                    break;
                }
            }
            
        }
        
        [messageArray addObject:message];
        [dataTableView reloadData];
        
        if (shouldScroll) {
            [self scrollTableToBottom];
        }
        
    }
}

- (void) messageDelivered:(LLAIMMessage *)message conversation:(LLAIMConversation *)conversation {
    
}

- (void) imClientStatusChanged:(IMClientStatus)status {
    
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


@end
