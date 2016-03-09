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

+ (BOOL) isNewDayWithTimeInterval:(long long)timeInterval {
    
    NSDate *oldDate = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    
    if (!oldDate){
        return YES;
    }
    
    NSDate *now = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:now];
    NSDate *today = [now dateByAddingTimeInterval: interval];
    
//    if ([oldDate compare:today] == NSOrderedDescending){
//        //老时间比新时间还大，时间不能用
//        return NO;
//    }
    /*******
     这个方法受时区的限制
     ************/
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    currentCalendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    NSDateComponents *nowComponents = [currentCalendar components:unit fromDate:today];
    NSDateComponents *oldComponents = [currentCalendar components:unit fromDate:oldDate];
    
    if (nowComponents.year == oldComponents.year && nowComponents.month == oldComponents.month && nowComponents.day == oldComponents.day){
        return NO;
    }else{
        return YES;
    }

}

@end
