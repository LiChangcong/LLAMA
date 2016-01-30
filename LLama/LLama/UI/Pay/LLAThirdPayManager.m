//
//  LLAThirdPayManager.m
//  LLama
//
//  Created by Live on 16/1/30.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAThirdPayManager.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import <CommonCrypto/CommonDigest.h>

static NSString *weChatPaySignKey = @"d1e3ef75d4de42db498bb9e103694590";
static NSString *weChatAppId = @"wxae2f98ae451293df";
static NSString *weChatPartnerId = @"1299537201";

static NSString *weChatPackage = @"Sign=WXPay";

@interface LLAThirdPayManager()

@property(nonatomic , copy) LLAThirdPayResponseBlock responseBlock;

@end

@implementation LLAThirdPayManager

+ (instancetype) shareManager {
    
    static LLAThirdPayManager *manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    
    return manager;
    
}

- (void) payWithPayType:(LLAThirdPayType)payType data:(NSDictionary *)data response:(LLAThirdPayResponseBlock)response {
    
    if (response) {
        self.responseBlock = response;
    }
    
    if (payType == LLAThirdPayType_AliPay) {
        
        //alipay
    
    }else if(payType == LLAThirdPayType_WeChat) {
        
        PayReq* req             = [[PayReq alloc] init];
        //req.openID              = weChatAppId;
        req.partnerId           = weChatPartnerId;
        req.prepayId            = [data valueForKey:@"prepay_id"];
        req.nonceStr            = [data valueForKey:@"nonce_str"];
        req.sign                = [self weChatPay_signatureWithDict:data];
        req.timeStamp           = [[data valueForKey:@"timeStamp"] intValue];
        req.package             = weChatPackage;
        
        [WXApi sendReq:req];
    }
    
}

- (void) payResponseFromThirdPartyWithType:(LLAThirdPayType) payType
                              responseCode:(LLAThirdPayResponseStatus) code
                                     error:(NSError *) error {
    if (self.responseBlock) {
        self.responseBlock(code,error);
        self.responseBlock = nil;
    }
}

#pragma mark - WeChat Local Sign

- (NSString *)weChatPay_signatureWithDict:(NSDictionary *)dict
{
    NSString *signature = [[NSString alloc]init];
    signature = [NSString stringWithFormat:@"%@&%@&%@&%@&%@&%@&%@",
                 [NSString stringWithFormat:@"appid=%@",weChatAppId],
                 [NSString stringWithFormat:@"noncestr=%@",[dict valueForKey:@"nonce_str"]],
                 [NSString stringWithFormat:@"package=%@",weChatPackage],
                 [NSString stringWithFormat:@"partnerid=%@",weChatPartnerId],
                 [NSString stringWithFormat:@"prepayid=%@",[dict valueForKey:@"prepay_id"]],
                 [NSString stringWithFormat:@"timestamp=%@",[dict valueForKey:@"timeStamp"]],
                 [NSString stringWithFormat:@"key=%@",weChatPaySignKey]];

    return [[[self class] md5HexDigest:signature] uppercaseString];
}

+ (NSString *)md5HexDigest:(NSString*)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr,(CC_LONG)input.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

@end
