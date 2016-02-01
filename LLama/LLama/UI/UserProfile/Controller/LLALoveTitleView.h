//
//  LLALoveTitleView.h
//  LLama
//
//  Created by tommin on 16/2/1.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLALoveTitleView;

@protocol LLALoveTitleViewDelegate <NSObject>

- (void) titleView:(LLALoveTitleView *) titleView didSelectedIndex:(NSInteger) index;

@end

@interface LLALoveTitleView : UIView

@property(nonatomic , weak) id<LLALoveTitleViewDelegate> delegate;

- (instancetype) initWithTitles:(NSArray<NSString *> *) titles;

- (void) scrollWithProportion:(CGFloat) propotion;

@end
