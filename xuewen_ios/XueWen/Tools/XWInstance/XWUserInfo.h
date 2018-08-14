//
//  XWUserInfo.h
//  XueWen
//
//  Created by ShaJin on 2017/11/20.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWCompanyModel.h"
#import "CouponModel.h"
@interface XWUserInfo : NSObject<NSCoding>
/** 用户ID */
@property (nonatomic, strong) NSString *oid;
/** 角色ID */
@property (nonatomic, strong) NSString *role_id;
/** 部门ID */
@property (nonatomic, strong) NSString *department_id;
/** 账号 */
@property (nonatomic, strong) NSString *account;
/** 公司ID */
@property (nonatomic, strong) NSString *company_id;
/** 用户标签ID */
@property (nonatomic, strong) NSString *label_id;
/** 账号状态 1启用，2禁用 */
@property (nonatomic, strong) NSString *status;
/** 上级ID */
@property (nonatomic, strong) NSString *pid;
/** 金钱 */
@property (nonatomic, strong) NSString *gold;
/** 优惠券总金额*/
@property (nonatomic, strong) NSString *user_coupon;
/** 创建时间 */
@property (nonatomic, strong) NSString *create_time;
/** 手机号 */
@property (nonatomic, strong) NSString *phone;
/** 姓名 */
@property (nonatomic, strong) NSString *name;
/** 头像 */
@property (nonatomic, strong) NSString *picture;
/** 昵称 */
@property (nonatomic, strong) NSString *nick_name;
/** 性别 0女1男 */
@property (nonatomic, strong) NSString *sex;
/** 生日时间 */
@property (nonatomic, strong) NSString *birthday;
/** 省ID */
@property (nonatomic, strong) NSString *province;
/** 市ID */
@property (nonatomic, strong) NSString *area;
/** 区ID */
@property (nonatomic, strong) NSString *county;
/** 地址 */
@property (nonatomic, strong) NSString *region_name;
/** 上次登陆时间 */
@property (nonatomic, strong) NSString *last_login_time;
/** 个人简介 */
@property (nonatomic, strong) NSString *introduction;
/** 公司信息 */
@property (nonatomic, strong) XWCompanyModel *company;
/** 优惠券列表 */
@property (nonatomic, strong) NSArray<CouponModel *> *coupons;
/** 是否是个人用户 */
@property (nonatomic, assign) BOOL personal;
@end
