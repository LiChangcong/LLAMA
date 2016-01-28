//
//  LLAAccountSecuritySectionTwo.h
//  LLama
//
//  Created by tommin on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLAAccountSecuritySectionTwo : NSObject

// 图标
@property (nonatomic, copy) NSString *icon;
// ison
@property (nonatomic, assign) NSString *on;

/** 通过一个字典来初始化模型对象 */
- (instancetype)initWithDict:(NSDictionary *)dict;
/** 通过一个字典来创建模型对象 */
+ (instancetype)accountSecuritySectionTwoWithDict:(NSDictionary *)dict;

@end
