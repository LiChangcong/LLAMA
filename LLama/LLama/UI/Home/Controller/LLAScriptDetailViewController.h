//
//  LLAScriptDetailViewController.h
//  LLama
//
//  Created by Live on 16/1/17.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLACommonViewController.h"

@interface LLAScriptDetailViewController : LLACommonViewController
/**
 *  剧本详情展示页
 *
 *  @param idString 对应剧本的ID
 *
 *  @return 初始化的剧本详情页
 */
- (instancetype) initWithScriptIdString:(NSString *) idString;

@end
