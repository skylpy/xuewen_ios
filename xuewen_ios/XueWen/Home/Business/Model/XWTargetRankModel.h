//
//  XWTargetRankModel.h
//  XueWen
//
//  Created by Karron Su on 2018/7/29.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWTargetRankModel : NSObject

/** 用户id*/
@property (nonatomic, strong) NSString *userId;
/** 公司id*/
@property (nonatomic, strong) NSString *companyId;
/** 组织名称*/
@property (nonatomic, strong) NSString *departmentName;
/** 完成时间*/
@property (nonatomic, strong) NSString *finishTime;
/** 添加时间*/
@property (nonatomic, strong) NSString *createTime;
/** 全链接头像*/
@property (nonatomic, strong) NSString *pictureAll;
/** 姓名*/
@property (nonatomic, strong) NSString *name;
/** 进度值*/
@property (nonatomic, strong) NSString *schedule;
/** 计划名称*/
@property (nonatomic, strong) NSString *title;
/** 完成计划总条数*/
@property (nonatomic, strong) NSString *count;
/** 计划总条数*/
@property (nonatomic, strong) NSString *total;
/** 点赞数量*/
@property (nonatomic, strong) NSString *fabulous;
/** 完成率*/
@property (nonatomic, strong) NSString *completion;
/** 0未点赞 1已点赞*/
@property (nonatomic, strong) NSString *fabulousType;
/** 排名*/
@property (nonatomic, strong) NSString *ranking;
/** 性别*/
@property (nonatomic, strong) NSString *sex;


@end
