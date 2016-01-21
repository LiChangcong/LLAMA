//
//  LLAUserProfileNavigationBar.m
//  LLama
//
//  Created by Live on 16/1/21.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserProfileNavigationBar.h"

@interface LLAUserProfileNavigationBar()
{
    UINavigationItem *navigationItem;
}

@end

@implementation LLAUserProfileNavigationBar

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        //remove bar backGround Cover
//        for (UIView *view in self.subviews) {
//            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
//                [view removeFromSuperview];
//            }
//        }
        
        [self setup];
        
    }
    
    return self;
}

- (void) setup {
    
    //set navigationBar Attribute
    
    [self setTranslucent:YES];
    self.barTintColor = [UIColor llaNavigationBarColor];
    self.tintColor = [UIColor whiteColor];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    

    navigationItem = [[UINavigationItem alloc] init];
    
    [self pushNavigationItem:navigationItem animated:NO];
    
}

#pragma mark - Setter

- (void) setTitle:(NSString *)title {
    navigationItem.title = title;
}

- (void) setTitleView:(UIView *)titleView {
    navigationItem.titleView = titleView;
}

- (void) setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void) setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems {
    navigationItem.leftBarButtonItems = leftBarButtonItems;
}

- (void) setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem {
    navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void) setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems {
    navigationItem.rightBarButtonItems = rightBarButtonItems;
}

#pragma mark - Public method

- (void) makeBackgroundClear:(BOOL)clear {
    
    if (clear){
        
        self.barTintColor = [UIColor clearColor];
        [self setBackgroundColor:[UIColor clearColor]];
        
        
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                [view setHidden:YES];
            }
        }

    }else{
        
        self.barTintColor = [UIColor llaNavigationBarColor];
        
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                [view setHidden:NO];
            }
        }
    }
}

@end
