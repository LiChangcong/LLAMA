//
//  LLAHallMainInfo.h
//  LLama
//
//  Created by Live on 16/1/13.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"
#import "LLAHallVideoItemInfo.h"

@interface LLAHallMainInfo : MTLModel<MTLJSONSerializing>
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
@property(nonatomic , strong) NSMutableArray<LLAHallVideoItemInfo *> *dataList;
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

+ (LLAHallMainInfo *) parseJsonWithDic:(NSDictionary *) data;

@end
