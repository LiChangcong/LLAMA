//
//  LLAScriptHallMainInfo.h
//  LLama
//
//  Created by Live on 16/1/16.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"
#import "LLAScriptHallItemInfo.h"

@interface LLAScriptHallMainInfo : MTLModel<MTLJSONSerializing>

@property(nonatomic , assign) NSInteger currentPage;

@property(nonatomic , assign) NSInteger pageSize;

@property(nonatomic , strong) NSMutableArray<LLAScriptHallItemInfo *> *dataList;

@property(nonatomic , assign) BOOL isFirstPage;

@property(nonatomic , assign) BOOL isLastPage;

@property(nonatomic , assign) NSInteger totalPageNumbers;

@property(nonatomic , assign) NSInteger totalDataNumbers;

+ (LLAScriptHallMainInfo *) parseJsonWithDic:(NSDictionary *) data;

@end
