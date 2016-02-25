//
//  LLASearchResultsViewController.m
//  LLama
//
//  Created by tommin on 16/2/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLASearchResultsViewController.h"

// controller
#import "LLAHotUsersViewController.h"

// cell
#import "LLAHotUsersSearchResultsCell.h"
#import "LLAHallVideoInfoCell.h"

#import "LLAHotUsersSearchResultsHeader.h"

//section index
static const NSInteger searchResultsUsersIndex = 0;
static const NSInteger searchResultsVideosIndex = 1;

// register
static NSString *const hotUsersSearchResultsCellIden = @"hotUsersSearchResultsCell";
static NSString *const hallVideoInfoCellIden = @"hallVideoInfoCell";


@interface LLASearchResultsViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITableView *dataTableView;
 
    UISearchBar *resultsSearchBar;
    
    UILabel *sectionTitleLabel;
    
    LLAHotUsersSearchResultsHeader *searchResultsHeader;
    
    UIButton *shadeButton;

}

@end

@implementation LLASearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置
    [self initVariables];
    [self initSubViews];
    [self initSubConstraints];

    self.navigationItem.leftBarButtonItem = nil;
}

- (void)initVariables
{

}

- (void)initSubViews
{
    // dataTableView
    dataTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.showsHorizontalScrollIndicator = NO;
    dataTableView.showsVerticalScrollIndicator = NO;
//    dataTableView.backgroundColor = [UIColor redColor];
//    dataTableView.style = UITableViewStyleGrouped;
    dataTableView.backgroundColor = [UIColor colorWithHex:0x1e1d28];
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:dataTableView];
    
    resultsSearchBar = [[UISearchBar alloc] init];
    resultsSearchBar.text = _searchResultText;
    resultsSearchBar.showsCancelButton = YES;
    resultsSearchBar.delegate = self;
    self.navigationItem.titleView = resultsSearchBar;
    
    // register
    [dataTableView registerClass:[LLAHotUsersSearchResultsCell class] forCellReuseIdentifier:hotUsersSearchResultsCellIden];
    [dataTableView registerClass:[LLAHallVideoInfoCell class] forCellReuseIdentifier:hallVideoInfoCellIden];

    // 使用button生成一个遮盖
    shadeButton = [[UIButton alloc] init];
    shadeButton.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    shadeButton.backgroundColor = [UIColor lightGrayColor];
    shadeButton.alpha = 0.1;
    [shadeButton addTarget:self action:@selector(shadeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    shadeButton.hidden = YES;
    [self.view addSubview:shadeButton];

}
- (void)initSubConstraints
{
    [dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)shadeButtonClicked
{
    [resultsSearchBar resignFirstResponder];
    shadeButton.hidden = YES;
}

#pragma mark - tableViewDataSoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searchResultsUsersIndex == section) {
        
        return 1;
    }else {
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == searchResultsUsersIndex) {
    
        LLAHotUsersSearchResultsCell *hotUsersSearchResultsCell = [dataTableView dequeueReusableCellWithIdentifier:hotUsersSearchResultsCellIden forIndexPath:indexPath];
        [hotUsersSearchResultsCell updateInfo];
        hotUsersSearchResultsCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        hotUsersSearchResultsCell.
        return hotUsersSearchResultsCell;
        
    }else {

//        LLAHotUsersSearchResultsCell *hotUsersSearchResultsCell = [dataTableView dequeueReusableCellWithIdentifier:hotUsersSearchResultsCellIden forIndexPath:indexPath];
//        return hotUsersSearchResultsCell;
        LLAHallVideoInfoCell *VideoInfoCell = [dataTableView dequeueReusableCellWithIdentifier:hallVideoInfoCellIden forIndexPath:indexPath];
        return VideoInfoCell;
    }
    
}

#pragma mark - tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == searchResultsUsersIndex) {
        
        return 60;
    }else{
        
        return [LLAHallVideoInfoCell calculateHeightWithVideoInfo:nil tableWidth:tableView.frame.size.width];
;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (searchResultsUsersIndex == section) {
        
        return 31;
    }else if(searchResultsVideosIndex == section){
        
        return 31;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    searchResultsHeader = [[LLAHotUsersSearchResultsHeader alloc] init];
    searchResultsHeader.frame = CGRectMake(0, 0, self.view.frame.size.width, 31);

    if (searchResultsUsersIndex == section) {
        
        [searchResultsHeader updateInfo:@"相关用户"];
        return searchResultsHeader;
        
    }else {
        [searchResultsHeader updateInfo:@"相关视频"];
        return searchResultsHeader;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (searchResultsUsersIndex ==  indexPath.section) {
        
        LLAHotUsersViewController *searchResultUsers = [[LLAHotUsersViewController alloc] init];
        searchResultUsers.userType = UserTypeIsResultsUsers;
        [self.navigationController pushViewController:searchResultUsers animated:YES];
        
    }else{
        
        NSLog(@"%d,%d",indexPath.section,indexPath.row);
    }
}
#pragma mark - searchBarDelegate


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"开始编辑");
    
    shadeButton.hidden = NO;

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"点击了搜索");
    // 给服务器发送请求
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
