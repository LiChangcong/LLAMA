//
//  LLAHomeTitleView.h
//  LLama
//
//  Created by Live on 16/1/12.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAHomeTitleView;

@protocol LLAHomeTitleViewDelegate <NSObject>

- (void) titleView:(LLAHomeTitleView *) titleView didSelectedIndex:(NSInteger) index;

@end

@interface LLAHomeTitleView : UIView

@property(nonatomic , weak) id<LLAHomeTitleViewDelegate> delegate;

- (instancetype) initWithTitles:(NSArray<NSString *> *) titles;

- (void) scrollWithProportion:(CGFloat) propotion;

@end
