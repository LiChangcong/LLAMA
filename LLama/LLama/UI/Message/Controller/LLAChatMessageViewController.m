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

//util
#import "LLAInstantMessageDispatchManager.h"
#import "LLAInstantMessageStorageUtil.h"
#import "LLAIMCommonUtil.h"

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
    
    //
    [self initVariables];
    [self updateNavigationItems];
    [self initSubViews];
    [self addIMEventObserver];
    
    [self loadMessageData];
    
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
    
    inputController = [[LLAChatInputViewController alloc] init];
    inputController.delegate = self;
    
    [self addChildViewController:inputController];
    [inputController didMoveToParentViewController:self];
    
    //
    UIView *inputView = inputController.view;
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
    
    if (message.mediaType == LLAIMMessageType_Image) {
        
        static NSString *imageIden = @"imageIden";
        
        LLAChatMessageImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:imageIden];
        if (!imageCell) {
            imageCell = [[LLAChatMessageImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageIden];
        }
        [imageCell updateCellWithMessage:message maxWidth:tableView.bounds.size.width showTime:YES];
        
        cell = imageCell;
        
    }else if (message.mediaType == LLAIMMessageType_Audio) {
        
        static NSString *voiceIden = @"voiceIden";
        
        LLAChatMessageVoiceCell *voiceCell = [tableView dequeueReusableCellWithIdentifier:voiceIden];
        if (!voiceCell) {
            voiceCell = [[LLAChatMessageVoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:voiceIden];
        }
        
        [voiceCell updateCellWithMessage:message maxWidth:tableView.bounds.size.width showTime:YES];
        
        cell = voiceCell;
        
        
    }else {
        //text
        
        static NSString *textIden = @"textIden";
        
        LLAChatMessageTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:textIden];
        if (!textCell) {
            textCell = [[LLAChatMessageTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textIden];
        }
        
        [textCell updateCellWithMessage:message maxWidth:tableView.bounds.size.width showTime:YES];
        
        cell = textCell;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [LLAChatMessageBaseCell calculateHeightWithMessage:messageArray[indexPath.row] maxWidth:tableView.bounds.size.width showTime:YES];
}

#pragma mark - LLAChatInputViewControllerDelegate

- (void) sendMessageWithContent:(NSString *) textContent {
    
    if (textContent.length < 1) {
        return;
    }
    
    LLAIMMessage *message = [LLAIMMessage textMessageWithContent:textContent];
    
    [currentConversation sendMessage:message progressBlock:NULL callback:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
        }
        
    }];
    
    [[LLAInstantMessageDispatchManager sharedInstance] dispatchNewMessageArrived:message conversation:currentConversation];
    
}

- (void) sendMessageWithImage:(UIImage *) image {
    
}

- (void) sendMessageWithVoiceURL:(NSURL *) voiceURL {
    
}


- (void) inputViewController:(LLAChatInputViewController *) inputController
                   newHeight:(CGFloat) newHeight
                    duration:(NSTimeInterval) duration
              animationCurve:(UIViewAnimationCurve) animationCurve {
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        inputViewHeightConstraints.constant = newHeight;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - LLAIMEventObserver

- (void) newMessageArrived:(LLAIMMessage *)message conversation:(LLAIMConversation *)conversation {
    
    if ([currentConversation.conversationId isEqualToString:conversation.conversationId] && message) {
        
        [messageArray addObject:message];
        [dataTableView reloadData];
    }
}

- (void) messageDelivered:(LLAIMMessage *)message conversation:(LLAIMConversation *)conversation {
    
}

- (void) imClientStatusChanged:(IMClientStatus)status {
    
}

@end
