//
//  TMPurseHeadCell.h
//  LLama
//
//  Created by tommin on 15/12/21.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMPurseHeadCell;

@protocol TMPurseHeadCellDelegate <NSObject>
@optional

- (void)purseHeadCellDidClickPurseButton:(TMPurseHeadCell *)purseHeadCell;

@end


@interface TMPurseHeadCell : UITableViewCell
/** 代理对象 */
@property (nonatomic, weak) id<TMPurseHeadCellDelegate> delegate;

@end
