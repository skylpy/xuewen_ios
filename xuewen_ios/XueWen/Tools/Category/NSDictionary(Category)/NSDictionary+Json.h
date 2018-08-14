//
//  NSDictionary+Json.h
//  happyselling
//
//  Created by ShaJin on 2017/10/17.
//  Copyright © 2017年 iOS李鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Json)
/**
 json字符串转换成字典
 
 @param jsonString json字符串
 @return 字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
