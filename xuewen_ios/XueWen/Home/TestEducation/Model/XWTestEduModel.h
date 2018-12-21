//
//  XWTestEduModel.h
//  XueWen
//
//  Created by aaron on 2018/10/18.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class XWTestEduModel;
@interface XWTestModel : NSObject

@property (nonatomic,strong) NSArray <XWTestEduModel *> * data;
@property (nonatomic,copy) NSString * last_page;
@property (nonatomic,copy) NSString * current_page;
@property (nonatomic,copy) NSString * per_page;
@property (nonatomic,copy) NSString * total;
@property (nonatomic,copy) NSString * describe;
@property (nonatomic,copy) NSString * html;


@end

@interface XWTestEduModel : NSObject

//试题id
@property (nonatomic,copy) NSString * mid;
//课程id
@property (nonatomic,copy) NSString * course_id;
//试题名称
@property (nonatomic,copy) NSString * title;
//试题描述
@property (nonatomic,copy) NSString * desc;
//岗位成就id
@property (nonatomic,copy) NSString * a_t_id;
//1普通试题 2专题试题 3测一测试题
@property (nonatomic,copy) NSString * state;
//岗位id
@property (nonatomic,copy) NSString * job_id;
//图片
@property (nonatomic,copy) NSString * picture;




//获取测一测试题列表
+ (void)getJobTestListSuccess:(void(^)(NSArray * list,XWTestModel * model))success
                      failure:(void(^)(NSString *error))failure;

@end

NS_ASSUME_NONNULL_END
