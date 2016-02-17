//
//  LLAImagePickerTopToolBar.h
//  LLama
//
//  Created by tommin on 16/2/16.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAImagePickerTopToolBar;
@protocol LLAImagePickerTopToolBarDelegate <NSObject>

- (void) backToPre;
- (void)LLAImagePickerTopToolBarDidClickDetermineButton:(LLAImagePickerTopToolBar *)imagePickerTopToolBar;
@end

@interface LLAImagePickerTopToolBar : UIView
// 确定按钮暴露在外面
@property(nonatomic, weak) UIButton *determineButtonFaceToPublich;

@property(nonatomic , weak) id<LLAImagePickerTopToolBarDelegate> delegate;

@end
