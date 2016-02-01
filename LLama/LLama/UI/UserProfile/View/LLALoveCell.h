//
//  LLALoveCell.h
//  LLama
//
//  Created by tommin on 16/2/1.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLAUserHeadView.h"
#import "LLAWhoLoveMeInfo.h"

@interface LLALoveCell : UITableViewCell


- (void) updateCellWithVideoInfo:(LLAUser *)userInfo tableWidth:(CGFloat)tableWidth;

@end
