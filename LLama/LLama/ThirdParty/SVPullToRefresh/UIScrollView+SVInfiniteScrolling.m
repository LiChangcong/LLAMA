//
// UIScrollView+SVInfiniteScrolling.m
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+SVInfiniteScrolling.h"


static CGFloat const SVInfiniteScrollingViewHeight = 60;

static NSString *const SVInfiniteScrollingLoadingString = @"正在加载...";
//static NSString *const SVInfiniteScrollingTriggeredString = @"释放加载";
//static NSString *const SVInfiniteScrollingStoppedString = @"加载更多";
static NSString *const SVInfiniteScrollingTriggeredString = @"正在加载...";
static NSString *const SVInfiniteScrollingStoppedString = @"加载更多...";

static NSString *const loadingImageName = @"pullToRefreshLoadingImage";
static NSString *const arrowImageName = @"pullToRefreshLoadingImage";

static const CGFloat loadingIndicatorViewHeight = 24;
static const CGFloat loadingIndicatorViewWidth = 24;
static const CGFloat arrowImageViewHeight = 24;
static const CGFloat arrowImageViewWidth = 24;

//static NSInteger const SVInfiniteToRefreshImageCount = 24;

@interface SVInfiniteScrollingDotView : UIView

@property (nonatomic, strong) UIColor *arrowColor;

@end

@interface SVInfiniteScrollingLoadingView : UIImageView

@property(nonatomic , assign) BOOL isAnimating;

- (void) startAnimating;

- (void) stopAnimating;

@end


@interface SVInfiniteScrollingView ()

@property (nonatomic, copy) void (^infiniteScrollingHandler)(void);
//
@property (nonatomic, strong) UIImageView *infiniteArrowImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) SVInfiniteScrollingLoadingView *loadingView;
//@property (nonatomic, strong) UIImageView *loadingView;
//
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, readwrite) SVInfiniteScrollingState state;
@property (nonatomic, strong) NSMutableArray *viewForState;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalBottomInset;
@property (nonatomic, assign) BOOL wasTriggeredByUser;
@property (nonatomic, assign) BOOL isObserving;

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForInfiniteScrolling;
- (void)setScrollViewContentInset:(UIEdgeInsets)insets;
- (void)rotateArrow:(float)degrees hide:(BOOL)hide;

@end



#pragma mark - UIScrollView (SVInfiniteScrollingView)
#import <objc/runtime.h>

static char UIScrollViewInfiniteScrollingView;
UIEdgeInsets scrollViewOriginalContentInsets;

@implementation UIScrollView (SVInfiniteScrolling)

@dynamic infiniteScrollingView;

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler {
    
    if(!self.infiniteScrollingView) {
        SVInfiniteScrollingView *view = [[SVInfiniteScrollingView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, self.bounds.size.width, SVInfiniteScrollingViewHeight)];
        view.infiniteScrollingHandler = actionHandler;
        view.scrollView = self;
        [self addSubview:view];
        
        view.originalBottomInset = self.contentInset.bottom;
        self.infiniteScrollingView = view;
        self.showsInfiniteScrolling = YES;
    }
}

- (void)triggerInfiniteScrolling {
    self.infiniteScrollingView.state = SVInfiniteScrollingStateTriggered;
    [self.infiniteScrollingView startAnimating];
}

- (void)setInfiniteScrollingView:(SVInfiniteScrollingView *)infiniteScrollingView {
    [self willChangeValueForKey:@"UIScrollViewInfiniteScrollingView"];
    objc_setAssociatedObject(self, &UIScrollViewInfiniteScrollingView,
                             infiniteScrollingView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UIScrollViewInfiniteScrollingView"];
}

- (SVInfiniteScrollingView *)infiniteScrollingView {
    return objc_getAssociatedObject(self, &UIScrollViewInfiniteScrollingView);
}

- (void)setShowsInfiniteScrolling:(BOOL)showsInfiniteScrolling {
    self.infiniteScrollingView.hidden = !showsInfiniteScrolling;
    
    if(!showsInfiniteScrolling) {
      if (self.infiniteScrollingView.isObserving) {
        [self removeObserver:self.infiniteScrollingView forKeyPath:@"contentOffset"];
        [self removeObserver:self.infiniteScrollingView forKeyPath:@"contentSize"];
        [self.infiniteScrollingView resetScrollViewContentInset];
        self.infiniteScrollingView.isObserving = NO;
      }
    }
    else {
      if (!self.infiniteScrollingView.isObserving) {
        [self addObserver:self.infiniteScrollingView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self.infiniteScrollingView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [self.infiniteScrollingView setScrollViewContentInsetForInfiniteScrolling];
        self.infiniteScrollingView.isObserving = YES;
          
        [self.infiniteScrollingView setNeedsLayout];
        self.infiniteScrollingView.frame = CGRectMake(0, self.contentSize.height, self.infiniteScrollingView.bounds.size.width, SVInfiniteScrollingViewHeight);
      }
    }
}

- (BOOL)showsInfiniteScrolling {
    //return !self.infiniteScrollingView.hidden;
    return self.infiniteScrollingView.isObserving;
}

@end


#pragma mark - SVInfiniteScrollingView
@implementation SVInfiniteScrollingView

// public properties
@synthesize infiniteScrollingHandler, activityIndicatorViewStyle;

@synthesize state = _state;
@synthesize scrollView = _scrollView;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize titleLabel = _titleLabel;
@synthesize loadingView = _loadingView;
@synthesize infiniteArrowImageView = _infiniteArrowImageView;

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        // default styling values
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = SVInfiniteScrollingStateStopped;
        self.enabled = YES;

        self.viewForState = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showsInfiniteScrolling) {
          if (self.isObserving) {
            [scrollView removeObserver:self forKeyPath:@"contentOffset"];
            [scrollView removeObserver:self forKeyPath:@"contentSize"];
            self.isObserving = NO;
          }
        }
    }
}

- (void)layoutSubviews {
    self.activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
}

#pragma mark - Scroll View

- (void)resetScrollViewContentInset {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.bottom = self.originalBottomInset;
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInsetForInfiniteScrolling {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.bottom = self.originalBottomInset + SVInfiniteScrollingViewHeight;
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:NULL];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {    
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"contentSize"]) {
        [self layoutSubviews];
        self.frame = CGRectMake(0, MAX(self.scrollView.contentSize.height,0), self.bounds.size.width, SVInfiniteScrollingViewHeight);
        
    }
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    
    if(self.state != SVInfiniteScrollingStateLoading && self.enabled) {
        CGFloat scrollViewContentHeight = self.scrollView.contentSize.height;
        
        CGFloat scrollOffsetThreshold = MAX(scrollViewContentHeight-self.scrollView.bounds.size.height,0);
        if(!self.scrollView.isDragging && self.state == SVInfiniteScrollingStateTriggered)
            self.state = SVInfiniteScrollingStateLoading;
        else if(contentOffset.y > scrollOffsetThreshold && self.state == SVInfiniteScrollingStateStopped && self.scrollView.isDragging)
            self.state = SVInfiniteScrollingStateTriggered;
        else if(contentOffset.y < scrollOffsetThreshold  && self.state != SVInfiniteScrollingStateStopped)
            self.state = SVInfiniteScrollingStateStopped;
    }
    if (self.state == SVInfiniteScrollingStateStopped){
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
}

#pragma mark - Getters

- (UIActivityIndicatorView *)activityIndicatorView {
//    if(!_activityIndicatorView) {
//        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        _activityIndicatorView.hidesWhenStopped = YES;
//        [self addSubview:_activityIndicatorView];
//    }
//    return _activityIndicatorView;
    return nil;
}

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    return self.activityIndicatorView.activityIndicatorViewStyle;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
        _titleLabel.text = NSLocalizedString(@"Pull to refresh...",);
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor colorWithHex:0x999999];
        
        
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIImageView *)infiniteArrowImageView{
    if (!_infiniteArrowImageView){
        _infiniteArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.bounds.size.height- arrowImageViewHeight)/2, arrowImageViewWidth, arrowImageViewHeight)];
        _infiniteArrowImageView.image = [UIImage imageNamed:arrowImageName];
        _infiniteArrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:_infiniteArrowImageView];
    }
    return _infiniteArrowImageView;
}

- (SVInfiniteScrollingLoadingView *) loadingView {
    if (!_loadingView){
        
        _loadingView = [[SVInfiniteScrollingLoadingView alloc] initWithFrame:CGRectMake(0, 0, loadingIndicatorViewWidth, loadingIndicatorViewHeight)];
        _loadingView.image = [UIImage imageNamed:loadingImageName];
        
        [self addSubview:_loadingView];
        
    }
    return _loadingView;
}

//- (UIImageView *) loadingView {
//    if (!_loadingView){
//        _loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, loadingIndicatorViewWidth, loadingIndicatorViewHeight)];
//        NSMutableArray *imageArray = [NSMutableArray array];
//        for (int i=1; i<=SVInfiniteToRefreshImageCount; i++) {
//            NSString *imageName = [NSString stringWithFormat:@"%dr", i];
//            [imageArray addObject:[UIImage imageNamed:imageName]];
//        }
//        _loadingView.animationImages = imageArray;
//        _loadingView.animationDuration = 1.5;
//        
//        
//        [self addSubview:_loadingView];
//        
//    }
//    return _loadingView;
//}


#pragma mark - Setters

- (void)setCustomView:(UIView *)view forState:(SVInfiniteScrollingState)state {
    id viewPlaceholder = view;
    
    if(!viewPlaceholder)
        viewPlaceholder = @"";
    
    if(state == SVInfiniteScrollingStateAll)
        [self.viewForState replaceObjectsInRange:NSMakeRange(0, 3) withObjectsFromArray:@[viewPlaceholder, viewPlaceholder, viewPlaceholder]];
    else
        [self.viewForState replaceObjectAtIndex:state withObject:viewPlaceholder];
    
    self.state = self.state;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)viewStyle {
    self.activityIndicatorView.activityIndicatorViewStyle = viewStyle;
}

#pragma mark -

- (void)triggerRefresh {
    self.state = SVInfiniteScrollingStateTriggered;
    self.state = SVInfiniteScrollingStateLoading;
}

- (void)startAnimating{
    self.state = SVInfiniteScrollingStateLoading;
}

- (void)stopAnimating {
    self.state = SVInfiniteScrollingStateStopped;
}

- (void)setState:(SVInfiniteScrollingState)newState {
    
    /*
     现在不要这箭头
   */
    self.infiniteArrowImageView.hidden = YES;
    self.loadingView.hidden = NO;
    //
    
    if(_state == newState)
        return;
    
    SVInfiniteScrollingState previousState = _state;
    _state = newState;
    
    for(id otherView in self.viewForState) {
        if([otherView isKindOfClass:[UIView class]])
            [otherView removeFromSuperview];
    }
    
    id customView = [self.viewForState objectAtIndex:newState];
    BOOL hasCustomView = [customView isKindOfClass:[UIView class]];
    
    if(hasCustomView) {
        [self addSubview:customView];
        CGRect viewBounds = [customView bounds];
        CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
        [customView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
    }
    else {
        CGRect viewBounds = [self.activityIndicatorView bounds];
        CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
        [self.activityIndicatorView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
        
        CGFloat leftViewWidth = MAX(self.loadingView.bounds.size.width, self.infiniteArrowImageView.bounds.size.width);
        CGFloat margin = 10;    // 图片与文字的间距

        NSString *titleString = @"";
        
        switch (newState) {
            case SVInfiniteScrollingStateStopped:
                [self.activityIndicatorView stopAnimating];
                
//                [self rotateArrow:0 hide:NO];
                [self.loadingView stopAnimating];
                titleString = SVInfiniteScrollingStoppedString;
                self.hidden = YES;
                break;
                
            case SVInfiniteScrollingStateTriggered:
                //[self.activityIndicatorView startAnimating];
                [self.activityIndicatorView stopAnimating];
                
//                [self rotateArrow:M_PI hide:NO];
                [self.loadingView startAnimating];
                
                titleString = SVInfiniteScrollingTriggeredString;
                self.hidden = NO;
                break;
                
            case SVInfiniteScrollingStateLoading:
                //[self.activityIndicatorView startAnimating];
                [self.activityIndicatorView stopAnimating];
                
//                [self rotateArrow:0 hide:YES];
                [self.loadingView startAnimating];
                
                titleString = SVInfiniteScrollingLoadingString;
                self.hidden = NO;
                break;
        }
        
        self.titleLabel.text = titleString;
        
        CGFloat labelMaxSize = self.bounds.size.width - margin - leftViewWidth;
        
        CGSize titleSize = [titleString boundingRectWithSize:CGSizeMake(labelMaxSize,self.titleLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.titleLabel.font,NSFontAttributeName, nil] context:nil].size;
     
        CGFloat totalMaxWidth = titleSize.width + margin + leftViewWidth;
    
        CGFloat labelX = (self.bounds.size.width - totalMaxWidth)/2 + margin + leftViewWidth;
        
        self.titleLabel.frame = CGRectMake(labelX, (self.bounds.size.height - self.titleLabel.bounds.size.height)/2, titleSize.width, self.titleLabel.frame.size.height);
        
        CGFloat arrowImageX = (self.bounds.size.width / 2) - (totalMaxWidth / 2) + (leftViewWidth - self.infiniteArrowImageView.bounds.size.width) / 2;
        self.infiniteArrowImageView.frame = CGRectMake(arrowImageX, (self.bounds.size.height-self.infiniteArrowImageView.bounds.size.height)/2, self.infiniteArrowImageView.bounds.size.width, self.infiniteArrowImageView.bounds.size.height);
        self.loadingView.center = self.infiniteArrowImageView.center;
        
    }
    
    if(previousState == SVInfiniteScrollingStateTriggered && newState == SVInfiniteScrollingStateLoading && self.infiniteScrollingHandler && self.enabled)
        self.infiniteScrollingHandler();
}

- (void)rotateArrow:(float)degrees hide:(BOOL)hide {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.infiniteArrowImageView.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
        self.infiniteArrowImageView.hidden = hide;
        //[self.arrow setNeedsDisplay];//ios 4
    } completion:NULL];
}


@end

#pragma mark - LoadingView

@implementation SVInfiniteScrollingLoadingView

@synthesize isAnimating;

- (void) startAnimating {
    self.hidden= NO;
    if (!isAnimating){
        CABasicAnimation *rotateAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAni.fromValue = @(0);
        rotateAni.toValue = @(2*M_PI);
        rotateAni.duration = 0.8;
        rotateAni.removedOnCompletion = NO;
        rotateAni.repeatCount = INFINITY;
        rotateAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [self.layer addAnimation:rotateAni forKey:nil];
        
        isAnimating = YES;
    }
}

- (void) stopAnimating {
    isAnimating = NO;
    
    [self.layer removeAllAnimations];
    self.hidden = YES;
}

@end
