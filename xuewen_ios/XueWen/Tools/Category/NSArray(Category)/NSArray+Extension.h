//
//  NSArray+Extension.h
//  XueWen
//
//  Created by ShaJin on 2017/11/23.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extension)
/** json字符串转换成数组 */
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString;
@end
