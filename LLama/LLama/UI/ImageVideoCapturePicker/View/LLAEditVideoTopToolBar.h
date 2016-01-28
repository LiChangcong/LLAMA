//
//  LLAEditVideoTopToolBar.h
//  LLama
//
//  Created by Live on 16/1/28.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLAEditVideoTopToolBarDelegate <NSObject>

- (void) backToPre;

- (void) editVideoDone;

@end

@interface LLAEditVideoTopToolBar : UIView

@property(nonatomic , weak) id<LLAEditVideoTopToolBarDelegate> delegate;

@end
