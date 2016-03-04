//
//  LLAMessageViewController.m
//  LLama
//
//  Created by tommin on 16/2/22.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controler
#import "LLAMessageViewController.h"
#import "LLAMessageReceivedPraiseController.h"
#import "LLAMessageReceivedCommentController.h"
#import "LLAMessageOrderAideController.h"
#import "LLAChatMessageViewController.h"

//view
#import "LLATableView.h"
#import "LLALoadingView.h"

#import "LLAMessageCenterSystemMessageCell.h"
#import "LLAMessageCenterConversationCell.h"

//model
#import "LLAMessageCenterSystemMsgInfo.h"
#import "LLAMessageCenterRoomInfo.h"
#import "LLAUser.h"

//util
#import "LLAViewUtil.h"
#import "LLAInstantMessageDispatchManager.h"
#import "LLAInstantMessageStorageUtil.h"

//category
#import "UIScrollView+SVPullToRefresh.h"

static const NSInteger systemMessageSectionIndex = 0;
static const NSInteger conversationSectionIndex = 1;

@interface LLAMessageViewController ()<UITableViewDataSource,UITableViewDelegate,LLAIMEventObserver>
{
    LLATableView *dataTableView;
    
    NSMutableArray *systemMessageArray;
    
    NSMutableArray<LLAMessageCenterRoomInfo *> *roomArray;
}

@end

@implementation LLAMessageViewController

#pragma mark - Life Cycle

- (void) dealloc {
    
    [[LLAInstantMessageDispatchManager sharedInstance] removeEventObserver:self forConversation:INSTANT_MESSAGE_ALL_MESSAGE];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initVariables];
    [self initNavigationItems];
    [self initSubViews];
    
    [self addIMObserver];
    
    [self loadRoomData];
    
    //
//    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
//    
//    [paramsDic setValue:@(0) forKey:@"type"];
//    
//    NSMutableArray *members = [NSMutableArray arrayWithCapacity:2];
//    [members addObject:[[LLAUser me] dicForIMAttributes]];
//    [members addObject:[[LLAUser me] dicForIMAttributes]];
//    
//    [paramsDic setValue:members forKey:@"members"];
//    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsDic options:NSJSONWritingPrettyPrinted error:nil];
//    
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"%@",jsonString);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

- (void) initVariables {
    //
    systemMessageArray = [NSMutableArray arrayWithCapacity:3];
    roomArray = [NSMutableArray array];
    
    //test Data
    LLAMessageCenterSystemMsgInfo *praise = [LLAMessageCenterSystemMsgInfo new];
    praise.titleString = @"收到的赞";
    praise.unreadNum = 0;
    praise.messageType = LLASystemMessageType_BePraised;
    
    [systemMessageArray addObject:praise];
    
    LLAMessageCenterSystemMsgInfo *comment = [LLAMessageCenterSystemMsgInfo new];
    comment.titleString = @"收到的评论";
    comment.unreadNum = 1;
    comment.messageType = LLASystemMessageType_BeCommented;
    
    [systemMessageArray addObject:comment];
    
    LLAMessageCenterSystemMsgInfo *order = [LLAMessageCenterSystemMsgInfo new];
    order.titleString = @"订单助手";
    order.unreadNum = 100;
    order.messageType = LLASystemMessageType_Order;
    
    [systemMessageArray addObject:order];
    
    LLAMessageCenterRoomInfo *roomInfo = [LLAMessageCenterRoomInfo new];
    
}

- (void) initNavigationItems {
    self.navigationItem.title = @"消息";
}

- (void) initSubViews {
    dataTableView = [[LLATableView alloc] init];
    dataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    dataTableView.backgroundColor = [UIColor colorWithHex:0x211f2c];
    
    [self.view addSubview:dataTableView];
    
    //
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[dataTableView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataTableView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[dataTableView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataTableView)]];
    
}

- (void) addIMObserver {
    
    [[LLAInstantMessageDispatchManager sharedInstance] addEventObserver:self forConversation:INSTANT_MESSAGE_ALL_MESSAGE];
}

#pragma mark - LoadData

- (void) loadRoomData {
    
    NSArray *rooms = [[LLAInstantMessageStorageUtil shareInstance] getRooms];
    
    for (LLAIMConversation *conversation in rooms) {
        
        LLAMessageCenterRoomInfo *roomInfo = [LLAMessageCenterRoomInfo roomInfoWithConversation:conversation];
        
        [roomArray addObject:roomInfo];
        
    }
    
    [dataTableView reloadData];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //test
    if (section == systemMessageSectionIndex) {
        return systemMessageArray.count;
    }else if (section == conversationSectionIndex) {
        return roomArray.count;
    }else {
        return 0;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    if (indexPath.section == systemMessageSectionIndex) {
        static NSString * systemIden = @"systemIden";
        
        LLAMessageCenterSystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:systemIden];
        if (!cell) {
            cell = [[LLAMessageCenterSystemMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemIden];
        }
        
        [cell updateCellWithMsgInfo:systemMessageArray[indexPath.row] tableWidth:tableView.bounds.size.width];
        
        return cell;
        
    
    }else if (indexPath.section == conversationSectionIndex) {
        
        static NSString *roomIden = @"roomIden";
        
        LLAMessageCenterConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:roomIden];
        if (!cell) {
            cell = [[LLAMessageCenterConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:roomIden];
        }
        
        [cell updateCellWithRoomInfo:roomArray[indexPath.row] tableWidth:tableView.bounds.size.width];
        return cell;
        
    }else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == systemMessageSectionIndex) {
        LLAMessageCenterSystemMsgInfo *msgInfo = systemMessageArray[indexPath.row];
        
        if (msgInfo.messageType == LLASystemMessageType_BePraised) {
            //
            LLAMessageReceivedPraiseController *praised = [[LLAMessageReceivedPraiseController alloc] init];
            [self.navigationController pushViewController:praised animated:YES];
            
        }else if (msgInfo.messageType == LLASystemMessageType_BeCommented) {
            //
            LLAMessageReceivedCommentController *comment = [[LLAMessageReceivedCommentController alloc] init];
            [self.navigationController pushViewController:comment animated:YES];
            
        }else if (msgInfo.messageType == LLASystemMessageType_Order) {
            //
            LLAMessageOrderAideController *order = [[LLAMessageOrderAideController alloc] init];
            [self.navigationController pushViewController:order animated:YES];
        }
        
    }else if (indexPath.section == conversationSectionIndex) {
        //
        
        LLAMessageCenterRoomInfo *roomInfo = roomArray[indexPath.row];
        
        if (roomInfo.conversation) {
        
            LLAChatMessageViewController *chat = [[LLAChatMessageViewController alloc] initWithConversation:roomInfo.conversation];
            
            [self.navigationController pushViewController:chat animated:YES];
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == systemMessageSectionIndex) {
        return [LLAMessageCenterSystemMessageCell calculateCellWithMsgInfo:systemMessageArray[indexPath.row] tableWidth:tableView.bounds.size.width];
    }else if (indexPath.section == conversationSectionIndex) {
        return [LLAMessageCenterConversationCell calculateCellHeight:roomArray[indexPath.row] tableWidth:tableView.bounds.size.width];
    }else {
        return 0;
    }
}

//
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == conversationSectionIndex) {
        return YES;
    }else {
        return NO;
    }
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == conversationSectionIndex && editingStyle == UITableViewCellEditingStyleDelete) {
        //delete conversation
    }
}

#pragma mark - LLAIMEventObserver

- (void) newMessageArrived:(LLAIMMessage *)message conversation:(LLAIMConversation *)conversation {
    
    NSInteger index = [self indexOfConversationInRoomArray:conversation];
    if (index == NSNotFound) {
        
        LLAMessageCenterRoomInfo *rooInfo = [LLAMessageCenterRoomInfo roomInfoWithConversation:conversation];
        rooInfo.conversation.lastMessage = message;
        
        [roomArray insertObject:rooInfo atIndex:0];
        
        [dataTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:conversationSectionIndex]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else {
        
        LLAMessageCenterRoomInfo *roomInfo = roomArray[index];
        
        [roomArray removeObjectAtIndex:index];
        [roomArray insertObject:roomInfo atIndex:0];
        
        [dataTableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:conversationSectionIndex] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:conversationSectionIndex]];
        
    }
    
}

- (void) messageDelivered:(LLAIMMessage *)message conversation:(LLAIMConversation *)conversation {
    
}

- (void) imClientStatusChanged:(IMClientStatus)status {
    
}

#pragma mark - Index of conversation

- (NSInteger) indexOfConversationInRoomArray:(LLAIMConversation *) conversation {
    
    NSInteger index = NSNotFound;
    
    for (int i=0;i<roomArray.count;i++) {
        LLAMessageCenterRoomInfo *roomInfo = roomArray[i];
        
        if ([roomInfo.conversation.conversationId isEqualToString:conversation.conversationId]) {
            index = i;
            break;
        }
    }
    
    return index;
}

@end
