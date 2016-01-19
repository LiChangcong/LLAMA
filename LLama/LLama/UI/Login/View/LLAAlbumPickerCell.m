//
//  LLAAlbumPickerCell.m
//  LLama
//
//  Created by tommin on 16/1/19.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAAlbumPickerCell.h"

@interface LLAAlbumPickerCell()
{
    UIImageView *_imageView;
    UIButton *_btnImg;
}

@end

@implementation LLAAlbumPickerCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // 显示的图片
        self.backgroundColor=[UIColor blackColor];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled=YES;
        _imageView = imageView;
        [self addSubview:_imageView];
        _imageView.clipsToBounds=YES;
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(5);
            make.right.equalTo(self.mas_right).with.offset(-5);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        // 每张图片右边的选中按钮
        _btnImg = [UIButton new];
        [_btnImg setImage:[UIImage imageNamed:@"chosepicdot"] forState:UIControlStateNormal];
        [_btnImg setImage:[UIImage imageNamed:@"chosepicdoth"] forState:UIControlStateSelected];
        [self addSubview:_btnImg];
        [_btnImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-5);
            make.width.equalTo(@32);
            make.height.equalTo(@32);
        }];
        [_btnImg addTarget:self action:@selector(selectBtn) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)selectBtn
{
    _btnImg.selected = !_btnImg.selected;
    
    if ([self.delegate respondsToSelector:@selector(selectImage:indexPath:forSelected:)]) {
        [self.delegate selectImage:self indexPath:_indexPath forSelected:_btnImg.selected];
    }
}

- (void)setBtnImgHidden:(BOOL)hidden{
    _btnImg.hidden = hidden;
    
}

- (void)setSelected:(BOOL)selected{
    _btnImg.selected = selected;
}

@end
