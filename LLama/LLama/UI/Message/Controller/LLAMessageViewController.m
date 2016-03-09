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
#import "LLAMessageCountManager.h"
#import "LLAHttpUtil.h"
#import "LLAInstantMessageService.h"

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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initVariables];
    [self initNavigationItems];
    [self initSubViews];
    
    [self addIMObserver];
    
    [self loadTypeListData];
    [self loadRoomData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageCountChanged:) name:LLA_UNREAD_MESSAGE_COUNT_CHANGED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openClientSuccess:) name:LLA_CONNECT_LEANCLOUD_CLIENT_SUCCESS_NOTIFICATION object:nil];
    
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
    
    //temp Data
    LLAMessageCenterSystemMsgInfo *praise = [LLAMessageCenterSystemMsgInfo new];
    praise.titleString = @"收到的赞";
    praise.unreadNum = [[LLAMessageCountManager shareManager] getUnreadPraiseNum];
    praise.messageType = LLASystemMessageType_BePraised;
    
    [systemMessageArray addObject:praise];
    
    LLAMessageCenterSystemMsgInfo *comment = [LLAMessageCenterSystemMsgInfo new];
    comment.titleString = @"收到的评论";
    comment.unreadNum = [[LLAMessageCountManager shareManager] getUnreadCommentNum];
    comment.messageType = LLASystemMessageType_BeCommented;
    
    [systemMessageArray addObject:comment];
    
    LLAMessageCenterSystemMsgInfo *order = [LLAMessageCenterSystemMsgInfo new];
    order.titleString = @"订单助手";
    order.unreadNum = [[LLAMessageCountManager shareManager] getUnreadOrderNum];
    order.messageType = LLASystemMessageType_Order;
    
    [systemMessageArray addObject:order];
    
    
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

- (void) loadTypeListData {
    
    [LLAHttpUtil httpPostWithUrl:@"/message/getTypeList" param:[NSDictionary dictionary] responseBlock:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            [systemMessageArray removeAllObjects];
            
            for (NSDictionary *dic in responseObject) {
                LLAMessageCenterSystemMsgInfo *info = [LLAMessageCenterSystemMsgInfo parsJsonWithDic:dic];
                if (info) {
                    [systemMessageArray addObject:info];
                }
            }
            
            [self updateUnreadMessage];
        }
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
    }];
    
}

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
            
            [[LLAMessageCountManager shareManager] resetUnreadPraiseNum];
            
        }else if (msgInfo.messageType == LLASystemMessageType_BeCommented) {
            //
            LLAMessageReceivedCommentController *comment = [[LLAMessageReceivedCommentController alloc] init];
            [self.navigationController pushViewController:comment animated:YES];
            
            [[LLAMessageCountManager shareManager] resetUnreadCommnetNum];
            
        }else if (msgInfo.messageType == LLASystemMessageType_Order) {
            //
            LLAMessageOrderAideController *order = [[LLAMessageOrderAideController alloc] init];
            [self.navigationController pushViewController:order animated:YES];
            
            [[LLAMessageCountManager shareManager] resetUnreadOrderNum];
        }
        
    }else if (indexPath.section == conversationSectionIndex) {
        //
        
        LLAMessageCenterRoomInfo *roomInfo = roomArray[indexPath.row];
        
        if (roomInfo.conversation) {
        
            roomInfo.conversation.unreadCount = 0;
            
            [dataTableView reloadData];
            
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
        
        LLAMessageCenterRoomInfo *roomInfo = roomArray[indexPath.row];
        
        [[LLAInstantMessageStorageUtil shareInstance] deleteRoomByConvid:roomInfo.conversation.conversationId];
        [[LLAInstantMessageStorageUtil shareInstance] deleteMsgsByConvid:roomInfo.conversation.conversationId];
        if (roomInfo.conversation.unreadCount > 0) {
            [[LLAMessageCountManager shareManager] unReadIMNumChanged];
        }
        
        [roomArray removeObjectAtIndex:indexPath.row];
        [dataTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
    }
}

#pragma mark - LLAIMEventObserver

- (void) newMessageArrived:(LLAIMMessage *)message conversation:(LLAIMConversation *)conversation {
    
    NSInteger index = [self indexOfConversationInRoomArray:conversation];
    if (index == NSNotFound) {
        
        LLAMessageCenterRoomInfo *rooInfo = [LLAMessageCenterRoomInfo roomInfoWithConversation:conversation];
        rooInfo.conversation.lastMessage = message;
        
        if (message) {
            rooInfo.conversation.unreadCount = 1;
        }
        
        [roomArray insertObject:rooInfo atIndex:0];
        
        [dataTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:conversationSectionIndex]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else {
        
        LLAMessageCenterRoomInfo *roomInfo = roomArray[index];
        
        if (message){
            roomInfo.conversation.lastMessage = message;
            if (![[LLAInstantMessageService shareService] isConversationChatting:roomInfo.conversation]) {
                roomInfo.conversation.unreadCount ++;
            }
        }
        
        if (index == 0) {
        
        }else {
        
            [roomArray removeObjectAtIndex:index];
            [roomArray insertObject:roomInfo atIndex:0];
        
            [dataTableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:conversationSectionIndex] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:conversationSectionIndex]];
        }
        
        [dataTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:conversationSectionIndex]] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
}

- (void) messageDelivered:(LLAIMMessage *)message conversation:(LLAIMConversation *)conversation {
    
}

- (void) imClientStatusChanged:(IMClientStatus)status {
    
}

#pragma mark - MessageCount Change

- (void) messageCountChanged:(NSNotification *) noti {
    [self updateUnreadMessage];
}

- (void) updateUnreadMessage {
    
    for (LLAMessageCenterSystemMsgInfo *msg in systemMessageArray) {
        if (msg.messageType == LLASystemMessageType_BePraised) {
            msg.unreadNum = [[LLAMessageCountManager shareManager] getUnreadPraiseNum];
        }else if (msg.messageType == LLASystemMessageType_BeCommented) {
            msg.unreadNum = [[LLAMessageCountManager shareManager] getUnreadCommentNum];
        }else if (msg.messageType == LLASystemMessageType_Order) {
            msg.unreadNum = [[LLAMessageCountManager shareManager] getUnreadOrderNum];
        }
    }
    
    [dataTableView reloadData];
}

#pragma mark - OpenClient Success

- (void) openClientSuccess:(NSNotification *) noti {
    
    //reload conversation
    AVIMClient *client = [LLAInstantMessageService shareService].imClient;
    
    for (LLAMessageCenterRoomInfo *room in roomArray) {
        
        room.conversation.leanConversation = [client conversationWithKeyedConversation:room.conversation.keyedConversation];
    }
    
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
