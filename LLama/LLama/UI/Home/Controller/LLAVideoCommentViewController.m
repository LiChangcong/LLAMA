//
//  LLAVideoCommentViewController.m
//  LLama
//
//  Created by Live on 16/1/31.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAVideoCommentViewController.h"
#import "LLAVideoCommentInputViewController.h"
#import "LLAUserProfileViewController.h"

//view
#import "LLATableView.h"
#import "LLALoadingView.h"
#import "LLAVideoCommentCell.h"

//category
#import "SVPullToRefresh.h"
//model
#import "LLAVideoCommentMainInfo.h"

//util
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"


@interface LLAVideoCommentViewController()<UITableViewDataSource,UITableViewDelegate,LLAVideoCommentInputViewControllerDelegate,LLAVideoCommentCellDelegate>
{
    
    NSString *videoIdString;
    
    LLATableView *dataTableView;
    
    LLALoadingView *HUD;
    
    LLAVideoCommentInputViewController *inputController;
    
    LLAVideoCommentMainInfo *mainInfo;
    
    //
    NSLayoutConstraint *inputViewHeightConstraints;

}

@end

@implementation LLAVideoCommentViewController

#pragma mark - Life Cycle

- (instancetype) initWithVideoIdString:(NSString *)videoId {
    self = [super init];
    if (self) {
        videoIdString = [videoId copy];
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    [self initNavigationItems];
    
    // 设置内部子控件
    [self initSubViews];
    
    // 显示菊花
    [HUD show:YES];
    
    // 刷新数据
    [self loadData];
}

#pragma mark - Init

- (void) initNavigationItems {
    self.title = @"评论";
}

- (void) initSubViews {
    // tableView
    dataTableView = [[LLATableView alloc] init];
    dataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.showsVerticalScrollIndicator = NO;
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:dataTableView];
    
    
    __weak typeof(self) weakSelf = self;
    
    [dataTableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadData];
    }];
    
    [dataTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreData];
    }];
    
    //
    inputController = [[LLAVideoCommentInputViewController alloc] init];
    inputController.delegate = self;
    
    [self addChildViewController:inputController];
    [inputController didMoveToParentViewController:self];
    //
    
    UIView *inputView = inputController.view;
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:inputView];
    
    //constraints
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[dataTableView]-(0)-[inputView(inputHeight)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"inputHeight":@(llaVideoCommentIputViewHeight)}
      views:NSDictionaryOfVariableBindings(dataTableView,inputView)]];
    
    //horizonal
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[dataTableView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataTableView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[inputView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(inputView)]];
    
    [self.view addConstraints:constrArray];
    
    for (NSLayoutConstraint *constr in constrArray) {
        if (constr.firstAttribute == NSLayoutAttributeHeight && constr.firstItem == inputController.view) {
            
            inputViewHeightConstraints = constr;
            break;
        }
    }
    
    
}

#pragma mark - Load Data
// 加载数据
- (void) loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@(0) forKey:@"pageNumber"];
    [params setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    [params setValue:videoIdString forKey:@"playId"];
    
    [LLAHttpUtil httpPostWithUrl:@"/play/getComments" param:params responseBlock:^(id responseObject) {
        
        [HUD hide:NO];
        [dataTableView.pullToRefreshView stopAnimating];
        
        LLAVideoCommentMainInfo *tempInfo = [LLAVideoCommentMainInfo parseJsonWithDic:responseObject];
        if (tempInfo){
            mainInfo = tempInfo;
            [dataTableView reloadData];
        }
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:NO];
        [dataTableView.pullToRefreshView stopAnimating];
        
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [HUD hide:NO];
        [dataTableView.pullToRefreshView stopAnimating];
        
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        
    }];
}

- (void) loadMoreData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@(mainInfo.currentPage+1) forKey:@"pageNumber"];
    [params setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    [params setValue:videoIdString forKey:@"playId"];
    
    [LLAHttpUtil httpPostWithUrl:@"/play/getComments" param:params responseBlock:^(id responseObject) {
        
        [dataTableView.infiniteScrollingView stopAnimating];
        
        LLAVideoCommentMainInfo *tempInfo = [LLAVideoCommentMainInfo parseJsonWithDic:responseObject];
        if (tempInfo.dataList.count > 0){
            
            [mainInfo.dataList addObjectsFromArray:tempInfo.dataList];
            
            mainInfo.currentPage = tempInfo.currentPage;
            mainInfo.pageSize = tempInfo.pageSize;
            mainInfo.isFirstPage = tempInfo.isFirstPage;
            mainInfo.isLastPage = tempInfo.isLastPage;
            mainInfo.totalPageNumbers = tempInfo.totalPageNumbers;
            mainInfo.totalDataNumbers = tempInfo.totalDataNumbers;
            
            [dataTableView reloadData];
        }else {
            [LLAViewUtil showAlter:self.view withText:LLA_LOAD_DATA_NO_MORE_TIPS];
        }
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [dataTableView.infiniteScrollingView stopAnimating];
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [dataTableView.infiniteScrollingView stopAnimating];
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mainInfo.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIden = @"cell";
    
    LLAVideoCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (!commentCell) {
        commentCell = [[LLAVideoCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
        commentCell.delegate = self;
    }
    
    [commentCell updateCellWithCommentItem:mainInfo.dataList[indexPath.row] maxWidth:tableView.bounds.size.width];
    
    return commentCell;

}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LLAVideoCommentCell calculateHeightWithCommentItem:mainInfo.dataList[indexPath.row] maxWidth:tableView.bounds.size.width];
}

#pragma mark - LLAVideoCommentInputViewControllerDelegate

- (void) sendMessageWithContent:(NSString *)content {
    //send message
}

- (void) inputViewWillChangeHeight:(CGFloat)newHeight duration:(CGFloat)duration animationCurve:(UIViewAnimationCurve)animationCurve {
    
    //
    CGFloat changeHeight = newHeight - inputController.view.bounds.size.height;
    
    BOOL shouldOffset = ceilf(dataTableView.contentOffset.y+dataTableView.frame.size.height) == ceilf(dataTableView.contentSize.height);
    
    [UIView animateWithDuration:duration animations:^{
        inputViewHeightConstraints.constant = newHeight;
        [self.view layoutIfNeeded];
    }];
    
    //---计算tableView应该滚动的高度,以viewoffset来计算相对变化的高度
    if (!(shouldOffset && changeHeight<0)){
        CGFloat maxOffset = MAX(dataTableView.contentSize.height - dataTableView.frame.size.height,0);
        CGFloat changeOffset = dataTableView.contentOffset.y+changeHeight;
        
        CGFloat actualOffset = MIN(changeOffset,maxOffset);
        actualOffset = MAX(actualOffset,0);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:animationCurve];
        [UIView setAnimationDuration:duration];
        dataTableView.contentOffset = CGPointMake(dataTableView.contentOffset.x, actualOffset);
        [self.view layoutIfNeeded];
        [UIView commitAnimations];
    }
    
}

#pragma mark - LLAVideoCommentCellDelegate

- (void) toggleUser:(LLAUser *)userInfo commentInfo:(LLAHallVideoCommentItem *)commentInfo {
    if (userInfo.userIdString.length > 0) {
        //user profile
        LLAUserProfileViewController *userProfile = [[LLAUserProfileViewController alloc] initWithUserIdString:userInfo.userIdString];
        [self.navigationController pushViewController:userProfile animated:YES];
    }
}


@end
