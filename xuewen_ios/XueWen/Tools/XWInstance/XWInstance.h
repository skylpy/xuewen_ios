//
//  XWInstance.h
//  XueWen
//
//  Created by ShaJin on 2017/11/20.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWUserInfo.h"
#import "XWGeneral.h"
@class CourseLabelModel;
@interface XWInstance : NSObject
/** AccessToken，登陆后获取，登陆后必填参数 */
@property (nonatomic, strong) NSString     *accessToken;
/** 登陆账户信息 */
@property (nonatomic, strong) XWUserInfo   *userInfo;
/** 设备信息 */
@property (nonatomic, strong) XWGeneral    *general;
/** 课程标签列表 */
@property (nonatomic, strong) NSArray<CourseLabelModel *> *courseLabelList;
/** 服务器时间和本地时间的差值 单位：秒 */
@property (nonatomic, assign) NSInteger timeDiff;
/** 邀请链接 */
@property (nonatomic, strong) NSString *invitationURL;
/** url */
@property (nonatomic, strong) NSString *url;
/** 是否连接测试接口 */
@property (nonatomic, assign) BOOL isTest;
/** 获取唯一实例 */
+ (instancetype) shareInstance;
/** 注销登陆 */
- (void)logout;
@end
