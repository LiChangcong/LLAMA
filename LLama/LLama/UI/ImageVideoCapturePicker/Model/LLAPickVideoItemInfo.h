//
//  LLAPickVideoItemInfo.h
//  LLama
//
//  Created by Live on 16/1/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"

@interface LLAPickVideoItemInfo : MTLModel

@property(nonatomic , strong) UIImage *thumbImage;

@property(nonatomic , assign) CGFloat videoDuration;

@property(nonatomic , strong) NSURL *videoURL;

@property(nonatomic , strong) id asset;

@end
