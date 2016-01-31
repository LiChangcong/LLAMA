//
//  LLAUploadVideoObserverProtocol.h
//  LLama
//
//  Created by Live on 16/1/31.
//  Copyright © 2016年 heihei. All rights reserved.
//

/****
 
 先这样吧，后面再统一改
 
 ****/

#import <Foundation/Foundation.h>

@protocol LLAUploadVideoObserverProtocol <NSObject>

- (void) uploadVideoDidStart;

- (void) uploadVideoProgressChange:(CGFloat) progress;

- (void) uploadVideodidSuccess;

- (void) uploadVideoDidFailed;

@end
