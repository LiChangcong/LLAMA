//
//  LLACameraCell.h
//  LLama
//
//  Created by tommin on 16/2/17.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLACameraCell;

@protocol LLACameraCellDelegate<NSObject>

- (void)LLACameraCellDidClickCameraCell:(LLACameraCell *)cameraCell;

@end

@interface LLACameraCell : UICollectionViewCell

@property (nonatomic ,weak) id<LLACameraCellDelegate> delegate;

@end
