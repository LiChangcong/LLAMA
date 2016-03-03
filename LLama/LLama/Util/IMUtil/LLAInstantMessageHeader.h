//
//  LLAInstantMessageHeader.h
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#ifndef LLAInstantMessageHeader_h
#define LLAInstantMessageHeader_h

typedef void (^LLAIMBooleanResultBlock)(BOOL succeeded, NSError *error);

typedef NS_ENUM(NSInteger,LLAConverstionType) {
    
    //单聊
    LLAConverstionType_Single = 0,
    //群聊
    LLAConverstionType_Group = 1,
    //系统消息
    LLAConverstionType_System = 2,
    
};

#endif /* LLAInstantMessageHeader_h */
