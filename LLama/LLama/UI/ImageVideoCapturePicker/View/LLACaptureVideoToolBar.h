//
//  LLACaptureVideoToolBar.h
//  LLama
//
//  Created by Live on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLACaptureVideoToolBarDelegate <NSObject>

- (void) closeCapture;

- (void) changeflashMode;

- (void) changeCamera;

@end

@interface LLACaptureVideoToolBar : UIView

@property(nonatomic , weak) id<LLACaptureVideoToolBarDelegate> delegate;

@end
