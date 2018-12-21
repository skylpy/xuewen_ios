//
//  XWCollegeEduView.h
//  XueWen
//
//  Created by aaron on 2018/10/18.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "EScrollPageView.h"
#import "XWHttpBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XWCollegeEduView : EScrollPageItemBaseView

//@property(nonatomic,retain)UITableView *tableView;

- (instancetype)initWithPageTitle:(NSString *)title projectID:(NSString *)projectID withJobsType:(NSString *)jobsType;

@end

@interface XWEduLabelModel : NSObject

//标签id
@property (nonatomic,copy) NSString * lable_id;
//标签名称
@property (nonatomic,copy) NSString * lable_name;

@end

@interface XWCollegeEduModel:NSObject

@property (nonatomic,strong) NSArray <CourseModel *> * dataList;

//标签内容
@property (nonatomic,strong) NSArray <XWEduLabelModel *> * courseList;

//图片
@property (nonatomic,copy) NSString * picture;

//获取标签
+ (void)getCollegeEduListWithJobsType:(NSString *)jobsType
                              Success:(void(^)(XWCollegeEduModel * model))success
                              failure:(void(^)(NSString *error))failure;

//获取课程
+ (void)getCollegeEduCoursListWithlabelID:(NSString *)labelId
                              andJobsType:(NSString *)jobsType
                                  Success:(void(^)(NSMutableArray *dataSource, BOOL isLast))success
                                  failure:(void(^)(NSString *error))failure
                              isFirstLoad:(BOOL)isFirstLoad;

@end



NS_ASSUME_NONNULL_END
