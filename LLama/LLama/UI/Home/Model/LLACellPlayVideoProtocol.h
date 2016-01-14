//
//  LLACellPlayVideoProtocol.h
//  LLama
//
//  Created by Live on 16/1/14.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLAVideoPlayerView.h"

@protocol LLACellPlayVideoProtocol <NSObject>

@required

@property(nonatomic , readonly) LLAVideoPlayerView *videoPlayerView;

@end
