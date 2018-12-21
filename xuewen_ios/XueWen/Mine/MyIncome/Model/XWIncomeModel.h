//
//  XWIncomeModel.h
//  XueWen
//
//  Created by Karron Su on 2018/9/11.
//  Copyright © 2018年 KarronSu. All rights reserved.
//
//
// 红包收益与佣金收益Model

#import <Foundation/Foundation.h>

@interface XWIncomeModel : NSObject

/** 用户id*/
@property (nonatomic, strong) NSString *userId;
/** 用户上级id*/
@property (nonatomic, strong) NSString *userPid;
/** 时间*/
@property (nonatomic, strong) NSString *createTime;
/** 全链接头像*/
@property (nonatomic, strong) NSString *pictureAll;
/** 红包金额*/
@property (nonatomic, strong) NSString *price;
/** 性别 0女 1男*/
@property (nonatomic, strong) NSString *sex;
/** 手机号*/
@property (nonatomic, strong) NSString *phone;


/** 消费金额*/
@property (nonatomic, strong) NSString *orderPrice;
/** 佣金*/
@property (nonatomic, strong) NSString *commissionPrice;


@end
