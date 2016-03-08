//
//  Emoji.m
//  Emoji
//
//  Created by Aliksandr Andrashuk on 26.10.12.
//  Copyright (c) 2012 Aliksandr Andrashuk. All rights reserved.
//

#import "Emoji.h"
#import "EmojiEmoticons.h"
#import "EmojiMapSymbols.h"
#import "EmojiPictographs.h"
#import "EmojiTransport.h"

@implementation Emoji
+ (NSString *)emojiWithCode:(int)code {
    int sym = EMOJI_CODE_TO_SYMBOL(code);
    return [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
}
+ (NSArray *)allEmoji {
    NSMutableArray *array = [NSMutableArray new];
    [array addObjectsFromArray:[EmojiEmoticons allEmoticons]];
    //[array addObjectsFromArray:[EmojiMapSymbols allMapSymbols]];
    [array addObjectsFromArray:[EmojiPictographs allPictographs]];
    //[array addObjectsFromArray:[EmojiTransport allTransport]];
    
    return array;
}

+ (NSArray *) customAllEmoji {
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (int i=0x1F600; i<=0x1F637; i++) {
        
        if (i == 0x1F610 || i == 0x1F611 || i == 0x1F615 || i == 0x1F617 || i == 0x1F619 || i == 0x1F61B || i == 0x1F61F || i == 0x1F626 || i == 0x1F627 || i == 0x1F62C || i == 0x1F62F) {
            continue;
        }
        
        [array addObject:[Emoji emojiWithCode:i]];
        
    }
    
    
    return array;
}

@end
