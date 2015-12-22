//
//  TMCommentViewController.m
//  LLama
//
//  Created by tommin on 15/12/8.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMCommentViewController.h"
#import "TMCommentCell.h"

@interface TMCommentViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

@end

@implementation TMCommentViewController

static NSString * const TMCommentCellId = @"comment";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 基本
    self.navigationItem.title = @"评论";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    // 设置tableView
    [self setupTable];
    
}

- (void)setupTable
{
    // 内边距
    self.tableView.contentInset = UIEdgeInsetsMake( 64 , 0, 59, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TMCommentCell class]) bundle:nil] forCellReuseIdentifier:TMCommentCellId];
    
    // 设置数据源和代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TMCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:TMCommentCellId];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118;
}

#pragma mark - 监听
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 设置约束值
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottomSpace.constant = [UIScreen mainScreen].bounds.size.height - keyboardF.origin.y;
    
    // 动画
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

// 拖拽的时候推出键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


@end
