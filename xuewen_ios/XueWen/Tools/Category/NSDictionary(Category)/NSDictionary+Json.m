//
//  NSDictionary+Json.m
//  happyselling
//
//  Created by ShaJin on 2017/10/17.
//  Copyright © 2017年 iOS李鹏. All rights reserved.
//

#import "NSDictionary+Json.h"

@implementation NSDictionary (Json)
/**
 json字符串转换成字典
 
 @param jsonString json字符串
 @return 字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
