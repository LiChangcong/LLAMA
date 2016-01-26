//
//  MMDateView.m
//  MMPopupView
//
//  Created by Ralph Li on 9/7/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMDateView.h"
#import "MMPopupDefine.h"
#import "MMPopupCategory.h"
#import "MMSheetView.h"
#import "MMPopupItem.h"
#import "Masonry.h"

@interface MMDateView()

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnConfirm;

@property (nonatomic, copy) MMPopupDateHandler dateHandler;

@end

@implementation MMDateView


- (instancetype)initWithDefaultDate:(NSDate *)date
                        minimumDate:(NSDate *)minDate
                        maximumDate:(NSDate *)maxDate
                            handler:(MMPopupDateHandler)dateHandler {
    self = [super init];
    
    if (self) {
        MMSheetViewConfig *config = [MMSheetViewConfig globalConfig];
        
        self.type = MMPopupTypeSheet;
        self.dateHandler = dateHandler;
        self.backgroundColor = config.backgroundColor;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(216+50);
        }];
        
        self.btnCancel = [UIButton mm_buttonWithTarget:self action:@selector(actionHide:)];
        [self addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.left.top.equalTo(self);
        }];
        [self.btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [self.btnCancel setTitleColor:config.itemNormalColor forState:UIControlStateNormal];
        [self.btnCancel setTitleColor:config.itemHighlightColor forState:UIControlStateHighlighted];
        self.btnCancel.tag = 0;
        
        self.btnConfirm = [UIButton mm_buttonWithTarget:self action:@selector(actionHide:)];
        [self addSubview:self.btnConfirm];
        [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.right.top.equalTo(self);
        }];
        [self.btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
        [self.btnConfirm setTitleColor:config.itemNormalColor forState:UIControlStateNormal];
        [self.btnConfirm setTitleColor:config.itemHighlightColor forState:UIControlStateHighlighted];
        self.btnConfirm.tag = 1;
        
        self.datePicker = [UIDatePicker new];
        [self.datePicker setDatePickerMode:UIDatePickerModeDate];
        [self.datePicker setMinimumDate:minDate];
        if (date) { // setDate为空时，会crash
            [self.datePicker setDate:date];
        }
        [self.datePicker setMaximumDate:maxDate];
        [self addSubview:self.datePicker];
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(50, 0, 0, 0));
        }];
    }
    return self;
}

- (void)actionHide:(UIButton *)btn
{
    [self hide];
    
    if (self.dateHandler && btn.tag>0) {
        self.dateHandler(self.datePicker.date);
    }
}

@end
