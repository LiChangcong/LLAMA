//
//  LLASocialShareView.h
//  LLama
//
//  Created by Live on 16/2/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MMPopupView.h"

@class LLASocialSharePlatformItem;

@interface LLASocialShareView : MMPopupView

@property(nonatomic , copy) void (^completeHandler)(NSInteger integer);

@property(nonatomic , copy) void (^reportHandler)(void);

- (instancetype) initWithPlatforms:(NSArray<LLASocialSharePlatformItem *> *) platformsArray title:(NSString *) title hasReport:(BOOL) report;

@end