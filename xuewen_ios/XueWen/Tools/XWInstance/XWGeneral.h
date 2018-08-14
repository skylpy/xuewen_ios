//
//  XWGeneral.h
//  XueWen
//
//  Created by ShaJin on 2017/11/20.
//  Copyright © 2017年 ShaJin. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFNetworkReachabilityManager.h"
@interface XWGeneral : NSObject
/** App类型 */
@property (nonatomic, strong) NSString *appType;
/** 设备号（标识符） */
@property (nonatomic, strong) NSString *deviceID;
/** 操作系统版本 */
@property (nonatomic, strong) NSString *deviceOs;
/** 设备型号 */
@property (nonatomic, strong) NSString *deviceType;
/** 网络状态 */
@property (nonatomic, assign) AFNetworkReachabilityStatus networkType;
@end
