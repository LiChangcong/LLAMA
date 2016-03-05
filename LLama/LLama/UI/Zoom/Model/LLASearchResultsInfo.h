//
//  LLASearchResultsInfo.h
//  LLama
//
//  Created by tommin on 16/3/5.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"

#import "LLAUser.h"
#import "LLAHallVideoItemInfo.h"

@interface LLASearchResultsInfo : MTLModel<MTLJSONSerializing>

@property(nonatomic , strong) NSMutableArray<LLAUser *> *searchResultUsersDataList;
@property(nonatomic , strong) NSMutableArray<LLAHallVideoItemInfo *> *searchResultVideosdataList;


+ (LLASearchResultsInfo *) parseJsonWithDic:(NSDictionary *) data;

@end
