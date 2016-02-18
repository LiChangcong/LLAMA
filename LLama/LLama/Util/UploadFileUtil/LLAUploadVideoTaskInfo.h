//
//  LLAUploadVideoTaskInfo.h
//  LLama
//
//  Created by Live on 16/2/18.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLAUploadVideoTaskInfo : NSObject

@property(nonatomic , copy) NSString *manaIdString;

@property(nonatomic , strong) UIImage *coverImage;

@property(nonatomic , copy) NSURL *videoPathURL;


@end
