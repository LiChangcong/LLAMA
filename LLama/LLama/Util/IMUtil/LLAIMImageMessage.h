//
//  LLAIMImageMessage.h
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAIMMessage.h"

@interface LLAIMImageMessage : LLAIMMessage

/// Width of the image in pixels.
@property(nonatomic, assign)uint width;

/// Height of the image in pixels.
@property(nonatomic, assign)uint height;

/// File size in bytes.
@property(nonatomic, assign)uint64_t size;

/// Image format, png, jpg, etc. Simply get it from the file extension.
@property(nonatomic, copy)NSString *format;

@property(nonatomic, copy)NSURL *imageURL;


@end
