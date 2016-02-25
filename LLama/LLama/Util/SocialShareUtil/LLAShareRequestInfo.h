//
//  LLAShareRequestInfo.h
//  LLama
//
//  Created by Live on 16/2/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"

@interface LLAShareRequestInfo : MTLModel

@property(nonatomic , copy) NSString *urlString;

@property(nonatomic , strong) NSDictionary *paramsDic;

@end
