//
//  LLAFollowViewInChattingView.h
//  LLama
//
//  Created by Live on 16/3/3.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLAFollowViewInChattingViewDelegate <NSObject>

- (void) followCurrentUser;

@end

@interface LLAFollowViewInChattingView : UIView

@property(nonatomic , weak) id<LLAFollowViewInChattingViewDelegate> delegate;

+ (CGFloat) calculateHeight;

@end
