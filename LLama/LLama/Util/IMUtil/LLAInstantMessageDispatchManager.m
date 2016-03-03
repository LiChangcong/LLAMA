//
//  LLAInstantMessageDispatchManager.m
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAInstantMessageDispatchManager.h"

#pragma mark - observerClass

@interface LLAIMObserverClass : NSObject

@property(nonatomic , weak) id<LLAIMEventObserver> observer;

@end

@implementation LLAIMObserverClass

@end

#pragma mark - manager

@interface LLAInstantMessageDispatchManager ()
{
    NSMutableDictionary *observerMapping;
}
@end

@implementation LLAInstantMessageDispatchManager

+ (instancetype) sharedInstance {
    static LLAInstantMessageDispatchManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    
    return manager;
}

-(instancetype) init{
    self = [super init];
    if (self){
        observerMapping = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark Dispatch Message
-(void) dispatchNewMessageArrived:(LLAIMMessage *)message conversation:(LLAIMConversation*)conversation{
    //--all message
    NSMutableArray *allObserver = [observerMapping objectForKey:INSTANT_MESSAGE_ALL_MESSAGE];
    if (allObserver){
        for (LLAIMObserverClass *observer in allObserver){
            [observer.observer newMessageArrived:message conversation:conversation];
        }
    }
    
    NSMutableArray *choosedObserver = [observerMapping objectForKey:conversation.conversationId];
    if (choosedObserver){
        for (LLAIMObserverClass *observer in choosedObserver){
            [observer.observer newMessageArrived:message conversation:conversation];
        }
    }
    
}
-(void) dispatchMessageDelivered:(LLAIMMessage *)message conversation:(LLAIMConversation *)conversation{
    //--all message
    NSMutableArray *allObserver = [observerMapping objectForKey:INSTANT_MESSAGE_ALL_MESSAGE];
    if (allObserver){
        for (LLAIMObserverClass *observer in allObserver){
            [observer.observer messageDelivered:message conversation:conversation];
        }
    }
    NSMutableArray *choosedObserver = [observerMapping objectForKey:conversation.conversationId];
    if (choosedObserver){
        for (LLAIMObserverClass *observer in choosedObserver){
            [observer.observer messageDelivered:message conversation:conversation];
        }
    }
}
-(void) dispatchImClientStatusChanged:(IMClientStatus )status{
    for (NSString *key in [observerMapping allKeys]){
        NSMutableArray *chain = [observerMapping objectForKey:key];
        for (LLAIMObserverClass *observer in chain){
            [observer.observer imClientStatusChanged:status];
        }
    }
}


#pragma mark - Add or Remove Observer

-(void) addEventObserver:(id<LLAIMEventObserver>)observer forConversation:(NSString *)conversationId{
    if (!observer || !conversationId){
        return;
    }
    NSMutableArray *observerChain = [observerMapping objectForKey:conversationId];
    
    LLAIMObserverClass *oberserClass = [[LLAIMObserverClass alloc] init];
    oberserClass.observer = observer;
    if (!observerChain){
        observerChain = [[NSMutableArray alloc] initWithObjects:oberserClass, nil];
    }else{
        //-----
        BOOL hasObserver = NO;
        for (LLAIMObserverClass *oldOber in observerChain){
            if (oldOber.observer == observer){
                hasObserver = YES;
                break;
            }
        }
        if (!hasObserver){
            [observerChain addObject:oberserClass];
        }
    }
    [observerMapping setObject:observerChain forKey:conversationId];
}
-(void) removeEventObserver:(id<LLAIMEventObserver>)observer forConversation:(NSString *)conversationId{
    if (!observer || !conversationId){
        return;
    }
    NSMutableArray *observerChain = [observerMapping objectForKey:conversationId];
    if (observerChain){
        for (LLAIMObserverClass *obs in observerChain){
            if (obs.observer == observer){
                [observerChain removeObject:obs];
                break;
            }
        };
        [observerMapping setObject:observerChain forKey:conversationId];
    }
}



@end
