//
//  XWMyPlanModel.h
//  XueWen
//
//  Created by aaron on 2018/7/29.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XWMyPlanRecordsModel;
@interface XWMyPlanModel : NSObject

@property (nonatomic,copy) NSString * todaylearningtime;
@property (nonatomic,copy) NSString * todaytestnum;
@property (nonatomic,copy) NSString * sumnotenum;
@property (nonatomic,copy) NSString * sumtestnum;
@property (nonatomic,copy) NSString * sumviewnum;
@property (nonatomic,copy) NSString * sumlearningtime;
@property (nonatomic,copy) NSArray <XWMyPlanRecordsModel *> * learning;

@end

@interface XWMyPlanRecordsModel : NSObject

@property (nonatomic,copy) NSString * date;
@property (nonatomic,copy) NSString * studyTime;

@end
