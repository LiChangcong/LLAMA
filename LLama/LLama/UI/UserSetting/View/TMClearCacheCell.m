//
//  TMClearCacheCell.m
//  LLama
//
//  Created by tommin on 15/12/29.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMClearCacheCell.h"
#import <SVProgressHUD.h>

/** 缓存路径 */
#define TMCacheFilePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"default"]

@implementation TMClearCacheCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        
        self.detailTextLabel.textColor = TMYellowColor;

        // 初始化文字
        self.textLabel.text = @"清除缓存";
        
        // 禁止点击
        self.userInteractionEnabled = NO;
        
        // 右边显示一个圈圈
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        self.accessoryView = loadingView;
        
        // 在子线程计算缓存大小
        [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
            [NSThread sleepForTimeInterval:5.0];
            // 单位
            double unit = 1000.0;
            // 缓存大小
            unsigned long long fileSize = TMCacheFilePath.fileSize;
            // 标签文字
            NSString *fileSizeText = nil;
            if (fileSize >= pow(unit, 3)) { // fileSize >= 1GB
                fileSizeText = [NSString stringWithFormat:@"%.2fGB", fileSize / pow(unit, 3)];
            } else if (fileSize >= pow(unit, 2)) { // fileSize >= 1MB
                fileSizeText = [NSString stringWithFormat:@"%.2fMB", fileSize / pow(unit, 2)];
            } else if (fileSize >= unit) { // fileSize >= 1KB
                fileSizeText = [NSString stringWithFormat:@"%.2fKB", fileSize / unit];
            } else { // fileSize < 1KB
                fileSizeText = [NSString stringWithFormat:@"%zdB", fileSize];
            }
            
            NSString *text = [NSString stringWithFormat:@"%@", fileSizeText];
            
            // 回到主线程
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                // 去掉圈圈
                self.accessoryView = nil;
//                self.accessoryType = UITableViewCellStyleValue2;
                
                // 设置标签文字
                
                self.detailTextLabel.text = text;
                //                self.detailTextLabel.textColor = TMYellowColor;

                
                // 恢复点击
                self.userInteractionEnabled = YES;
            }];
        }];
        
        // 给cell添加一个tap手势监听器
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearCache)]];
    }
    return self;
}

/**
 *  清除缓存
 */
- (void)clearCache
{
    
    // 弹框
    [SVProgressHUD showWithStatus:@"正在清除缓存..." maskType:SVProgressHUDMaskTypeBlack];

    // 持续一秒显正在清除缓存...
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 在子线程进行删除操作
        [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
            // 删除缓存文件夹
            [[NSFileManager defaultManager] removeItemAtPath:TMCacheFilePath error:nil];
            
            // 在主线程执行其他操作
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // 隐藏弹框
                [SVProgressHUD dismiss];
                
                // 修改文字
                self.detailTextLabel.text = @"0B";
            }];
        }];
    });

}

/**
 * 1.当控件显示到屏幕上时会调用一次layoutSubviews
 * 2.当控件的尺寸发生改变的时候会调用一次layoutSubviews
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 当cell离开屏幕时, UIActivityIndicatorView的动画就会被自动停止
    
    // 当cell重新显示到屏幕上时, 应该重新开始UIActivityIndicatorView的动画
    UIActivityIndicatorView *loadingView = (UIActivityIndicatorView *)self.accessoryView;
    [loadingView startAnimating];
}



@end
