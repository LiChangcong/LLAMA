//
//  LLAIMVoiceMessage.h
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAIMMessage.h"

@interface LLAIMVoiceMessage : LLAIMMessage

/// File size in bytes.
@property(nonatomic, assign)uint64_t size;

/// Audio's duration in seconds.
@property(nonatomic, assign)float duration;

/// Audio format, mp3, aac, etc. Simply get it by the file extension.
@property(nonatomic, strong)NSString *format;

@property(nonatomic, copy) NSString *audioURL;


@end
