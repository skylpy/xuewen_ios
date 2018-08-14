//
//  TransactionModel.h
//  XueWen
//
//  Created by ShaJin on 2017/12/5.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionModel : NSObject
/*
 "order_id":"20171204175656811984",
 "type":1,
 "body":"购买[老板如何提炼与塑造自己特色的企业文化]",
 "price":88,
 "create_time":1512381417,
 "pay_type":0
 */
/** 订单编号 */
@property (nonatomic, strong) NSString *orderID;
/** 订单类型（0充值1消费） */
@property (nonatomic, assign) NSInteger type;
/** 订单标题 */
@property (nonatomic, strong) NSString *title;
/** 订单金额 */
@property (nonatomic, strong) NSString *price;
/** 订单时间 */
@property (nonatomic, assign) NSTimeInterval creatTime;
@end
