//
//  NSString+TMExtension.m
//  LLama
//
//  Created by tommin on 15/12/29.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "NSString+TMExtension.h"

@implementation NSString (TMExtension)

- (unsigned long long)fileSize
{
    // 获得文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 是否为文件夹
    BOOL isDirectory = NO;
    
    // 先判断路径的存在性
    BOOL exists = [mgr fileExistsAtPath:self isDirectory:&isDirectory];
    // 路径不存在
    if (!exists) return 0;
    
    // 如果是文件夹
    if (isDirectory) {
        // 文件总大小
        unsigned long long fileSize = 0;
        
        // 遍历所有文件
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:self];
        for (NSString *subpath in enumerator) {
            // 完整的子路径
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            fileSize += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
        
        return fileSize;
    }
    
    // 如果是文件
    return [mgr attributesOfItemAtPath:self error:nil].fileSize;
}


@end
