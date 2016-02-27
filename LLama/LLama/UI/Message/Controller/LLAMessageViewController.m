//
//  LLAMessageViewController.m
//  LLama
//
//  Created by tommin on 16/2/22.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controler
#import "LLAMessageViewController.h"

//view
#import "LLATableView.h"
#import "LLALoadingView.h"

#import "LLAMessageCenterSystemMessageCell.h"
#import "LLAMessageCenterConversationCell.h"

//model
#import "LLAMessageCenterSystemMsgInfo.h"
#import "LLAMessageCenterRoomInfo.h"

//util
#import "LLAViewUtil.h"

//category
#import "UIScrollView+SVPullToRefresh.h"

static const NSInteger systemMessageSectionIndex = 0;
static const NSInteger conversationSectionIndex = 1;

@interface LLAMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    LLATableView *dataTableView;
    
    NSMutableArray *systemMessageArray;
    
    NSMutableArray *roomArray;
}

@end

@implementation LLAMessageViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initVariables];
    [self initNavigationItems];
    [self initSubViews];

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
    
    [roomArray addObject:roomInfo];
    
    LLAMessageCenterRoomInfo *roomInfo1 = [LLAMessageCenterRoomInfo new];
    
    [roomArray addObject:roomInfo1];
    
    LLAMessageCenterRoomInfo *roomInfo2 = [LLAMessageCenterRoomInfo new];
    
    [roomArray addObject:roomInfo2];
    
    LLAMessageCenterRoomInfo *roomInfo3 = [LLAMessageCenterRoomInfo new];
    
    [roomArray addObject:roomInfo3];
    

    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@end
