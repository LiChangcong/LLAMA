//
//  LLAScriptDetailMainInfoCell.h
//  LLama
//
//  Created by Live on 16/1/17.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLAScriptDetailMainInfoCellDelegate <NSObject>

@end

@interface LLAScriptDetailMainInfoCell : UICollectionViewCell

@property(nonatomic , weak) id<LLAScriptDetailMainInfoCellDelegate> delegate;


@end
