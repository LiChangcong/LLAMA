//
//  main.m
//  LLama
//
//  Created by tommin on 15/12/7.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLADelegate.h"
#import "LLAApplication.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv,NSStringFromClass([LLAApplication class]), NSStringFromClass([LLADelegate class]));
    }
}
