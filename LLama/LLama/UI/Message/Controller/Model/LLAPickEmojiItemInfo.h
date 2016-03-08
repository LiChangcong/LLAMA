//
//  LLAPickEmojiItemInfo.h
//  LLama
//
//  Created by Live on 16/3/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"

typedef NS_ENUM(NSInteger,LLAPickEmojiItemType){
    
    LLAPickEmojiItemType_NormalEmoji = 0,
    LLAPickEmojiItemType_DeleteEmoji = 1,
};

@interface LLAPickEmojiItemInfo : MTLModel

@property(nonatomic , assign) LLAPickEmojiItemType type;

@property(nonatomic , copy) NSString *emojiString;

@end
