//
//  XWExamHistoryModel.h
//  XueWen
//
//  Created by Karron Su on 2018/7/3.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWExamHistoryModel : NSObject

/** 历史最高分*/
@property (nonatomic, strong) NSString *topFraction;
/** 及格次数*/
@property (nonatomic, strong) NSString *passNum;
/** 正确率*/
@property (nonatomic, strong) NSString *accuracy;
/** 累计考试次数*/
@property (nonatomic, strong) NSString *testNum;
@property (nonatomic, strong) NSMutableArray *data;

@end

@interface XWHistoryInfoModel : NSObject

/** 考试时间*/
@property (nonatomic, strong) NSString *creatTime;
/** 考试分数*/
@property (nonatomic, strong) NSString *fraction;
/** 等级名称*/
@property (nonatomic, strong) NSString *rangeName;

@end

