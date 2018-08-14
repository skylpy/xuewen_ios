//
//  ProjectModel.h
//  XueWen
//
//  Created by ShaJin on 2018/1/24.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CourseModel;
@interface ProjectModel : NSObject
/** 专题ID */
@property (nonatomic, strong) NSString *projectID;
/** 专题名称 */
@property (nonatomic, strong) NSString *projectName;
/** 专题介绍 */
@property (nonatomic, strong) NSString *introduction;
/** 专题封面 */
@property (nonatomic, strong) NSString *picture;
/** 专题价格 */
@property (nonatomic, strong) NSString *price;
/** 原价*/
@property (nonatomic, strong) NSString *originalPrice;
/** 是否已经购买 */
@property (nonatomic, assign) BOOL buy;
/** 子专题数组 */
@property (nonatomic, strong) NSArray<ProjectModel *> *projects;
/** 子课程数组 */
@property (nonatomic, strong) NSArray<CourseModel *> *courses;
@end
