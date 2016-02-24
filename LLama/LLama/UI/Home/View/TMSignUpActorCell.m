//
//  TMSignUpActorCell.m
//  LLama
//
//  Created by tommin on 15/12/21.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMSignUpActorCell.h"

@implementation TMSignUpActorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 创建方块
        [self createSquares];
        TMLog(@"%f",self.width);
    }
    return self;
}

- (void)createSquares
{

}
@end
