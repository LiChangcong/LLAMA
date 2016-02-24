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
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value longLongValue]/1000];
        NSDateFormatter *dateFormator = [[NSDateFormatter alloc] init];
        dateFormator.timeZone = [NSTimeZone localTimeZone];
        dateFormator.dateFormat = @"MM/dd/yyyy";
        
        return [dateFormator stringFromDate:date];
        
    }];
    
}

+ (NSValueTransformer *) manaMoneyJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *value, BOOL *success, NSError *__autoreleasing *error) {
        return @(((float)value.integerValue) / 100);
    }];
}

/**
 *change type from enum
 *
 **/

+ (NSValueTransformer *)transactionTypeJSONTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        
        if ([value isKindOfClass:[NSString class]]) {
            
            NSString *typeString = (NSString *)value;
            
            if ([typeString isEqualToString:@"余额收入"]) {
                return @(LLAUserAccounTransactionType_BalanceIncom);
                
            }else if ([typeString isEqualToString:@"剧本退款"]) {
                return @(LLAUserAccounTransactionType_BalanceRefund);
                
            }else if ([typeString isEqualToString:@"余额支出"]) {
                return @(LLAUserAccounTransactionType_BalancePay);
                
            }else if ([typeString isEqualToString:@"支付宝支付"]) {
                return @(LLAUserAccounTransactionType_AlipayPay);
                
            }else if ([typeString isEqualToString:@"微信支付"]) {
                return @(LLAUserAccounTransactionType_WeiXinPay);
                
            }else if ([typeString isEqualToString:@"正在提现中"]) {
                return @(LLAUserAccounTransactionType_WithdrawCashBegin);
                
            }else if ([typeString isEqualToString:@"提现成功"]) {
                return @(LLAUserAccounTransactionType_WithdrawCashSuccess);
                
            }else{
                return nil;
            }
            
            
        }else{
            return value;
        }
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
