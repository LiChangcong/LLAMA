//
//  LLAVideoCommentContentView.m
//  LLama
//
//  Created by Live on 16/1/14.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAVideoCommentContentView.h"
#import "LLAVideoCommentView.h"

#import "LLAHallVideoCommentItem.h"

static const CGFloat commentsVerSpace = 9;
static const CGFloat commentToLeft = 0;
static const CGFloat commentToRight = 0;

@interface LLAVideoCommentContentView()<LLAVideoCommentViewDelegate>
{

}

@end

@implementation LLAVideoCommentContentView

@synthesize delegate;

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initVariables];
        [self initSubView];
        
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

- (void) initVariables {
    
}

- (void) initSubView {
    
}

#pragma mark - Update

- (void) updateCommentContentViewWithInfo:(NSArray<LLAHallVideoCommentItem *> *)comments maxWidth:(CGFloat)maxWidth {
    
    //remove
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat offsetY = 0;
    CGFloat width = MAX(maxWidth - commentToLeft - commentToRight,0);
    
    for (LLAHallVideoCommentItem *item in comments) {
        
        CGFloat commentHeight = [LLAVideoCommentView calculateHeightWihtInfo:item maxWidth:width];
        
        LLAVideoCommentView *commentView = [[LLAVideoCommentView alloc] initWithFrame:CGRectMake(commentToLeft, offsetY,width, commentHeight)];
        commentView.delegate = self;
        [commentView updateCommentWithInfo:item maxWidth:width];
        commentView.backgroundColor = self.backgroundColor;
        
        [self addSubview:commentView];
        
        offsetY += commentHeight;
        offsetY += commentsVerSpace;
    }
    
}

#pragma mark - LLAVideoCommentViewDelegate

- (void) commentView:(LLAVideoCommentView *)commentView userNameClicked:(LLAUser *)userInfo {
    if (delegate && [delegate respondsToSelector:@selector(commentViewUserNameClickedWithUserInfo:commentInfo:)]) {
        [delegate commentViewUserNameClickedWithUserInfo:userInfo commentInfo:commentView.currentCommentInfo];
    }
}

- (void) singleTappedWithCommentView:(LLAVideoCommentView *)commentView {
    if (delegate && [delegate respondsToSelector:@selector(commentViewClickedWithCommentInfo:)]) {
        [delegate commentViewClickedWithCommentInfo:commentView.currentCommentInfo];
    }
}

#pragma mark - CalculateHeight

+ (CGFloat) calculateHeightWithCommentsInfo:(NSArray<LLAHallVideoCommentItem *> *)comments maxWidth:(CGFloat)maxWidth {
    
    CGFloat width = MAX(maxWidth - commentToLeft - commentToRight,0);
    
    CGFloat totalHeight = 0;
    
    for (LLAHallVideoCommentItem *item in comments) {
        totalHeight += [LLAVideoCommentView calculateHeightWihtInfo:item maxWidth:width];
        totalHeight += commentsVerSpace;
    }
    
    //totalHeight = MAX(0,totalHeight-commentsVerSpace);
    
    return totalHeight;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
