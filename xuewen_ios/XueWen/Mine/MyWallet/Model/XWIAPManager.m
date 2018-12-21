//
//  XWIAPManager.m
//  XueWen
//
//  Created by aaron on 2018/11/12.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWIAPManager.h"
#import "XWHttpBaseModel.h"

@interface XWIAPManager() <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    SKProduct *myProduct;
}

@property (nonatomic, strong) SKPaymentTransaction *currentTransaction;

@end
@implementation XWIAPManager


#pragma mark - ================ Singleton =================

+ (instancetype)sharedManager {
    
    static XWIAPManager *iapManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        iapManager = [XWIAPManager new];
    });
    
    return iapManager;
}

#pragma mark - ================ Public Methods =================

#pragma mark ==== 请求商品
- (BOOL)requestProductWithId:(NSString *)productId {
    
    if (productId.length > 0) {
        NSLog(@"请求商品: %@", productId);
        SKProductsRequest *productRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:[NSSet setWithObject:productId]];
        productRequest.delegate = self;
        [productRequest start];
        return YES;
    } else {
        NSLog(@"商品ID为空");
    }
    return NO;
}

#pragma mark ==== 购买商品
- (BOOL)purchaseProduct:(SKProduct *)skProduct {
    
    if (skProduct != nil) {
        if ([SKPaymentQueue canMakePayments]) {
            SKPayment *payment = [SKPayment paymentWithProduct:skProduct];
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            return YES;
        } else {
            NSLog(@"失败，用户禁止应用内付费购买.");
        }
    }
    return NO;
}

#pragma mark ==== 商品恢复
- (BOOL)restorePurchase {
    
    if ([SKPaymentQueue canMakePayments]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        return YES;
    } else {
        NSLog(@"失败,用户禁止应用内付费购买.");
    }
    return NO;
}

#pragma mark ==== 结束这笔交易
- (void)finishTransaction {
    [[SKPaymentQueue defaultQueue] finishTransaction:self.currentTransaction];
}



#pragma mark ====  刷新凭证
- (void)refreshReceipt {
    SKReceiptRefreshRequest *request = [[SKReceiptRefreshRequest alloc] init];
    request.delegate = self;
    [request start];
}

#pragma mark - ================ SKRequestDelegate =================

- (void)requestDidFinish:(SKRequest *)request {
    
    if ([request isKindOfClass:[SKReceiptRefreshRequest class]]) {
        NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
        [_delegate successedWithReceipt:receiptData];
    }
}


#pragma mark - ================ SKProductsRequest Delegate =================
//接收商品
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSArray *myProductArray = response.products;
    if (myProductArray.count > 0) {
        myProduct = [myProductArray objectAtIndex:0];
        [_delegate receiveProduct:myProduct];
    } else {
        NSLog(@"无法获取产品信息，购买失败。");
        [_delegate receiveProduct:myProduct];
    }
}

#pragma mark - ================ SKPaymentTransactionObserver Delegate =================
//支付状态处理
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing: //商品添加进列表
                NSLog(@"商品:%@被添加进购买列表",myProduct.localizedTitle);
                break;
            case SKPaymentTransactionStatePurchased://交易成功
                //内购沙盒测试账号在支付成功后，再次购买相同 ID 的物品，会提示如下内容的弹窗。您已购买此 App 内购买项目。此项目将免费恢复。
                
                [self completeTransaction:transaction];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                NSLog(@"交易失败");
                [self failedTransaction:transaction];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://已购买过该商品
                NSLog(@"已购买过该商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred://交易延迟
                NSLog(@"交易延迟");
                [[SKPaymentQueue defaultQueue] removeTransactionObserver:transaction];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

#pragma mark - ================ Private Methods =================
#pragma mark -- 支付成功
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    [_delegate successedWithReceipt:receiptData];
    self.currentTransaction = transaction;
//    [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:NO];
}

#pragma mark -- 支付失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    [MBProgressHUD hideHUD];
    if (transaction.error.code != SKErrorPaymentCancelled && transaction.error.code != SKErrorUnknown) {
        [_delegate failedPurchaseWithError:transaction.error.localizedDescription];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    self.currentTransaction = transaction;
}

#pragma mark -- 本地验签
- (void)verifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)flag{
    //交易验证
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    
    if(!receipt){
        // 交易凭证为空验证失败
//        [self handleActionWithType:SIAPPurchVerFailed data:nil];
        return;
    }
    // 购买成功将交易凭证发送给服务端进行再次校验
//    [self handleActionWithType:SIAPPurchSuccess data:receipt];
    
    NSError *error;
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0]
                                      };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    
    if (!requestData) { // 交易凭证为空验证失败
//        [self handleActionWithType:SIAPPurchVerFailed data:nil];
        return;
    }
    
    //In the test environment, use https://sandbox.itunes.apple.com/verifyReceipt
    //In the real environment, use https://buy.itunes.apple.com/verifyReceipt
    
    NSString *serverString = @"https://sandbox.itunes.apple.com/verifyReceipt";//@"https://buy.itunes.apple.com/verifyReceipt";
//    if (flag) {
//        serverString = @"https://sandbox.itunes.apple.com/verifyReceipt";
//    }
    NSURL *storeURL = [NSURL URLWithString:serverString];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   
                                   // 无法连接服务器,购买校验失败
//                                   [self handleActionWithType:SIAPPurchVerFailed data:nil];
                               } else {
                                   NSError *error;
                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   if (!jsonResponse) {
                                       // 苹果服务器校验数据返回为空校验失败
//                                       [self handleActionWithType:SIAPPurchVerFailed data:nil];
                                       
                                   }
                                   
                                   // 先验证正式服务器,如果正式服务器返回21007再去苹果测试服务器验证,沙盒测试环境苹果用的是测试服务器
                                   NSString *status = [NSString stringWithFormat:@"%@",jsonResponse[@"status"]];
                                   if (status && [status isEqualToString:@"21007"]) {
                                       
                                       [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:YES];
                                   }else if(status && [status isEqualToString:@"0"]){
//                                       [self handleActionWithType:SIAPPurchVerSuccess data:nil];
                                       
                                   }
                                   NSLog(@"----验证结果 %@",jsonResponse);
#if DEBUG
//                                   NSLog(@"----验证结果 %@",jsonResponse);
#endif
                               }
                           }];
    
    
    // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}


@end

@implementation XWIAPModel

//在支付成功之后通知服务器验签
+ (void)purchaseReceipt:(NSString *)receipt
              companyId:(NSString *)companyId
                success:(void(^)(NSString * gold))success
                failure:(void(^)(NSString *error))failure{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:receipt forKey:@"receipt-data"];
    [dic setValue:companyId forKey:@"company_id"];
  
    [XWHttpBaseModel BPOST:BASE_URL(CheckApplePay) parameters:dic extra:kShowProgress success:^(XWHttpBaseModel *model) {
        NSString * gd = model.data[@"user_gold"];
        !success?:success(gd);
    } failure:^(NSString *error) {
        
    }];
}

@end
