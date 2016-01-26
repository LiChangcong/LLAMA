//
//  LLAUserAccountDetailItemInfo.h
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"

typedef NS_ENUM(NSInteger,LLAUserAccounTransactionType) {
    //余额收入
    LLAUserAccounTransactionType_BalanceIncom = 0,
    //剧本退款
    LLAUserAccounTransactionType_BalanceRefund =1,
    //余额支出
    LLAUserAccounTransactionType_BalancePay = 2,
    //支付宝支付
    LLAUserAccounTransactionType_AlipayPay = 3,
    //微信支付
    LLAUserAccounTransactionType_WeiXinPay = 4,
    //提现到支付宝，提现中
    LLAUserAccounTransactionType_WithdrawCashBegin = 5,
    //提现到支付宝，成功
    LLAUserAccounTransactionType_WithdrawCashSuccess = 6,
};

@interface LLAUserAccountDetailItemInfo : MTLModel<MTLJSONSerializing>

@property(nonatomic , copy) NSString *accountManaIdString;

@property(nonatomic , assign) LLAUserAccounTransactionType transactionType;

@property(nonatomic , copy) NSString *accountManaContent;

@property(nonatomic , assign) CGFloat manaMoney;

@property(nonatomic , assign) long long manaTimeStamps;

@property(nonatomic , copy) NSString *manaTimeString;

+ (LLAUserAccountDetailItemInfo *) parseJsonWithDic:(NSDictionary *) data;

+ (NSString *) transactionDescFromType:(LLAUserAccounTransactionType ) transactionType;

@end
