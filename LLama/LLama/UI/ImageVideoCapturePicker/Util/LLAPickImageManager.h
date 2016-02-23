//
//  LLAPickImageManager.h
//  LLama
//
//  Created by Live on 16/2/22.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLAPickImageManager : NSObject

+ (instancetype) shareManager;

//asset should be PHAsset or ALAsset

- (void) photoFromAsset:(id) asset completion:(void (^)(UIImage *resultImage,NSDictionary *info,BOOL isDegraded)) completion;

- (void) photoFromAsset:(id) asset picWidth:(CGFloat) width completion:(void (^)(UIImage *resultImage,NSDictionary *info,BOOL isDegraded)) completion;

@end
      