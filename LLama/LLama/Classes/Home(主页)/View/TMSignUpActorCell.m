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

#warning 这里打印的屏幕宽度始终是320，所以排布出来始终有问题，该怎么解决。
- (void)createSquares
{

}
@end
