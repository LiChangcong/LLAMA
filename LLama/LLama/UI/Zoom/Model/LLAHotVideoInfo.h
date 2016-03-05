//
//  LLAHotVideoInfo.h
//  LLama
//
//  Created by tommin on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"

@interface LLAHotVideoInfo : MTLModel<MTLJSONSerializing>

//@property(nonatomic, copy) NSString *videoCoverImageURL;
////@property(nonatomic , copy) NSString *videoPlayURL;
////@property(nonatomic , assign) NSInteger videoId;
//
//@property(nonatomic, assign) NSInteger prizeNum;
//@property(nonatomic, assign) NSInteger likeNum;

@property(nonatomic, assign) int fee;

@property(nonatomic, copy) NSString  *videoid;

@property(nonatomic, copy) NSString *videoThumb;

@property(nonatomic, assign) int zan;

+ (LLAHotVideoInfo *) parseJsonWidthDic:(NSDictionary *)data;

@end
