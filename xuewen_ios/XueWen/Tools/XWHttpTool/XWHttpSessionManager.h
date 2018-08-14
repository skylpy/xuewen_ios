//
//  XWHttpSessionManager.h
//  XueWen
//
//  Created by ShaJin on 2017/12/12.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
// 额外参数 参数用|连接 没有填0
typedef NS_OPTIONS(NSUInteger, ExtraParameters) {
    kPrintParamters     = 1 << 0,   // 打印参数
    kPrintResponse      = 1 << 1,   // 打印返回数据
    kShowProgress       = 1 << 2,   // 显示菊花器
    kShowRequestTime    = 1 << 3,   // 打印请求耗时
    kShowRetryView      = 1 << 4,   // 连接失败显示重试界面
    kNeedCache          = 1 << 5,   // 是否需要缓存，需要缓存的请求会在本地保存一份副本，再次请求时会先返回本地保存的副本，然后新数据回来后再刷新界面
};
// 回调block
typedef void (^CompleteBlock)(NSInteger statusCode, id responseJson ,NSError *error);
@interface XWHttpSessionManager : AFHTTPSessionManager
/** GET请求 */
+ (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters completeBlock:(CompleteBlock)completeBlock;
/** POST请求 */
+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters completeBlock:(CompleteBlock)completeBlock;
/** PUT请求 */
+ (NSURLSessionDataTask *)PUT:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters completeBlock:(CompleteBlock)completeBlock;
/** DELETE请求 */
+ (NSURLSessionDataTask *)DELETE:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters completeBlock:(CompleteBlock)completeBlock;
/** POST请求 登录时候使用*/
- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters completeBlock:(CompleteBlock)completeBlock;
@end
