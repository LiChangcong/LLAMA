//
//  LLAAccountSecuritySectionTwoCell.h
//  LLama
//
//  Created by tommin on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLAAccountSecuritySectionTwo.h"


@class LLAAccountSecuritySectionTwoCell;

@protocol LLAAccountSecuritySectionTwoCellDelegate <NSObject>
@optional
- (void)switchButtonOn:(LLAAccountSecuritySectionTwoCell *)accountSecuritySectionTwoCell indexPath:(NSIndexPath *)indexPath;
@end

@interface LLAAccountSecuritySectionTwoCell : UITableViewCell

//@property (nonatomic ,strong) LLAAccountSecuritySectionTwo *sectionTwo;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UISwitch *swit;
@property (nonatomic,strong)NSIndexPath * indexPath;

// 代理
@property (nonatomic,weak)id<LLAAccountSecuritySectionTwoCellDelegate>delegate;

@end
