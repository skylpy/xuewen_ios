//
//  XWStaffInfoModel.h
//  XueWen
//
//  Created by Karron Su on 2018/12/13.
//  Copyright © 2018 KarronSu. All rights reserved.
//

// 员工详情Model
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWStaffInfoModel : NSObject

/** 用户id*/
@property (nonatomic, strong) NSString *userId;
/** 公司id*/
@property (nonatomic, strong) NSString *company_id;
/** 头像*/
@property (nonatomic, strong) NSString *picture_all;
/** 姓名*/
@property (nonatomic, strong) NSString *name;
/** 昵称(账号)*/
@property (nonatomic, strong) NSString *nick_name;
/** 职位*/
@property (nonatomic, strong) NSString *post;
/** 联系方式*/
@property (nonatomic, strong) NSString *phone;
/** 部门*/
@property (nonatomic, strong) NSString *department_name;
/** 部门id*/
@property (nonatomic, strong) NSString *department_id;
/** 性别*/
@property (nonatomic, strong) NSString *sex;
/** 推荐课程*/
@property (nonatomic, strong) NSString *label_name;
/** 推荐课程id*/
@property (nonatomic, strong) NSString *lable_id;

@end

NS_ASSUME_NONNULL_END
