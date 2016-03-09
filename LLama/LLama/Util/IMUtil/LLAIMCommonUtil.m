//
//  LLAIMCommonUtil.m
//  LLama
//
//  Created by Live on 16/3/4.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAIMCommonUtil.h"

#import "LLAUser.h"
#import "LLAIMConversation.h"
#import "LLAChatMessageViewController.h"

@implementation LLAIMCommonUtil

+ (LLAUser *) findTheOtherWithConversation:(LLAIMConversation *)conversation mainUser:(LLAUser *)mainUser {
    
    for (LLAUser *user in conversation.members) {
        if (![user isEqual:mainUser]) {
            return user;
        }
    }
    
    return nil;
}

+ (void) pushToChatViewController:(UINavigationController *)navigationController conversation:(LLAIMConversation *)conv {
    
    for (UIViewController *controller in navigationController.viewControllers) {
        if ([controller isKindOfClass:[LLAChatMessageViewController class]]){
            LLAChatMessageViewController *chatViewController = (LLAChatMessageViewController *) controller;
            
            [chatViewController resetChatControllerWihtConversation:conv];
            [navigationController popToViewController:chatViewController animated:YES];
            return;
        }
    }
    
    LLAChatMessageViewController *chatViewController = [[LLAChatMessageViewController alloc] initWithConversation:conv];
    chatViewController.hidesBottomBarWhenPushed = YES;
    
    [navigationController pushViewController:chatViewController animated:YES];
    
}

@end
