//
//  LLAPickImageItemInfo.h
//  LLama
//
//  Created by tommin on 16/2/16.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"

@interface LLAPickImageItemInfo : MTLModel

@property(nonatomic, strong) UIImage *thumbImage;

@property(nonatomic, assign) BOOL IsSelected;

@end
