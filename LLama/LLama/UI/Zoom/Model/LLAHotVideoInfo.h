//
//  LLAHotVideoInfo.h
//  LLama
//
//  Created by tommin on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"

@interface LLAHotVideoInfo : MTLModel

@property(nonatomic, copy) NSString *videoCoverImageURL;
//@property(nonatomic , copy) NSString *videoPlayURL;
//@property(nonatomic , assign) NSInteger videoId;

@property(nonatomic, assign) NSInteger prizeNum;
@property(nonatomic, assign) NSInteger likeNum;

@end
