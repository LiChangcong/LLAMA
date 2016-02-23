//
//  LLAZoomViewController.m
//  LLama
//
//  Created by tommin on 16/2/22.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAZoomViewController.h"

// view
#import "LLASearchBar.h"
#import "LLAZoomCollectionView.h"

// cell
#import "LLAHotUsersCell.h"
#import "LLAHotVideosCell.h"

// controller
#import "TMZoomController.h"

static const CGFloat zoomCellsHorSpace = 6;
static const CGFloat zoomCellsVerSpace = 6;

//section index
static const NSInteger hotUsersIndex = 0;
static const NSInteger hotVideosIndex = 1;

// cell registerID
static NSString *const hotUsersCellIden = @"hotUsersCellIden";
static NSString *const hotVideosCellIden = @"hotVideosCellIden";

@interface LLAZoomViewController () <UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    LLASearchBar *headSearchBar;
    
    LLAZoomCollectionView *dataCollectionView;

    UISearchDisplayController *searchController;
}

@end

@implementation LLAZoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHex:0x1e1d28];
    
    // 设置变量
    [self initVariables];
    // 设置子控件
    [self initSubViews];
    // 设置约束
    [self initSubConstraints];

}

// 设置变量
- (void)initVariables
{

    
}

// 设置子控件
- (void)initSubViews
{
    // headSearchBar
    headSearchBar = [[LLASearchBar alloc] init];
    headSearchBar.placeholder = @"搜索";
    headSearchBar.delegate = self;
    self.navigationItem.titleView = headSearchBar;

    
    // dataCollectionView布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = zoomCellsHorSpace;
    flowLayout.minimumLineSpacing = zoomCellsVerSpace;
    
    // dataCollectionView
    dataCollectionView = [[LLAZoomCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    dataCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
//    dataCollectionView.dataSource = self;
//    dataCollectionView.delegate = self;
    dataCollectionView.bounces = YES;
    dataCollectionView.backgroundColor = [UIColor colorWithHex:0x1e1d28];
    [self.view addSubview:dataCollectionView];
}

// 设置约束
- (void)initSubConstraints
{
    [dataCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}


#pragma mark - UISearchBarDelegate



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == hotUsersIndex) {
        
        return 1;
        
    }else if(section == hotVideosIndex){
    
        return 5;
        
    }else {
        
        return 0;
    }
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 第一组显示基本详情，第二组显示报名演员
    if (indexPath.section == hotUsersIndex) {
        
        LLAHotUsersCell *hotUsersCell = [dataCollectionView dequeueReusableCellWithReuseIdentifier:hotUsersCellIden forIndexPath:indexPath];
//        hotUsers.delegate = self;
        
        // 设置数据
//        [hotUsers updateCellWithInfo:scriptInfo maxWidth:collectionView.frame.size.width];
        return hotUsersCell;
        
    }else {
        LLAHotVideosCell *hotVideosCell = [dataCollectionView dequeueReusableCellWithReuseIdentifier:hotVideosCellIden forIndexPath:indexPath];
//        hotVideos.delegate = self;
        
        // 设置数据
//        [hotVideos updateCellWithUserInfo:scriptInfo.partakeUsersArray[indexPath.row]];
        return hotVideosCell;
    }

    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    UIButton *shadeButton = [[UIButton alloc] init];
    shadeButton.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:shadeButton];
    
    searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"点击了取消按钮");
    //
    searchBar.text = @"";
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"开始搜索");
//    TMZoomController *zoom = [[TMZoomController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:zoom];
    
    NSLog(@"%@",self.view);
    self.view.backgroundColor = [UIColor yellowColor];
    
    
}

@end
