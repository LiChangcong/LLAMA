//
//  LLAHotVideosCell.h
//  LLama
//
//  Created by tommin on 16/2/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLAUser.h"

@interface LLAHotVideosCell : UICollectionViewCell

+ (CGFloat) calculateHeightWitthUserInfo:(LLAUser *)userInfo maxWidth:(CGFloat)maxWidth;

@end
