//
//  LLASocialShareView.m
//  LLama
//
//  Created by Live on 16/2/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLASocialShareView.h"
#import "MMPopup.h"

#import "LLASocialShareHorPageLayout.h"
#import "LLASocialSharePlatformItem.h"
#import "LLASoicalSharePlatformCell.h"

//
static NSString *const reportButtonTitleString = @"举报";
static NSString *const cancelButtonTitleString = @"取消";
static NSString *const shareCellIden = @"cell";

//
static const CGFloat minItemsVerSpace = 40;
static const CGFloat minItemsHorSpace = 0;

static const CGFloat titleLabelToTop = 17;
static const CGFloat titleLabelHeight = 16;
static const CGFloat titleLabelToCollectionVerSpace = 16;
static const CGFloat viewsToHorSpace = 25;

static const CGFloat collectionToButtonVerSapce = 22;
static const CGFloat functionButtonHeight = 36;
static const CGFloat functionButtonVerSapce = 16;
static const CGFloat functionButtonToBottom = 22;

@interface LLASocialShareView()<UICollectionViewDataSource,LLASocialShareHorPageLayoutDelegate,UICollectionViewDelegate,LLASoicalSharePlatformCellDelegate>
{
    UIView *backView;
    UIColor *backViewBKColor;
    
    UICollectionView *dataCollectionView;
    
    UILabel *titleLabel;
    
    UIButton *reportButton;
    UIButton *cancelButton;
    
    //
    UIFont *titleLabelFont;
    UIColor *titleLabelTextColor;
    
    UIFont *reportButtonFont;
    UIColor *reportButtonTextColorNormal;
    UIColor *reportButtonTextColorHighlight;
    UIColor *reportButtonBKColorNormal;
    UIColor *reportButtonBKColorHighlight;
    
    UIFont *cancelButtonFont;
    UIColor *cancelButtonTextColorNormal;
    UIColor *cancelButtonTextColorHighlight;
    UIColor *cancelButtonBKColorNormal;
    UIColor *cancelButtonBKColorHighlight;
    
    //
    CGFloat backViewHeight;
    
    //
    NSArray <LLASocialSharePlatformItem *> *platforms;
    BOOL haveReport;
    NSString *titleString;
    
    
    NSLayoutConstraint *backViewToBottomConstraints;
    
}
@end

@implementation LLASocialShareView

@synthesize completeHandler;
@synthesize reportHandler;

- (instancetype) initWithPlatforms:(NSArray<LLASocialSharePlatformItem *> *) platformsArray
                             title:(NSString *) title
                         hasReport:(BOOL) report {
    self = [super init];
    if (self) {
        
        self.type = MMPopupTypeCustom;
        
        platforms = platformsArray;
        haveReport = report;
        titleString = title;
        
        [self initVariables];
        [self initBackView];
        [self initSubViews];
        [self initConstraints];
        
        [self initShowAnimation];
        [self initHideAnimation];
        
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        
        
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void) initVariables {
    
    backViewBKColor = [UIColor whiteColor];
    
    titleLabelFont = [UIFont llaFontOfSize:14];
    titleLabelTextColor = [UIColor colorWithHex:0x11111e];
    
    if (haveReport){
        reportButtonFont = [UIFont llaFontOfSize:16];
        reportButtonTextColorNormal = [UIColor colorWithHex:0x11111e];
        reportButtonTextColorHighlight = [UIColor colorWithHex:0x11111e];
        reportButtonBKColorNormal = [UIColor colorWithHex:0xeaeaea];
        reportButtonBKColorHighlight = [UIColor themeColor];
    }
    
    cancelButtonFont = [UIFont llaFontOfSize:16];
    cancelButtonTextColorNormal = [UIColor colorWithHex:0x11111e];
    cancelButtonTextColorHighlight = [UIColor colorWithHex:0x11111e];
    cancelButtonBKColorNormal = [UIColor themeColor];
    cancelButtonBKColorHighlight = [UIColor colorWithHex:0xeaeaea];

    
}

- (void) initBackView {
    backView = [[UIView alloc] init];
    backView.translatesAutoresizingMaskIntoConstraints = NO;
    backView.backgroundColor = backViewBKColor;
    backView.userInteractionEnabled = YES;
    
    [self addSubview:backView];
}

- (void) initSubViews {
    titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = titleLabelFont;
    titleLabel.textColor = titleLabelTextColor;
    titleLabel.text = titleString;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    
    //
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    flowLayout.minimumInteritemSpacing = minItemsVerSpace;
//    flowLayout.minimumLineSpacing = minItemsHorSpace;
    LLASocialShareHorPageLayout *flowLayout = [[LLASocialShareHorPageLayout alloc] init];
    flowLayout.minCellVerSpace = minItemsVerSpace;
    flowLayout.minCellHorSpace = minItemsHorSpace;
    flowLayout.delegate = self;
    
    dataCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    dataCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    dataCollectionView.backgroundColor = backView.backgroundColor;
    dataCollectionView.delegate = self;
    dataCollectionView.dataSource = self;
    dataCollectionView.pagingEnabled = YES;
    dataCollectionView.showsHorizontalScrollIndicator = NO;
    dataCollectionView.showsVerticalScrollIndicator = NO;
    
    [dataCollectionView registerClass:[LLASoicalSharePlatformCell class] forCellWithReuseIdentifier:shareCellIden];
    
    [backView addSubview:dataCollectionView];
    
    if (haveReport) {
        reportButton = [[UIButton alloc] init];
        reportButton.translatesAutoresizingMaskIntoConstraints = NO;
        reportButton.titleLabel.font = reportButtonFont;
        reportButton.clipsToBounds = YES;
        reportButton.layer.cornerRadius = 3.0;
        
        [reportButton setTitle:reportButtonTitleString forState:UIControlStateNormal];
        [reportButton setTitleColor:reportButtonTextColorNormal forState:UIControlStateNormal];
        [reportButton setTitleColor:reportButtonTextColorHighlight forState:UIControlStateHighlighted];
        [reportButton setBackgroundColor:reportButtonBKColorNormal forState:UIControlStateNormal];
        [reportButton setBackgroundColor:reportButtonBKColorHighlight forState:UIControlStateHighlighted];
        
        [reportButton addTarget:self action:@selector(reportButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [backView addSubview:reportButton];
        
    }
    
    cancelButton = [[UIButton alloc] init];
    cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    cancelButton.titleLabel.font = cancelButtonFont;
    cancelButton.clipsToBounds = YES;
    cancelButton.layer.cornerRadius = 3.0;
    
    [cancelButton setTitle:cancelButtonTitleString forState:UIControlStateNormal];
    [cancelButton setTitleColor:cancelButtonTextColorNormal forState:UIControlStateNormal];
    [cancelButton setTitleColor:cancelButtonTextColorHighlight forState:UIControlStateHighlighted];
    [cancelButton setBackgroundColor:cancelButtonBKColorNormal forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:cancelButtonBKColorHighlight forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:cancelButton];
    
}

- (void) initConstraints {
    [self calculateBackViewHeight];
    
    
    //backView Constraints
    
    [self addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[backView(height)]-(toBottom)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toBottom":@(-backViewHeight),
                @"height":@(backViewHeight)} views:NSDictionaryOfVariableBindings(backView)]];
    [self addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[backView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil views:NSDictionaryOfVariableBindings(backView)]];
    
    for (NSLayoutConstraint *constr in self.constraints) {
        if (constr.secondItem == backView && constr.secondAttribute == NSLayoutAttributeBottom) {
            backViewToBottomConstraints = constr;
        }
    }
    
    //constraints on backView
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    if (haveReport) {
        [constrArray addObjectsFromArray:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|-(toTop)-[titleLabel(titleHeight)]-(titleToCollection)-[dataCollectionView]-(collectionToButton)-[reportButton(buttonHeight)]-(buttonVerSpace)-[cancelButton(buttonHeight)]-(toBottom)-|"
          options:NSLayoutFormatDirectionLeadingToTrailing
          metrics:@{@"toTop":@(titleLabelToTop),
                    @"titleHeight":@(titleLabelHeight),
                    @"titleToCollection":@(titleLabelToCollectionVerSpace),
                    @"collectionToButton":@(collectionToButtonVerSapce),
                    @"buttonHeight":@(functionButtonHeight),
                    @"buttonVerSpace":@(functionButtonVerSapce),
                    @"toBottom":@(functionButtonToBottom)}
          views:NSDictionaryOfVariableBindings(titleLabel,dataCollectionView,reportButton,cancelButton)]];
    }else {
        [constrArray addObjectsFromArray:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|-(toTop)-[titleLabel(titleHeight)]-(titleToCollection)-[dataCollectionView]-(collectionToButton)-[cancelButton(buttonHeight)]-(toBottom)-|"
          options:NSLayoutFormatDirectionLeadingToTrailing
          metrics:@{@"toTop":@(titleLabelToTop),
                    @"titleHeight":@(titleLabelHeight),
                    @"titleToCollection":@(titleLabelToCollectionVerSpace),
                    @"collectionToButton":@(collectionToButtonVerSapce),
                    @"buttonHeight":@(functionButtonHeight),
                    @"toBottom":@(functionButtonToBottom)}
          views:NSDictionaryOfVariableBindings(titleLabel,dataCollectionView,cancelButton)]];
    }
    
    //horizonal
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toBorder)-[titleLabel]-(toBorder)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toBorder":@(viewsToHorSpace)}
      views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toBorder)-[dataCollectionView]-(toBorder)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toBorder":@(viewsToHorSpace)}
      views:NSDictionaryOfVariableBindings(dataCollectionView)]];

    if (haveReport) {
        [constrArray addObjectsFromArray:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-(toBorder)-[reportButton]-(toBorder)-|"
          options:NSLayoutFormatDirectionLeadingToTrailing
          metrics:@{@"toBorder":@(viewsToHorSpace)}
          views:NSDictionaryOfVariableBindings(reportButton)]];

    }

    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toBorder)-[cancelButton]-(toBorder)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toBorder":@(viewsToHorSpace)}
      views:NSDictionaryOfVariableBindings(cancelButton)]];
    
    [backView addConstraints:constrArray];

    
}

- (void) initShowAnimation {
    __weak typeof(self) weakSelf = self;
    
    MMPopupBlock block = ^(MMPopupView *popupView) {
        
        __strong  typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.attachedView.mm_dimBackgroundView addSubview:strongSelf];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        [strongSelf.attachedView.mm_dimBackgroundView addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|-(0)-[strongSelf]-(0)-|"
          options:NSLayoutFormatDirectionLeadingToTrailing
          metrics:nil
          views:NSDictionaryOfVariableBindings(strongSelf)]];
        [strongSelf.attachedView.mm_dimBackgroundView addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-(0)-[strongSelf]-(0)-|"
          options:NSLayoutFormatDirectionLeadingToTrailing
          metrics:nil
          views:NSDictionaryOfVariableBindings(strongSelf)]];
        [strongSelf layoutIfNeeded];
        
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             backViewToBottomConstraints.constant = 0;
                             [strongSelf layoutIfNeeded];
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if ( strongSelf.showCompletionBlock )
                             {
                                 strongSelf.showCompletionBlock(strongSelf);
                             }
                             
                         }];
        
    };
    
    self.showAnimation = block;

}

- (void) initHideAnimation {
    __weak typeof(self) weakSelf = self;
    
    MMPopupBlock block = ^(MMPopupView *popupView) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             backViewToBottomConstraints.constant = -backViewHeight;
                             [strongSelf layoutIfNeeded];
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [strongSelf removeConstraints:strongSelf.constraints];
                             [strongSelf removeFromSuperview];
                             
                             if ( strongSelf.hideCompletionBlock )
                             {
                                 strongSelf.hideCompletionBlock(strongSelf);
                             }
                             
                         }];
    };
    
    self.hideAnimation = block;
}

#pragma mark - Calculate Back View Height

- (void) calculateBackViewHeight {
    //calculate backViewHegiht
    backViewHeight = 0;
    backViewHeight += titleLabelToTop;
    backViewHeight += titleLabelHeight;
    backViewHeight += titleLabelToCollectionVerSpace;
    
    //calculate collectionView height
    NSInteger numbersInRow = 3;
    if ([UIScreen mainScreen].bounds.size.width >= 375) {
        numbersInRow = 4;
    }
    
    CGFloat itemHeight = [LLASoicalSharePlatformCell calculateHeightWithPlatformInfo:[platforms firstObject] maxWidth:([UIScreen mainScreen].bounds.size.width-2*viewsToHorSpace)/numbersInRow];
    
    if (platforms.count <= numbersInRow) {
        backViewHeight += itemHeight;
    }else {
        backViewHeight += 2*itemHeight;
        backViewHeight += minItemsVerSpace;
    }
    
    backViewHeight += collectionToButtonVerSapce;
    if (haveReport) {
        backViewHeight += functionButtonHeight;
        backViewHeight += functionButtonVerSapce;
    }
    
    backViewHeight += functionButtonHeight;
    backViewHeight += functionButtonToBottom;

}

#pragma mark - Button Event

- (void) reportButtonClick:(UIButton *) sender {
    if (reportHandler) {
        reportHandler();
    }
    [self hide];
}

- (void) cancelButtonClick:(UIButton *) sender {
    [self hide];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return platforms.count;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LLASoicalSharePlatformCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shareCellIden forIndexPath:indexPath];
    cell.delegate = self;
    [cell updateCellWithPlatformInfo:platforms[indexPath.row]];
    
    return cell;
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger numbersInRow = 3;
    if ([UIScreen mainScreen].bounds.size.width >= 375) {
        numbersInRow = 4;
    }
    
    CGFloat width = floor((dataCollectionView.bounds.size.width-(numbersInRow-1)*minItemsHorSpace)/numbersInRow);
    CGFloat height = [LLASoicalSharePlatformCell calculateHeightWithPlatformInfo:platforms[indexPath.row] maxWidth:width];
    
    return CGSizeMake(width, height);
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

#pragma mark - ShareCellDelegate

- (void) shareWithPlatformInfo:(LLASocialSharePlatformItem *)platformInfo {
    
    if (completeHandler) {
        completeHandler([platforms indexOfObject:platformInfo]);
    }
    
    [self hide];
}

@end
