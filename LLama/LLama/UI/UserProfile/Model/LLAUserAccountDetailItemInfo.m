//
//  LLAUserAccountDetailItemInfo.m
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserAccountDetailItemInfo.h"

@implementation LLAUserAccountDetailItemInfo

+ (LLAUserAccountDetailItemInfo *) parseJsonWithDic:(NSDictionary *)data {
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:data error:nil];
}

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    
    return @{@"accountManaIdString":@"id",
             @"transactionType":@"type",
             @"accountManaContent":@"title",
             @"manaMoney":@"amount",
             @"manaTimeStamps":@"time",
             @"manaTimeString":@"time",
             };
}

+ (NSValueTransformer *) manaTimeStringJSONTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *value, BOOL *success, NSError *__autoreleasing *error) {
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value longLongValue]];
        NSDateFormatter *dateFormator = [[NSDateFormatter alloc] init];
        dateFormator.timeZone = [NSTimeZone localTimeZone];
        dateFormator.dateFormat = @"MM/dd/yyyy";
        
        return [dateFormator stringFromDate:date];
        
    }];
    
}

//
+ (NSString *) transactionDescFromType:(LLAUserAccounTransactionType )transactionType {
    
    NSString *tempString = nil;
    
    switch (transactionType) {
        case LLAUserAccounTransactionType_BalanceIncom:
            tempString = @"余额收入";
            break;
        case LLAUserAccounTransactionType_BalanceRefund:
            tempString = @"剧本退款";
            break;
        case LLAUserAccounTransactionType_BalancePay:
            tempString = @"余额支出";
            break;
        case LLAUserAccounTransactionType_AlipayPay:
            tempString = @"支付宝支付";
            break;
        case LLAUserAccounTransactionType_WeiXinPay:
            tempString = @"微信支付";
            break;
        case LLAUserAccounTransactionType_WithdrawCashBegin:
            tempString = @"提现处理中";
            break;
        case LLAUserAccounTransactionType_WithdrawCashSuccess:
            tempString = @"余额提现";
            break;
        default:
            tempString = @"未知操作";
            break;
    }
    
    
    return tempString;
}

@end
