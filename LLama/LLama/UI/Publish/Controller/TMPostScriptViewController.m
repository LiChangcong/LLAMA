//
//  TMPostScriptViewController.m
//  LLama
//
//  Created by tommin on 15/12/15.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMPostScriptViewController.h"

#import "LLAAlbumPickerViewController.h"
#import "LLABaseNavigationController.h"

#import "LLATextView.h"

static const CGFloat textViewToLeftWithoutImage = 20;
static const CGFloat textViewToLeftWithImage = 118;

@interface TMPostScriptViewController ()<LLAAlbumPickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTrailConstraint;
@property (weak, nonatomic) IBOutlet UITextField *rewardMoneyTextField;
@property (weak, nonatomic) IBOutlet UIImageView *preViewImageView;
@property (weak, nonatomic) IBOutlet LLATextView *scriptContentTextView;
@property (weak, nonatomic) IBOutlet UIButton *isPrivateButton;
@property (weak, nonatomic) IBOutlet UIButton *weChatFriend;
@property (weak, nonatomic) IBOutlet UIButton *weChatTimeLine;
@property (weak, nonatomic) IBOutlet UIButton *sinaWeiBo;
@property (weak, nonatomic) IBOutlet UIButton *qqFriend;

@end

@implementation TMPostScriptViewController

@synthesize scriptType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 设置标题
    self.navigationItem.title = @"剧本";
    
    //back item
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage llaImageWithName:@"back"] highlightedImage:nil target:self action:@selector(back)];
    //
    if (scriptType == LLAPublishScriptType_Text) {
        _textViewTrailConstraint.constant = textViewToLeftWithoutImage;
        _preViewImageView.hidden = YES;
    }else {
        _textViewTrailConstraint.constant = textViewToLeftWithImage;
        _preViewImageView.hidden = NO;
        //show choose image
        [self chooseImageView:nil];
    }
    
    //
    _rewardMoneyTextField.placeholder = @"点击此处输入金额";
    _rewardMoneyTextField.textAlignment = NSTextAlignmentRight;
    //
    _preViewImageView.contentMode = UIViewContentModeScaleAspectFill;
    _preViewImageView.userInteractionEnabled = YES;
    _preViewImageView.clipsToBounds = YES;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageView:)];
    [_preViewImageView addGestureRecognizer:tapGes];
    
    //
    _scriptContentTextView.placeholder = @"这里写剧本";
    
    //
    [_isPrivateButton setImage:[UIImage llaImageWithName:@"public"] forState:UIControlStateNormal];
    [_isPrivateButton setImage:[UIImage llaImageWithName:@"privite"] forState:UIControlStateHighlighted];
    [_isPrivateButton setImage:[UIImage llaImageWithName:@"privite"] forState:UIControlStateSelected];
    _isPrivateButton.tintColor = nil;
    
    [_isPrivateButton addTarget:self action:@selector(isPrivateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    [_weChatFriend setImage:[UIImage llaImageWithName:@"wechatShare"] forState:UIControlStateNormal];
    [_weChatFriend setImage:[UIImage llaImageWithName:@"wechatShareHighlight"] forState:UIControlStateSelected];
    _weChatFriend.tintColor = nil;
    
    [_weChatFriend addTarget:self action:@selector(weChatFriendClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_weChatTimeLine setImage:[UIImage llaImageWithName:@"wechatcircle"] forState:UIControlStateNormal];
    [_weChatTimeLine setImage:[UIImage llaImageWithName:@"wechatcircleh"] forState:UIControlStateSelected];
    _weChatFriend.tintColor = nil;
    
    [_weChatTimeLine addTarget:self action:@selector(weChatTimeLineClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_sinaWeiBo setImage:[UIImage llaImageWithName:@"weiboShare"] forState:UIControlStateNormal];
    [_sinaWeiBo setImage:[UIImage llaImageWithName:@"weiboShareHighlight"] forState:UIControlStateSelected];
    
    _sinaWeiBo.tintColor = nil;
    [_sinaWeiBo addTarget:self action:@selector(sinaWeiBoClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_qqFriend setImage:[UIImage llaImageWithName:@"qqtiny"] forState:UIControlStateNormal];
    [_qqFriend setImage:[UIImage llaImageWithName:@"qqtinyh"] forState:UIControlStateSelected];
    _qqFriend.tintColor = nil;
    [_qqFriend addTarget:self action:@selector(qqFriendClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Button Touch up Inside

- (void) isPrivateButtonClicked:(UIButton *) sender {
    
    _isPrivateButton.selected = !_isPrivateButton.selected;
}

- (void) weChatFriendClicked:(UIButton *) sender {
    _weChatFriend.selected = !_weChatFriend.selected;
}

- (void) weChatTimeLineClicked:(UIButton *) sender {
    _weChatTimeLine.selected = !_weChatTimeLine.selected;
}

- (void) sinaWeiBoClicked:(UIButton *) sender {
    _sinaWeiBo.selected = !_sinaWeiBo.selected;
}


- (void) qqFriendClicked:(UIButton *) sender {
    _qqFriend.selected = !_qqFriend.selected;
}

- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Image Tap

- (void) chooseImageView:(UITapGestureRecognizer *) ges {
    
    //
    LLAAlbumPickerViewController *imagePicker = [[LLAAlbumPickerViewController alloc] init];
    imagePicker.delegate = self;
    
    LLABaseNavigationController *baseNavi = [[LLABaseNavigationController alloc] initWithRootViewController:imagePicker];
    
    [self.navigationController presentViewController:baseNavi animated:YES completion:NULL];
    
}

#pragma mark - LLAAlbumPickerViewControllerDelegate

- (void) didFinishChooseImage:(UIImage *)image {
    _preViewImageView.image = image;
    if (scriptType == LLAPublishScriptType_Image && !image) {
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
