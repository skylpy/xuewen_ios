//
//  XWCountPlayTimeModel.h
//  XueWen
//
//  Created by Karron Su on 2018/7/28.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWCountPlayTimeModel : NSObject

/** 总赞*/
@property (nonatomic, strong) NSString *praise;
/** 总时间*/
@property (nonatomic, strong) NSString *totalTime;
/** 部门*/
@property (nonatomic, strong) NSString *departmentName;
/** 用户id*/
@property (nonatomic, strong) NSString *userId;
/** 姓名*/
@property (nonatomic, strong) NSString *name;
/** 岗位*/
@property (nonatomic, strong) NSString *post;
/** 头像*/
@property (nonatomic, strong) NSString *coverPictureAll;
/** 0未点赞 1已点赞*/
@property (nonatomic, strong) NSString *fabulousType;
/** 排名*/
@property (nonatomic, strong) NSString *ranking;

@end
