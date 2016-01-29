//
//  LLAVideoPickerTopToolBar.h
//  LLama
//
//  Created by Live on 16/1/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLAVideoPickerTopToolBarDelegate <NSObject>

- (void) backToPre;

@end


@interface LLAVideoPickerTopToolBar : UIView

@property(nonatomic , weak) id<LLAVideoPickerTopToolBarDelegate> delegate;

@end
