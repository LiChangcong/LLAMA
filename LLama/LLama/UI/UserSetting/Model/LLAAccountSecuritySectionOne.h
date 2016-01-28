//
//  LLAAccountSecuritySectionOne.h
//  LLama
//
//  Created by tommin on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLAAccountSecuritySectionOne : NSObject
/** 名字 */
@property (nonatomic, copy) NSString *title;

/** 通过一个字典来初始化模型对象 */
- (instancetype)initWithDict:(NSDictionary *)dict;
/** 通过一个字典来创建模型对象 */
+ (instancetype)accountSecuritySectionOneWithDict:(NSDictionary *)dict;

@end
