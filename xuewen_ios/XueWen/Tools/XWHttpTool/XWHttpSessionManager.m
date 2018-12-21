//
//  XWHttpSessionManager.m
//  XueWen
//
//  Created by ShaJin on 2017/12/12.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "XWHttpSessionManager.h"
#import "NSString+AES128.h"

@implementation XWHttpSessionManager
#pragma mark- Cache
/** 获取本地缓存 */
+ (void)loadCacheDataWithURL:(NSString *)url completeBlock:(CompleteBlock)completeBlock{

}

- (void)saveCacheDataWithURL:(NSString *)url response:(NSHTTPURLResponse *)response responseObject:(NSDictionary *)responseObject{
    NSError *error;
    NSString *path = @"/Users/apple/Desktop/Test";
    NSString *namePath = [NSString stringWithFormat:@"%@/%ld",path,url.hash];
    NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
    [data writeToFile:namePath atomically:YES];
    
}

#pragma mark- Response
/** 返回数据统一处理 */
- (void)handleResponse:(NSHTTPURLResponse *)response responseObject:(id)responseObject error:(NSError *)error completionBlock:(CompleteBlock)completeBlock extra:(ExtraParameters)extraParamters{
    
    NSInteger statusCode = response.statusCode;
    if (statusCode < 200 && error) { // 通常情况下状态码不会小于200
        [MBProgressHUD showErrorMessage:error.localizedDescription];
        if (extraParamters & kShowProgress) {
            [MBProgressHUD hideHUD];
        }
    }else{
        if (extraParamters & kShowProgress) {
            [MBProgressHUD hideHUD];
        }
        
        if (completeBlock) {
            completeBlock(response.statusCode,responseObject,error);
        }
    }
}

#pragma mark- 网络请求
/** GET请求 */
+ (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters completeBlock:(CompleteBlock)completeBlock{
    NSArray *keys = [parameters allKeys];
    NSMutableString *mStr = [NSMutableString stringWithString:URLString];
    // 删除结尾的@“/”
    while ([mStr hasSuffix:@"/"]) {
        [mStr deleteCharactersInRange:NSMakeRange(mStr.length - 1, 1)];
    }
    // 拼接参数
    [mStr appendFormat:@"%@",(keys.count > 0) ? @"?":@""];
    
    for (int i = 0; i < keys.count; i++) {
        NSString *key = keys[i];
        [mStr appendFormat:@"%@=%@%@",key,parameters[key],(i == keys.count - 1)?@"":@"&"];
    }
    return [[XWHttpSessionManager manager] dataTaskWithHTTPMethod:Get URLString:mStr parameters:nil extra:extraParamters completeBlock:completeBlock];
}

/** POST请求 */
+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters completeBlock:(CompleteBlock)completeBlock{
    return [[XWHttpSessionManager manager] dataTaskWithHTTPMethod:Post URLString:URLString parameters:parameters extra:extraParamters completeBlock:completeBlock];
}

/** PUT请求 */
+ (NSURLSessionDataTask *)PUT:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters completeBlock:(CompleteBlock)completeBlock{
    return [[XWHttpSessionManager manager] dataTaskWithHTTPMethod:Put URLString:URLString parameters:parameters extra:extraParamters completeBlock:completeBlock];
}

/** DELETE请求 */
+ (NSURLSessionDataTask *)DELETE:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters completeBlock:(CompleteBlock)completeBlock{
    return [[XWHttpSessionManager manager] dataTaskWithHTTPMethod:Delete URLString:URLString parameters:parameters extra:extraParamters completeBlock:completeBlock];
}

/** POST请求 登录时候使用*/
- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters completeBlock:(CompleteBlock)completeBlock{
    return [self dataTaskWithHTTPMethod:Post URLString:URLString parameters:parameters extra:extraParamters completeBlock:completeBlock];
}

/** 发起请求 */
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters extra:(ExtraParameters)extraParamters completeBlock:(CompleteBlock)completeBlock{
    
    NSTimeInterval time = [NSDate date].timeIntervalSince1970;
    // 菊花器
    if (extraParamters & kShowProgress) {
        [MBProgressHUD showActivityMessageInWindow:@"加载中..."];
    }
    NSMutableString *mStr = [NSMutableString stringWithString:URLString];
    // 删除结尾的@“/”
    while ([mStr hasSuffix:@"/"]) {
        [mStr deleteCharactersInRange:NSMakeRange(mStr.length - 1, 1)];
    }
    NSLog(@"url = %@",URLString);
    if (extraParamters & kPrintParamters) {
        for (NSString *key in [parameters allKeys]) {
            NSLog(@"key = %@ value = %@",key,parameters[key]);
        }
    }
    // url编码防止url中出现汉字
    NSString *url = [mStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:url relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
            if (completeBlock) {
                completeBlock(-1,nil,serializationError);
            }
        });
        return nil;
    }
    __block NSURLSessionDataTask *dataTask = nil;
    WeakSelf;
    dataTask = [self dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (extraParamters & kShowRequestTime) {
            NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
            NSLog(@"url = %@ time:%f",URLString,currentTime - time);
        }
        if (extraParamters & kPrintResponse) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"statusCode = %ld\n responseJson = %@\n error = %@ ",(long)httpResponse.statusCode,responseObject,error);
        }
        [weakSelf handleResponse:(NSHTTPURLResponse *)response responseObject:responseObject error:error completionBlock:completeBlock extra:(ExtraParameters)extraParamters];
    }];
    [dataTask resume];
    return dataTask;
}
#pragma mark- 初始化
// 直接用alloc init 或 new出来的manager不带token，登录时使用。登录后的请求一律用[XWHttpSessionManager manager]方式获取manager对象
+ (instancetype)manager{
    XWHttpSessionManager *manager = [XWHttpSessionManager new];
    [manager.requestSerializer setValue:[XWInstance shareInstance].accessToken forHTTPHeaderField:@"token"];
    return manager;
}

- (instancetype)init{
    if (self = [super initWithBaseURL:nil]) {
        // 设置请求格式 为JSON
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置返回数据格式 为JSON
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        // 请求超时时间是10秒
        self.requestSerializer.timeoutInterval = 10;
        //过滤delete，让delete请求类似post一样处理参数(body)
        self.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"GET，HEAD"]];
        // 设置请求头参数
        XWInstance *instance = [XWInstance shareInstance];
        NSInteger currentTime = [getCurrentTime(13) integerValue];
        NSInteger count = arc4random();
        NSInteger all = currentTime * count;
        NSString *time = [NSString stringWithFormat:@"%ld", all];
        NSString *sign = [NSString encryptWithAppType:instance.general.appType did:instance.general.deviceID time:time];
        [self.requestSerializer setValue:sign forHTTPHeaderField:@"sign"];
        [self.requestSerializer setValue:instance.general.appType forHTTPHeaderField:@"type"];
        [self.requestSerializer setValue:instance.general.deviceID forHTTPHeaderField:@"did"];
        [self.requestSerializer setValue:instance.general.deviceOs forHTTPHeaderField:@"os"];
        [self.requestSerializer setValue:instance.general.deviceType forHTTPHeaderField:@"model"];
        [self.requestSerializer setValue:time forHTTPHeaderField:@"time"];
        [self.requestSerializer setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"version"];
    }
    return self;
}

- (void)dealloc{
    NSLog(@"URL:%@ DEALLOC",self.baseURL);
}
@end
