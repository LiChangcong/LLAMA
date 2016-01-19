//
//  LLAVideoInfo.h
//  LLama
//
//  Created by Live on 16/1/13.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"

@interface LLAVideoInfo : MTLModel

@property(nonatomic , assign) NSInteger videoId;

@property(nonatomic , copy) NSString *videoPlayURL;

@property(nonatomic , copy) NSString *videoCoverImageURL;

@end
