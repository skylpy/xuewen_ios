//
//  XWIAPManager.h
//  XueWen
//
//  Created by aaron on 2018/11/12.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XWIAPManagerDelegate <NSObject>

@optional
//接受到商品
- (void)receiveProduct:(SKProduct *)product;
//支付成功
- (void)successedWithReceipt:(NSData *)transactionReceipt;
//支付失败
- (void)failedPurchaseWithError:(NSString *)errorDescripiton;


@end
@interface XWIAPManager : NSObject

@property (nonatomic, weak)id<XWIAPManagerDelegate> delegate;

//单例
+ (instancetype)sharedManager;
//用商品的ID请求苹果服务器（productId 是在appstore connect 上获取的）
- (BOOL)requestProductWithId:(NSString *)productId;
//购买的商品
- (BOOL)purchaseProduct:(SKProduct *)skProduct;
//恢复购买
- (BOOL)restorePurchase;
//刷新Receipt
- (void)refreshReceipt;
//完成订单
- (void)finishTransaction;

@end

@interface XWIAPModel : NSObject

@property (nonatomic,copy) NSString * user_gold;


//在支付成功之后通知服务器验签
+ (void)purchaseReceipt:(NSString *)receipt
              companyId:(NSString *)companyId
                success:(void(^)(NSString * gold))success
                failure:(void(^)(NSString *error))failure ;

@end

NS_ASSUME_NONNULL_END
