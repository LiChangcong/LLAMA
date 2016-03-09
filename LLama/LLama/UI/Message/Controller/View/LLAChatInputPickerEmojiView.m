//
//  LLAChatInputPickerEmojiView.m
//  LLama
//
//  Created by Live on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAChatInputPickerEmojiView.h"

#import "LLAChatInputEmojiFlowLayout.h"
#import "Emoji.h"
#import "LLAChatInputPickEmojiCell.h"
#import "LLAPickEmojiItemInfo.h"

static NSString *const closeImageName_Normal = @"";
static NSString *const closeImageName_Highlight = @"";

static NSString *const emojiIden = @"emojiIden";

//
static const CGFloat closeButtonWidth = 60;
static const CGFloat closeButtonHeight = 32;

static const CGFloat emojiIconHeight = 36;
static const CGFloat emojiIconMinWidth = 46;
static const CGFloat emojiIconVerSpace = 6;
static const CGFloat emojiIconHorSpace = 0;

static const CGFloat pageControlHeight = 20;

static const CGFloat sendButtonHeight = 40;
static const CGFloat sendButtonWidth = 60;
static const CGFloat sendButtonToRight = 2;
static const CGFloat sendButtonToBottom = 1;
static const CGFloat sendButtonCornerRadious = 4;

static const NSInteger numberOfEmojiIconRows = 4;

@interface LLAChatInputPickerEmojiView()<UICollectionViewDataSource,UICollectionViewDelegate,LLAChatInputEmojiFlowLayoutDelegate>
{
    UIButton *closeButton;
    
    UICollectionView *emojiCollection;
    
    UIPageControl *pageControl;
    
    UIButton *sendMessageButton;
    
    //
    NSMutableArray<LLAPickEmojiItemInfo *> *emojiArray;
    
    //
    UIFont *sendMessageButtonFont;
    
    UIColor *sendMessageButtonNormalTextColor;
    UIColor *sendMessageButtonHighlightTextColor;
    
    UIColor *sendMessageButtonNormalBKColor;
    UIColor *sendMessageButtonHighlightBKColor;
    
    //
    CGSize itemSize;
    
    //collectionViewWidth
    CGFloat preCollectionViewWidth;
}

@end

@implementation LLAChatInputPickerEmojiView

@synthesize delegate;

#pragma mark - Life Cycle

- (void) layoutSubviews {
    
    [super layoutSubviews];
    
    //calculate item size
    CGSize collectionBounds = emojiCollection.bounds.size;
    
    if (collectionBounds.width == preCollectionViewWidth) {
        return;
    }
    
    preCollectionViewWidth = collectionBounds.width;
    
    NSInteger maxColumn = (collectionBounds.width - emojiIconHorSpace)/(emojiIconHorSpace + emojiIconMinWidth);
    
    CGFloat iconWidth = (collectionBounds.width - MAX(maxColumn-1, 0)*emojiIconHorSpace) / maxColumn;
    
    itemSize = CGSizeMake(iconWidth, emojiIconHeight);
    
    //generate emoji
    [emojiArray removeAllObjects];
    
    NSArray *emojiStringArray = [Emoji customAllEmoji];
    
    NSInteger numberPerPage = maxColumn * numberOfEmojiIconRows;
    
    NSInteger index = 1;
    
    for (int i=0;i<emojiStringArray.count;i++) {
        

        if (index % numberPerPage == 0) {
            //delete
            LLAPickEmojiItemInfo *emojiInfo = [LLAPickEmojiItemInfo new];
            emojiInfo.type = LLAPickEmojiItemType_DeleteEmoji;
            [emojiArray addObject:emojiInfo];
            
            index ++;
        }else {
            //normal emoji
            
        }
        
        LLAPickEmojiItemInfo *emojiInfo = [LLAPickEmojiItemInfo new];
        emojiInfo.type = LLAPickEmojiItemType_NormalEmoji;
        emojiInfo.emojiString = [emojiStringArray objectAtIndex:i];
        
        [emojiArray addObject:emojiInfo];
        
        index ++;
        
        if (i == emojiStringArray.count-1 && index % numberPerPage > 0) {
            //
            LLAPickEmojiItemInfo *emojiInfo = [LLAPickEmojiItemInfo new];
            emojiInfo.type = LLAPickEmojiItemType_DeleteEmoji;
            [emojiArray addObject:emojiInfo];

        }
        
        
    }
    
    [emojiCollection reloadData];
    
    //page control
    pageControl.numberOfPages = emojiArray.count % (maxColumn * numberOfEmojiIconRows) > 0 ? emojiArray.count / (maxColumn * numberOfEmojiIconRows) + 1: emojiArray.count / (maxColumn * numberOfEmojiIconRows);
    
    [self updatePageControls];
    
}

#pragma mark - Init

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0xf6f6f6];
        [self commonInit];
        
    }
    
    return self;
    
}

- (void) commonInit {
    
    [self initVariables];
    [self initSubViews];
    [self initSubConstraints];
    
}

- (void) initVariables {
    
    sendMessageButtonFont = [UIFont llaFontOfSize:13.5];
    
    sendMessageButtonNormalTextColor = [UIColor whiteColor];
    sendMessageButtonHighlightTextColor = [UIColor whiteColor];
    
    sendMessageButtonNormalBKColor = [UIColor themeColor];
    sendMessageButtonHighlightBKColor = [UIColor lightGrayColor];
    
    emojiArray = [NSMutableArray arrayWithCapacity:40];

}

- (void) initSubViews {
    
    closeButton = [[UIButton alloc] init];
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [closeButton setImage:[UIImage llaImageWithName:closeImageName_Normal] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage llaImageWithName:closeImageName_Highlight] forState:UIControlStateHighlighted];
    
    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:closeButton];
    
    //emoji view
    LLAChatInputEmojiFlowLayout *flowLayout = [[LLAChatInputEmojiFlowLayout alloc] init];
    flowLayout.minCellHorSpace = emojiIconHorSpace;
    flowLayout.minCellVerSpace = emojiIconVerSpace;
    flowLayout.delegate = self;
    
    emojiCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    emojiCollection.translatesAutoresizingMaskIntoConstraints = NO;
    emojiCollection.delegate = self;
    emojiCollection.dataSource = self;
    emojiCollection.backgroundColor = [UIColor colorWithHex:0xf6f6f6];
    emojiCollection.pagingEnabled = YES;
    emojiCollection.showsHorizontalScrollIndicator = NO;
    emojiCollection.showsVerticalScrollIndicator = NO;
    
    [emojiCollection registerClass:[LLAChatInputPickEmojiCell class] forCellWithReuseIdentifier:emojiIden];
    
    [self addSubview:emojiCollection];
    
    //page control
    pageControl = [[UIPageControl alloc] init];
    pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    pageControl.pageIndicatorTintColor = [UIColor colorWithHex:0x9a9a9a];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHex:0x434343];
    [self addSubview:pageControl];
    
    //
    sendMessageButton = [[UIButton alloc] init];
    sendMessageButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    sendMessageButton.titleLabel.font = sendMessageButtonFont;
    sendMessageButton.clipsToBounds = YES;
    sendMessageButton.layer.cornerRadius = sendButtonCornerRadious;
    
    [sendMessageButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendMessageButton setTitleColor:sendMessageButtonNormalTextColor forState:UIControlStateNormal];
    [sendMessageButton setTitleColor:sendMessageButtonHighlightTextColor  forState:UIControlStateHighlighted];
    [sendMessageButton setBackgroundColor:sendMessageButtonNormalBKColor forState:UIControlStateNormal];
    [sendMessageButton setBackgroundColor:sendMessageButtonHighlightBKColor forState:UIControlStateHighlighted];
    
    [sendMessageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:sendMessageButton];
    
}

- (void) initSubConstraints {
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[closeButton(closeHeight)]-(0)-[emojiCollection]-(0)-[pageControl(pageControlHeight)]-(0)-[sendMessageButton(sendHeight)]-(toBottom)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"closeHeight":@(closeButtonHeight),
                @"pageControlHeight":@(pageControlHeight),
                @"sendHeight":@(sendButtonHeight),
                @"toBottom":@(sendButtonToBottom)} views:NSDictionaryOfVariableBindings(closeButton,emojiCollection,pageControl,sendMessageButton)]];
    
    //horizonal
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[closeButton(closeWidth)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"closeWidth":@(closeButtonWidth)} views:NSDictionaryOfVariableBindings(closeButton)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[emojiCollection]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil views:NSDictionaryOfVariableBindings(emojiCollection)]];
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[pageControl]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil views:NSDictionaryOfVariableBindings(pageControl)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[sendMessageButton(width)]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"width":@(sendButtonWidth),
                @"toRight":@(sendButtonToRight)} views:NSDictionaryOfVariableBindings(sendMessageButton)]];
    
    [self addConstraints:constrArray];
    
}

#pragma mark - ButtonClick

- (void) closeButtonClicked:(UIButton *) sender {
    
}

- (void) sendMessage:(UIButton *) sender {

    if (delegate && [delegate respondsToSelector:@selector(sendMessageClicked)]) {
    
        [delegate sendMessageClicked];
    
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return emojiArray.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LLAChatInputPickEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:emojiIden forIndexPath:indexPath];
    
    [cell updateCellWithEmoji:emojiArray[indexPath.row]];
    
    return cell;
    
    
}

#pragma mark - UICollectionViewDelegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LLAPickEmojiItemInfo *info = [emojiArray objectAtIndex:indexPath.row];
    
    if (info.type == LLAPickEmojiItemType_NormalEmoji) {
        if (delegate && [delegate respondsToSelector:@selector(pickedEmoji:)]) {
            [delegate pickedEmoji:info.emojiString];
        }

    }else {
        //delete
        if (delegate && [delegate respondsToSelector:@selector(deleteEmoji)]) {
            [delegate deleteEmoji];
        }
    }
    
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updatePageControls];
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return itemSize;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

#pragma mark - Update PageControls

- (void) updatePageControls {
    
    NSInteger page = (emojiCollection.contentOffset.x + emojiCollection.bounds.size.width/2)/emojiCollection.bounds.size.width;
    
    pageControl.currentPage = page;
    
}

#pragma mark - ViewHeight

+ (CGFloat) calculateHeight {
    CGFloat height = 0;
    height += closeButtonHeight;
    height += ((numberOfEmojiIconRows*emojiIconHeight)+MAX(numberOfEmojiIconRows-1,0)*emojiIconVerSpace);
    height += pageControlHeight;
    height += sendButtonHeight;
    height += sendButtonToBottom;
    height += 6;
    
    return height;
}

@end
