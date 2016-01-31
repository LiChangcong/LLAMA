//
//  LLAUserAccountDetailViewController.m
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLAUserAccountDetailViewController.h"
#import "LLAUserAccountWithdrawCashViewController.h"

//view
#import "LLATableView.h"
#import "LLALoadingView.h"
#import "LLAUserAccountBalanceCell.h"
#import "LLAUserAccountWithdrawCashCell.h"
#import "LLAUserAccountHistoryHeader.h"
#import "LLAUserAccountDetailInfoCell.h"
#import "LLAUserWithdrawCashSuccessView.h"

//category
#import "SVPullToRefresh.h"

//model
#import "LLAUser.h"
#import "LLAUserAccountDetailMainInfo.h"

//util
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"


static const NSInteger balanceSectionIndex = 0;
static const NSInteger withdrawCashSectionIndex = 1;

static const NSInteger detailInfoSection = 2;

@interface LLAUserAccountDetailViewController()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,LLAUserAccountWithdrawCashCellDelegate,LLAUserAccountWithdrawCashViewControllerDelegate>
{
    LLATableView *dataTableView;
    
    LLAUser *userInfo;
    NSInteger withdrawCash;
    LLAUserAccountDetailMainInfo *mainInfo;
    
    LLALoadingView *HUD;
    
    //
    UITextField *currentField;
    
    //
    BOOL shouldShowSuccess;
}

@end

@implementation LLAUserAccountDetailViewController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initVariables];
    [self initNavigationItems];
    [self initSubViews];
    
    [self loadData];
    [HUD show:YES];
    
    //
    UITapGestureRecognizer *tapToHide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHide:)];
    
    [self.view addGestureRecognizer:tapToHide];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //add observer
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void) viewDidAppear:(BOOL)animated  {
    [super viewDidAppear:animated];
    
    if (shouldShowSuccess) {
        LLAUserWithdrawCashSuccessView *success = [[LLAUserWithdrawCashSuccessView alloc] init];
        [success show];
        shouldShowSuccess = NO;
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - TapToHide

- (void) tapToHide:(UITapGestureRecognizer *) ges {
    [currentField resignFirstResponder];
}


#pragma mark - Init

- (void) initNavigationItems {
    self.navigationItem.title = @"帐户收支";
}

- (void) initVariables {
    
}

- (void) initSubViews {
    
    
    dataTableView = [[LLATableView alloc] init];
    dataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.showsVerticalScrollIndicator = NO;
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dataTableView.backgroundColor = [UIColor colorWithHex:0xeaeaea];
    [self.view addSubview:dataTableView];
    
    
    __weak typeof(self) weakSelf = self;
    
    [dataTableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadData];
    }];
    
    [dataTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreData];
    }];
    
    //constraints
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[dataTableView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataTableView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[dataTableView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataTableView)]];

    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
}

#pragma mark - LoadData

- (void) loadData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(0) forKey:@"pageNumber"];
    [params setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    
    [LLAHttpUtil httpPostWithUrl:@"/user/getTradeList" param:params responseBlock:^(id responseObject) {
        
        [HUD hide:YES];
        [dataTableView.pullToRefreshView stopAnimating];
        
        LLAUserAccountDetailMainInfo *tempInfo = [LLAUserAccountDetailMainInfo parseJsonWidthDic:responseObject];
        if (tempInfo) {
            mainInfo = tempInfo;
            userInfo = [LLAUser me];
        }
        
        [dataTableView reloadData];
        
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:YES];
        [dataTableView.pullToRefreshView stopAnimating];
        
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [HUD hide:YES];
        [dataTableView.pullToRefreshView stopAnimating];
        
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        
    }];
    
}

- (void) loadMoreData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(mainInfo.currentPage+1) forKey:@"pageNumber"];
    [params setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    
    [LLAHttpUtil httpPostWithUrl:@"/user/getTradeList" param:params responseBlock:^(id responseObject) {
        
        [dataTableView.infiniteScrollingView stopAnimating];
        
        LLAUserAccountDetailMainInfo *tempInfo = [LLAUserAccountDetailMainInfo parseJsonWidthDic:responseObject];
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

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView  {
    
    if (!mainInfo) {
        return 0;
    }
    
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == balanceSectionIndex) {
        return 1;
    }else if (section == withdrawCashSectionIndex) {
        return 1;
    }else if (section == detailInfoSection) {
        return mainInfo.dataList.count;
    }else {
        return 0;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == balanceSectionIndex) {
        
        static NSString *balanceIden = @"balanceIden";
        
        LLAUserAccountBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:balanceIden];
        
        if (!cell) {
            cell = [[LLAUserAccountBalanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:balanceIden];
        }
        [cell updateCellWithUserInfo:userInfo tableWith:tableView.frame.size.width];
        return cell;
        
        
    }else if (indexPath.section == withdrawCashSectionIndex) {
        
        static NSString *withdrawCashIden = @"withdrawCashIden";
        
        LLAUserAccountWithdrawCashCell *cell = [tableView dequeueReusableCellWithIdentifier:withdrawCashIden];
        if (!cell) {
            cell = [[LLAUserAccountWithdrawCashCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:withdrawCashIden];
            cell.cashTextField.delegate = self;
            cell.delegate = self;
        }
        
        [cell updateCellWithDrawCash:withdrawCash];
        return cell;
        
    }else if (indexPath.section == detailInfoSection) {
        
        static NSString *historyCellIden = @"historyCellIden";
        
        LLAUserAccountDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:historyCellIden];
        if (!cell) {
            cell = [[LLAUserAccountDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:historyCellIden];
        }
        
        [cell updateCellWithItemInfo:mainInfo.dataList[indexPath.row] tableWidth:tableView.frame.size.width];
        return cell;
        
    }else {
        return nil;
    }
    
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == detailInfoSection) {
        
        static NSString *headerIden = @"headerIden";
        
        LLAUserAccountHistoryHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIden];
        if (!header) {
            header = [[LLAUserAccountHistoryHeader alloc] initWithReuseIdentifier:headerIden];
        }
        return header;
    }else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == balanceSectionIndex) {
        return [LLAUserAccountBalanceCell calculateHeightWithUserInfo:userInfo tableWidth:tableView.frame.size.width];
    }else if(indexPath.section == withdrawCashSectionIndex) {
        return [LLAUserAccountWithdrawCashCell calculateCellHeight];
    }else if (indexPath.section == detailInfoSection) {
        return [LLAUserAccountDetailInfoCell calculateHeightWithItemInfo:mainInfo.dataList[indexPath.row] tableWidth:tableView.frame.size.width];
    }else{
        return 0;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == detailInfoSection) {
       return [LLAUserAccountHistoryHeader calculateHeaderHeight];
    }else {
        return 0;
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    currentField = textField;
}

-(void) textFieldValueChanged:(NSNotification *) info{
    
    UITextField *textField = [info object];
    if (textField == currentField) {
        NSInteger newInterger = [textField.text integerValue];
        
        withdrawCash = newInterger;
        //[dataTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:withdrawCashSectionIndex]] withRowAnimation:UITableViewRowAnimationNone];
        textField.text = [NSString stringWithFormat:@"%ld",(long)newInterger];
    }
}


#pragma mark - KeyBorad ObserServer

-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *tuserInfo = [notification userInfo];
    NSValue* aValue = [tuserInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [tuserInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat mainViewHeight = dataTableView.frame.size.height;
    CGFloat keyBoardHeight = keyboardRect.size.height;
    
    CGPoint pointInview = [currentField convertPoint:CGPointMake(0, currentField.bounds.size.height) toView:dataTableView];
    CGFloat offset = mainViewHeight - keyBoardHeight - (pointInview.y-dataTableView.contentOffset.y);
    
    
    if (offset <0)
    {
        [self viewDoOffset:-offset duration:animationDuration];
    }
    
    
}



-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *tuserInfo = [notification userInfo];
    //NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [tuserInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    if (dataTableView.contentSize.height <= dataTableView.frame.size.height){
        [self viewDoOffset:-dataTableView.contentOffset.y duration:animationDuration];
        return;
    }
    CGFloat offset = dataTableView.contentSize.height - dataTableView.contentOffset.y - dataTableView.frame.size.height;
    if (offset <0){
        [self viewDoOffset:offset duration:animationDuration];
    }
    
}

-(void)viewDoOffset:(CGFloat )offset duration:(NSTimeInterval ) duration{
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        //self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+offset, self.view.frame.size.width, self.view.frame.size.height);
        dataTableView.contentOffset = CGPointMake(dataTableView.contentOffset.x, dataTableView.contentOffset.y+offset);
        
    } completion:^(BOOL finished) {
    }];
    
}

#pragma mark - drawCash

- (void) withDrawcache {
    
    [currentField resignFirstResponder];
    
    if (withdrawCash < 100) {
        [LLAViewUtil showAlter:self.view withText:@"提现金额不能小于100"];
        return ;
    }
    
    LLAUserAccountWithdrawCashViewController *drawCache = [[LLAUserAccountWithdrawCashViewController alloc] initWithCashAmount:withdrawCash];
    drawCache.delegate = self;
    [self.navigationController pushViewController:drawCache animated:YES];
}

#pragma mark - DrawCacheSuccess

- (void) drawCacheSuccess {
    shouldShowSuccess = YES;
}


@end
