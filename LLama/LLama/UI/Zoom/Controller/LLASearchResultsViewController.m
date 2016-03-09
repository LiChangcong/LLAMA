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

#import "LLALoadingView.h"
#import "LLAHttpUtil.h"
#import "LLAViewUtil.h"

#import "LLASearchResultsInfo.h"
#import "LLAUserProfileViewController.h"


//section index
static const NSInteger searchResultsUsersIndex = 0;
static const NSInteger searchResultsVideosIndex = 1;

// register
static NSString *const hotUsersSearchResultsCellIden = @"hotUsersSearchResultsCell";
static NSString *const hallVideoInfoCellIden = @"hallVideoInfoCell";


@interface LLASearchResultsViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,LLAHotUsersSearchResultsCellDelegate>
{
    UITableView *dataTableView;
 
    UISearchBar *resultsSearchBar;
    
    UILabel *sectionTitleLabel;
    
    LLAHotUsersSearchResultsHeader *searchResultsHeader;
    
    UIButton *shadeButton;

    
    LLALoadingView *HUD;
    
    LLASearchResultsInfo *mainInfo;

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
    
    // 显示菊花
    [HUD show:YES];

    // 刷新数据
    [self loadData];


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
    resultsSearchBar.tintColor = [UIColor colorWithHex:0xD3D3D3];
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
    
    // 菊花控件
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];

}

#pragma mark - Load Data
// 刷新数据
- (void) loadData {
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.searchResultText forKey:@"keyword"];
    
    // 发送请求
    [LLAHttpUtil httpPostWithUrl:@"/discover/search" param:params responseBlock:^(id responseObject) {
        
        [HUD hide:NO];

        LLASearchResultsInfo *tempInfo = [LLASearchResultsInfo parseJsonWithDic:responseObject];
        if (tempInfo) {
            
            
            mainInfo = tempInfo;
            NSLog(@"%@",mainInfo);
            // 刷新数据
            [dataTableView reloadData];
            
            if (mainInfo.searchResultUsersDataList.count == 0 && mainInfo.searchResultVideosdataList.count == 0) {
                

                UIImageView *blankImage = [[UIImageView alloc] init];
                blankImage.image = [UIImage imageNamed:@"blankShow"];
                [dataTableView addSubview:blankImage];
                
                
                UILabel *desLabel = [[UILabel alloc] init];
                desLabel.font = [UIFont systemFontOfSize:16];
                desLabel.text = @"没有相关数据噢";
                desLabel.textColor = [UIColor whiteColor];
                desLabel.textAlignment = NSTextAlignmentCenter;
                [dataTableView addSubview:desLabel];
                
                
                [blankImage mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.top.equalTo(dataTableView.mas_top);
//                    make.left.equalTo(dataTableView.mas_left);
//                    make.right.equalTo(dataTableView.mas_right);
//                    make.bottom.equalTo(dataTableView.mas_bottom);

                    make.centerX.equalTo(dataTableView.mas_centerX);
                    make.centerY.equalTo(dataTableView.mas_centerY);
                    make.width.height.equalTo(@200);
                }];
                
                [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(blankImage.mas_bottom);
                    make.left.equalTo(dataTableView.mas_left);
                    make.right.equalTo(dataTableView.mas_right);
//                    make.height.equalTo(@40);
                    make.centerX.equalTo(dataTableView.mas_centerX);
                }];
                
//                [bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.top.equalTo(dataTableView.mas_top);
//                    make.left.equalTo(dataTableView.mas_left);
//                    make.right.equalTo(dataTableView.mas_right);
//                    make.bottom.equalTo(dataTableView.mas_bottom);
//                }];

            }
            
        }
        [dataTableView reloadData];
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:NO];
        
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [HUD hide:NO];
        
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        
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
    if (mainInfo.searchResultUsersDataList.count == 0 && mainInfo.searchResultVideosdataList.count == 0) {
        
        return 0;
    }else {
//        if (mainInfo.searchResultUsersDataList.count == 0 || mainInfo.searchResultVideosdataList.count == 0) {
//            return 1;
//        }else{
        
            return 2;
//        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searchResultsUsersIndex == section) {
        
        return 1;
    }else {
        return mainInfo.searchResultVideosdataList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == searchResultsUsersIndex) {
    
        LLAHotUsersSearchResultsCell *hotUsersSearchResultsCell = [dataTableView dequeueReusableCellWithIdentifier:hotUsersSearchResultsCellIden forIndexPath:indexPath];

        [hotUsersSearchResultsCell updateCellWithInfo:mainInfo.searchResultUsersDataList tableWidth:tableView.bounds.size.width];
        hotUsersSearchResultsCell.delegate = self;
        hotUsersSearchResultsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return hotUsersSearchResultsCell;
        
    }else {

        LLAHallVideoInfoCell *VideoInfoCell = [dataTableView dequeueReusableCellWithIdentifier:hallVideoInfoCellIden forIndexPath:indexPath];

        [VideoInfoCell updateCellWithVideoInfo:mainInfo.searchResultVideosdataList[indexPath.row] tableWidth:tableView.bounds.size.width];
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
        searchResultUsers.searchResultUsersArray = mainInfo.searchResultUsersDataList;
        [self.navigationController pushViewController:searchResultUsers animated:YES];
        
    }else{
        
        NSLog(@"%d,%d",indexPath.section,indexPath.row);
    }
}
#pragma mark - searchBarDelegate


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
//    NSLog(@"开始编辑");
    
    shadeButton.hidden = NO;

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    [mainInfo.searchResultUsersDataList removeAllObjects];
//    [mainInfo.searchResultVideosdataList removeAllObjects];
    mainInfo = nil;
    
    [searchBar resignFirstResponder];
    shadeButton.hidden = YES;
    // 显示菊花
    [HUD show:YES];
    
    self.searchResultText = searchBar.text;
    
    [self loadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - LLAHotUsersSearchResultsCellDelegate

- (void)userHeadViewTapped:(LLAUser *)userInfo
{
    if (userInfo.userIdString.length > 0) {
        
        LLAUserProfileViewController *userProfile = [[LLAUserProfileViewController alloc] initWithUserIdString:userInfo.userIdString];
        [self.navigationController pushViewController:userProfile animated:YES];
    }

}

@end
