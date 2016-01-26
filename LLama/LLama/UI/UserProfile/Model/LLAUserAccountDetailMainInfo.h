//
//  LLAUserAccounyDetailMainInfo.h
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"
#import "LLAUserAccountDetailItemInfo.h"

@interface LLAUserAccountDetailMainInfo : MTLModel<MTLJSONSerializing>

/**
 *  当前页
 */
@property(nonatomic , assign) NSInteger currentPage;
/**
 *  每页尺寸
 */
@property(nonatomic , assign) NSInteger pageSize;
/**
 *  剧本项
 */
@property(nonatomic , strong) NSMutableArray<LLAUserAccountDetailItemInfo *> *dataList;
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
 *  总数据数
 */
@property(nonatomic , assign) NSInteger totalDataNumbers;

+ (LLAUserAccountDetailMainInfo *) parseJsonWidthDic:(NSDictionary *) data;

@end
