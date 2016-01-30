//
//  LLAAlbumPickerViewController.h
//  LLama
//
//  Created by tommin on 16/1/19.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLAAlbumPickerViewControllerDelegate <NSObject>

- (void) didFinishChooseImage:(UIImage *) image;

@end

@interface LLAAlbumPickerViewController : UIViewController

@property(nonatomic , weak) id<LLAAlbumPickerViewControllerDelegate> delegate;

@end
