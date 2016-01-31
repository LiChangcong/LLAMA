//
//  LLAPickVideoNavigationController.h
//  LLama
//
//  Created by Live on 16/1/31.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLABaseNavigationController.h"

@class LLAPickVideoNavigationController;

@protocol LLAPickVideoNavigationControllerDelegate <NSObject>

- (void) videoPicker:(LLAPickVideoNavigationController *) videoPicker didFinishPickVideo:(NSURL *) videoURL thumbImage:(UIImage *) thumbImage;

- (void) videoPickerDidCancelPick:(LLAPickVideoNavigationController *) videoPicker ;

@end

@interface LLAPickVideoNavigationController : LLABaseNavigationController

@property(nonatomic , weak) id<LLAPickVideoNavigationControllerDelegate> videoPickerDelegate;

@end
