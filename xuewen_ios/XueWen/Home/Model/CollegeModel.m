//
//  CollegeModel.m
//  XueWen
//
//  Created by ShaJin on 2018/1/19.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "CollegeModel.h"
/**
 "id":3,
 "company_id":37,
 "position":0,
 "type":0,
 "user_id":55,
 "title":"测试一个模块2",
 "cover":"132456",
 "course_ids":"75,85",
 "type_val":11,
 "create_time":1516258374,
 "course_name":null,
 "label_name":"总监",
 "cover_all":"http://xuewen-oss.oss-cn-shenzhen.aliyuncs.com/132456",
 */
///** 公司ID */
//@property(nonatomic,strong)NSString *companyID;
///** 待用（现在用不到） */
//@property(nonatomic,strong)NSString *position;
///** 关联值（0标签 1课程） */
//@property(nonatomic,strong)NSString *type;
///** 用户ID */
//@property(nonatomic,strong)NSString *userID;
///** 标题 */
//@property(nonatomic,strong)NSString *title;
///** 标签ID/课程ID（根据type） */
//@property(nonatomic,strong)NSString *typeID;
///** 封面 */
//@property(nonatomic,strong)NSString *coverImage;
///** 课程 */
//@property(nonatomic,strong)NSArray<CourseModel *> *courses;
@implementation CollegeModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"companyID"   : @"company_id",
             @"userID"      : @"user_id",
             @"typeID"      : @"type_val",
             @"coverImage"  : @"cover_all",
             @"courses"     : @"courses_info"
             };
}

+ (NSDictionary *)objectClassInArray{
    return @{@"courses" : @"CourseModel"};
}
@end
