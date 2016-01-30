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

#import "AlipayOrder.h"
#import "DataSigner.h"

static NSString *const weChatPaySignKey = @"d1e3ef75d4de42db498bb9e103694590";
static NSString *const weChatAppId = @"wxae2f98ae451293df";
static NSString *const weChatPartnerId = @"1299537201";

static NSString *weChatPackage = @"Sign=WXPay";

//alipay
static NSString *const alipayPartner = @"2088121476910926";
static NSString *const alipaySeller = @"2547671155@qq.com";

static NSString *const alipayPrivateKey = @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBALp5fcXlDhHdRHgV8D1DGa+x2xiIlikBLBu7BkfxWSa0O7CIMju2HAWzF6M/XWvjwciTyTiaGnKhlRAaVmlO5LY50Ru0DrNCYGNUMzBmDSiAlseoHYSuUNj0CCss37OunrxVMrStPrO4f+took66ctZv9SABjGPbrxE8/5m6rMnXAgMBAAECgYAmRFJMLyJBBkBLyGzBlaiKxpvon/b4uTXdBvdWAjBCYhAxvPFaEZgUj1kVdiZswpN83t8XT4CH76LQaCc9eyQx6zecmwTfmYTlvtq0e6S1hD8tOrH4dAskrN+6KtQlKBVriaWH9B0yU39q9wuQqVCpblMgB7QAMQjIN9AXDYPSUQJBAOihniufO8AMj6uKNpEJ+A5PUhCAlxzLay8QGHc1b/ufJijpSndwmwlpttaXOvtTNgRjAsYSNadtsVGw1hel2a8CQQDNNOZO06eVbdLJtw4nmeKh96MWiKJN5eJDM12tasOvcmmEEwVVBPcwOWRbtSjISs10+4Dm9juVwKMU+BnacKRZAkAAybtdbnanWeOKszcoGp6Kfd5LTAQ3BsFgMW/Dx5yPf6SDcvbbnLgJuh/ybiS3ATsnnKY/wYQJAygcnLq87cTlAkB8mR8yQ7+gstNnWXgFwaFjeQqUlxf9tpTA+wJpVsdE03KQGECHlAFHTcHLEV+W5hyEaGWnV2Fsl1AuXkrMYNLZAkBDCVFrBNTStbo0FXMbsm24T6joa9xVe+WqUjeVtQc3qvFOqwYlP02Obr9aX7LF9WEni137DsTy2ILnPAOmOi2g";

static NSString *const alipayPublicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB";

static

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
        AlipayOrder *order  = [AlipayOrder new] ;
        
        order.partner = alipayPartner;
        order.seller = alipaySeller;
        order.tradeNO = [data valueForKey:@"out_trade_no"];
        order.productName = [data valueForKey:@"subject"];
        order.amount = [NSString stringWithFormat:@"%.2f",[[data valueForKey:@"total_fee"] floatValue]];
        order.notifyURL = [data valueForKey:@"notify_url"];
        
        order.service = @"mobile.securitypay.pay"; //接口名称, 固定值, 不可空
        order.paymentType = @"1"; //支付类型 默认值为1(商品购买), 不可空
        order.inputCharset = @"utf-8"; //参数编码字符集: 商户网站使用的编码格式, 固定为utf-8, 不可空
        order.itBPay = @"30m";
        
        //
        NSString *appScheme = @"LLama";
        
        NSString *orderSpec = [order description];
        id<DataSigner> signer = CreateRSADataSigner(alipayPrivateKey);
        NSString *signedString = [signer signString:orderSpec];
        
        NSString *orderString = nil;
        if (signedString != nil) {
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           orderSpec, signedString, @"RSA"];
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                
                BOOL success = NO;
                if ([[resultDic valueForKey:@"resultStatus"] integerValue] == 9000) {
                    success = YES;
                }else {
                    success = NO;
                }
                if (self.responseBlock) {
                    self.responseBlock(success,nil);
                    self.responseBlock = nil;
                }
            }];
        
        }
        
    
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
