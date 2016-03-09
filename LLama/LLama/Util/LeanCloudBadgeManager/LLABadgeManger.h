//
//  LLABadgeManger.h
//  LLama
//
//  Created by Live on 16/3/9.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLABadgeManger : NSObject

+ (instancetype) shareManger;

- (void) syncLeanBadge;

- (void) clearLeanBadge;

@end
