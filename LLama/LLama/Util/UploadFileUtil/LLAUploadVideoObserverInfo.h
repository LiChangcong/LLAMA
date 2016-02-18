//
//  LLAUploadVideoObserverInfo.h
//  LLama
//
//  Created by Live on 16/2/18.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LLAUploadVideoObserverProtocol.h"

@interface LLAUploadVideoObserverInfo : NSObject

@property(nonatomic , weak) id<LLAUploadVideoObserverProtocol> observer;

@end
