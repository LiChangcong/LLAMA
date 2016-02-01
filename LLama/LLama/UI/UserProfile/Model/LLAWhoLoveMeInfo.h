//
//  LLAWhoLoveMeInfo.h
//  LLama
//
//  Created by tommin on 16/2/1.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
#import "LLAUser.h"

@interface LLAWhoLoveMeInfo : MTLModel<MTLJSONSerializing>

/**
 *  当前页
 */
@property(nonatomic , assign) NSInteger currentPage;
/**
 *  每页尺寸
 */
@property(nonatomic , assign) NSInteger pageSize;
/**
 *  大厅视频项列表
 */
@property(nonatomic , strong) NSMutableArray<LLAUser *> *dataList;
/**
 *  是否是第一页
 */
@property(nonatomic , assign) BOOL isFirstPage;
/**
 *  是否是最后一页
 */
@property(nonatomic , assign) BOOL isLastPage;
/**
 *  总页数
 */
@property(nonatomic , assign) NSInteger totalPageNumbers;
/**
 *  总数据量
 */
@property(nonatomic , assign) NSInteger totalDataNumbers;

+ (LLAWhoLoveMeInfo *) parseJsonWithDic:(NSDictionary *) data;


@end
