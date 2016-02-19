//
//  LLAUserProfileMyInfoCell.m
//  LLama
//
//  Created by Live on 16/1/21.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserProfileMyInfoCell.h"

#import "LLAUserHeadView.h"
#import "LLAUser.h"

#import "LLAUploadVideoProgressView.h"
#import "LLAUploadVideoShareManager.h"

static const CGFloat headViewHeightWidth = 59;
static const CGFloat headViewToUploadButtonVerSpace = 17;
//static const CGFloat uploadButtonHeight = 23;
//static const CGFloat uploadButtonToDescription = 10;

static const CGFloat descriptionToHorBorder = 45;

//
static NSString *const uploadViewButtonImageName_Normal = @"userProfile_NewVideo_Normal";
static NSString *const uploadViewButtonImageName_Highlight = @"userProfile_NewVideo_Highlight";

@interface LLAUserProfileMyInfoCell()<LLAUserHeadViewDelegate,LLAUploadVideoProgressViewDelegate>
{
    //without video
    
    LLAUserHeadView *headView;
    
    UIButton *uploadUserVideoButton;
    
    //common view
    
    UIImageView *videoCoverImageView;
    
    UIView *personDescriptionBackView;
    
    UILabel *personDescriptionLabel;
    
    LLAUploadVideoProgressView *videoProgressView;
    
    //
    UIColor *personDescriptionBackViewBKColor;
    
    UIFont *personDescriptionLabelFont;
    UIColor *personDescriptionLabelTextColor;
    
    //
    LLAUser *currentUser;
    
}

@property(nonatomic , readwrite , strong) LLAVideoPlayerView *videoPlayerView;

@property(nonatomic , readwrite , strong) LLAVideoInfo *shouldPlayVideoInfo;

@end

@implementation LLAUserProfileMyInfoCell

@synthesize videoPlayerView;
@synthesize shouldPlayVideoInfo;
@synthesize delegate;

#pragma mark - Init

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHex:0x11111e];
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
        
    }
    return self;
}

- (void) initVariables {
    
    personDescriptionBackViewBKColor = [UIColor colorWithHex:0x000000 alpha:0.5];
    
    personDescriptionLabelFont = [UIFont llaFontOfSize:13];
    personDescriptionLabelTextColor = [UIColor whiteColor];
}

- (void) initSubViews {
    
    //
    videoCoverImageView = [[UIImageView alloc] init];
    videoCoverImageView.translatesAutoresizingMaskIntoConstraints = NO;
    videoCoverImageView.clipsToBounds = YES;
    
    [self.contentView addSubview:videoCoverImageView];
    
    videoPlayerView = [[LLAVideoPlayerView alloc] init];
    videoPlayerView.translatesAutoresizingMaskIntoConstraints = NO;
    //videoPlayerView.hidden = YES;
    videoPlayerView.delegate = delegate;
    
    [self.contentView addSubview:videoPlayerView];
    
    
    //without video
    headView = [[LLAUserHeadView alloc] init];
    headView.translatesAutoresizingMaskIntoConstraints = NO;
    headView.delegate = self;
    
    headView.userHeadImageView.layer.borderWidth = 2.0;
    headView.userHeadImageView.layer.borderColor = [UIColor whiteColor].CGColor ;
    
    [self.contentView addSubview:headView];
    
    uploadUserVideoButton = [[UIButton alloc] init];
    uploadUserVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [uploadUserVideoButton setImage:[UIImage llaImageWithName:uploadViewButtonImageName_Normal] forState:UIControlStateNormal];
    [uploadUserVideoButton setImage:[UIImage llaImageWithName:uploadViewButtonImageName_Highlight] forState:UIControlStateHighlighted];
    
    [uploadUserVideoButton addTarget:self action:@selector(uploadVideo:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:uploadUserVideoButton];
    
    //
    personDescriptionBackView = [[UIView alloc] init];
    personDescriptionBackView.translatesAutoresizingMaskIntoConstraints = NO;
    personDescriptionBackView.backgroundColor = personDescriptionBackViewBKColor;
    
    [self.contentView addSubview:personDescriptionBackView];
    
    personDescriptionLabel = [[UILabel alloc] init];
    personDescriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    personDescriptionLabel.font = personDescriptionLabelFont;
    personDescriptionLabel.textColor = personDescriptionLabelTextColor;
    //personDescriptionLabel.numberOfLines = 3;
    personDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:personDescriptionLabel];
    
    //
    videoProgressView = [[LLAUploadVideoProgressView alloc] initWithViewType:videoUploadType_UserVideo];
    videoProgressView.translatesAutoresizingMaskIntoConstraints = NO;
    videoProgressView.delegate = self;
    videoProgressView.hidden = YES;
    [self.contentView addSubview:videoProgressView];
    
}

- (void) initSubConstraints {
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:headView
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self.contentView
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:headView
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0
      constant:headViewHeightWidth]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[headView]-(headToUpload)-[uploadUserVideoButton]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(headViewToUploadButtonVerSpace),@"headToUpload", nil]
      views:NSDictionaryOfVariableBindings(headView,uploadUserVideoButton)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[personDescriptionLabel(<=40)]-(2)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(personDescriptionLabel)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[personDescriptionBackView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(personDescriptionBackView)]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:personDescriptionBackView
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:personDescriptionLabel
      attribute:NSLayoutAttributeHeight
      multiplier:1.0
      constant:4]];
    //
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[videoCoverImageView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(videoCoverImageView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[videoPlayerView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(videoPlayerView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[videoProgressView(progressHeight)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"progressHeight":@(LLAUploadVideoProgressViewHeight)}
      views:NSDictionaryOfVariableBindings(videoProgressView)]];
    
    //horizonal
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:headView
      attribute:NSLayoutAttributeCenterX
      relatedBy:NSLayoutRelationEqual
      toItem:self.contentView
      attribute:NSLayoutAttributeCenterX
      multiplier:1.0
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:uploadUserVideoButton
      attribute:NSLayoutAttributeCenterX
      relatedBy:NSLayoutRelationEqual
      toItem:self.contentView
      attribute:NSLayoutAttributeCenterX
      multiplier:1.0
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:headView
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0
      constant:headViewHeightWidth]];
    
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[personDescriptionBackView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(personDescriptionBackView)]];
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toBorder@999)-[personDescriptionLabel]-(toBorder@999)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(descriptionToHorBorder),@"toBorder", nil]
      views:NSDictionaryOfVariableBindings(personDescriptionLabel)]];
    //
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[videoCoverImageView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(videoCoverImageView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[videoPlayerView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(videoPlayerView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[videoProgressView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(videoProgressView)]];
    
    
    [self.contentView addConstraints:constrArray];
}

//
#pragma mark - Button Clicked

- (void) uploadVideo:(UIButton *) sender {
    if (delegate && [delegate respondsToSelector:@selector(uploadVieoToggled:)]) {
        [delegate uploadVieoToggled:currentUser];
    }
}

#pragma mark - UserHeadViewDelegate


- (void) headView:(LLAUserHeadView *)headView clickedWithUserInfo:(LLAUser *)user {
    if (delegate && [delegate respondsToSelector:@selector(headViewTapped:)]) {
        [delegate headViewTapped:currentUser];
    }
}

#pragma mark - UploadVideoProgressViewDelegate

- (void) uploadVideoFinished:(LLAUploadVideoProgressView *) progressView {
    if (delegate && [delegate respondsToSelector:@selector(uploadVieoFinished:)]) {
        [delegate uploadVieoFinished:currentUser];
    }
}

- (void) uploadVideoFailed:(LLAUploadVideoProgressView *) progressView {

}


#pragma mark - update

- (void) updateCellWithUserInfo:(LLAUser *)userInfo tableWidth:(CGFloat)tableWidth {
    
    currentUser = userInfo;
    
    if (!userInfo.userVideo) {

        //no video
        headView.hidden = NO;
        [headView updateHeadViewWithUser:currentUser];
        
        uploadUserVideoButton.hidden = NO;
        
        //
        videoCoverImageView.hidden = YES;
        videoPlayerView.hidden = YES;
        [videoPlayerView stopVideo];
        shouldPlayVideoInfo = nil;
        
    
    }else {
        
        headView.hidden = YES;
        uploadUserVideoButton.hidden = YES;
        
        videoCoverImageView.hidden = NO;
        videoPlayerView.hidden = NO;
        [videoCoverImageView setImageWithURL:[NSURL URLWithString:currentUser.userVideo.videoCoverImageURL] placeholderImage:[UIImage llaImageWithName:@"placeHolder_750"]];
        
        shouldPlayVideoInfo = currentUser.userVideo;
        
        [videoPlayerView updateCoverImageWithVideoInfo:shouldPlayVideoInfo];
        
    }
    
    personDescriptionLabel.text = currentUser.userDescription;
}

#pragma makr - Calculate height

+ (CGFloat) calculateHeightWithUserInfo:(LLAUser *)userInfo tableWidth:(CGFloat)tableWidth {
    return tableWidth;
}

@end
