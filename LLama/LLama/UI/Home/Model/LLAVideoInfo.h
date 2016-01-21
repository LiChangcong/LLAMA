//
//  LLAVideoInfo.h
//  LLama
//
//  Created by Live on 16/1/13.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"

@interface LLAVideoInfo : MTLModel
/**
 *  视频ID
 */
@property(nonatomic , assign) NSInteger videoId;
/**
 *  视频URL
 */
@property(nonatomic , copy) NSString *videoPlayURL;
/**
 *  视频封面URL
 */
@property(nonatomic , copy) NSString *videoCoverImageURL;

@end
