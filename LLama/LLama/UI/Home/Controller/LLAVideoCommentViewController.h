//
//  LLAVideoCommentViewController.h
//  LLama
//
//  Created by Live on 16/1/31.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLACommonViewController.h"

@class LLAHallVideoCommentItem;

@protocol LLAVideoCommentViewControllerDelegate <NSObject>

@optional

- (void) commentSuccess:(LLAHallVideoCommentItem *) commentContent videoId:(NSString *) videoIdString;

@end

@interface LLAVideoCommentViewController : LLACommonViewController

- (instancetype) initWithVideoIdString:(NSString *) videoId;

@property(nonatomic , weak) id<LLAVideoCommentViewControllerDelegate> delegate;

@end
