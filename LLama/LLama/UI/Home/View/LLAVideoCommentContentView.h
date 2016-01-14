//
//  LLAVideoCommentContentView.h
//  LLama
//
//  Created by Live on 16/1/14.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLAVideoCommentContentViewDelegate <NSObject>


@end

@interface LLAVideoCommentContentView : UIView

@property(nonatomic , weak) id<LLAVideoCommentContentViewDelegate> delegate;

@end
