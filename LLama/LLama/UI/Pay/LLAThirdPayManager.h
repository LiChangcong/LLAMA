//
//  LLAThirdPayManager.h
//  LLama
//
//  Created by Live on 16/1/30.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,LLAThirdPayType) {
    LLAThirdPayType_Unknow = 0,
    LLAThirdPayType_AliPay = 1,
    LLAThirdPayType_WeChat = 2,
    
};

typedef NS_ENUM(NSInteger,LLAThirdPayResponseStatus) {
    LLAThirdPayResponseStatus_Failed = 0,
    LLAThirdPayResponseStatus_Success = 1,
};

typedef void(^LLAThirdPayResponseBlock)(LLAThirdPayResponseStatus code,NSError *error);

@interface LLAThirdPayManager : NSObject

+ (instancetype) shareManager;

- (void) payWithPayType:(LLAThirdPayType) payType data:(NSDictionary *) data response:(LLAThirdPayResponseBlock) response;

- (void) payResponseFromThirdPartyWithType:(LLAThirdPayType) payType
                              responseCode:(LLAThirdPayResponseStatus) code
                                     error:(NSError *) error;

@end
