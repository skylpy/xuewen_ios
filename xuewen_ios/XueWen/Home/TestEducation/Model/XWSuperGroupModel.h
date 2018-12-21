//
//  XWSuperGroupModel.h
//  XueWen
//
//  Created by aaron on 2018/10/19.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XWSuperGroupModel;
NS_ASSUME_NONNULL_BEGIN

@interface XWSuperGModel : NSObject

@property (nonatomic,copy) NSString * mid; //课程id
@property (nonatomic,copy) NSString * cover_photo;//课程封面图
@property (nonatomic,copy) NSString * cover_photo_all;//全链接课程封面图
@property (nonatomic,copy) NSString * course_name;//课程名称
@property (nonatomic,copy) NSString * tch_org;//老师名
@property (nonatomic,copy) NSString * time_length;//时长
@property (nonatomic,copy) NSString * price;//个人价格
@property (nonatomic,copy) NSString * favorable_price;//企业价格
@property (nonatomic,copy) NSString * course_type;//1视频 2 音频 3音视频
@property (nonatomic,copy) NSString * people_num;//课程人次
@property (nonatomic,copy) NSString * course_shelves;//0上架 1下架
@property (nonatomic,copy) NSString * name;//
@property (nonatomic,copy) NSString * picture;//头像
@property (nonatomic,copy) NSString * teacher_profile;//简介
@property (nonatomic,copy) NSString * tch_org_photo;//老师头像
@property (nonatomic,copy) NSString * tch_org_introduction;//老师简介
@property (nonatomic,copy) NSString * tch_org_photo_all;//全链接老师头像
@property (nonatomic,copy) NSString * amount;//课程价格

//超级组织
+ (void)getSuperGroupListPage:(NSInteger)page
                      Success:(void(^)(XWSuperGroupModel * model))success
                      failure:(void(^)(NSString *error))failure;

@end

@interface XWSuperGroupModel : NSObject

@property (nonatomic, strong) NSArray <XWSuperGModel *> * data;
@property (nonatomic, copy) NSString * last_page;
@property (nonatomic, copy) NSString * current_page;
@property (nonatomic, copy) NSString * per_page;
@property (nonatomic, copy) NSString * total;
@property (nonatomic, strong) NSString *total_price; //超级组织价格
@property (nonatomic, assign) BOOL buy; //1已购买 0未购买
@end

NS_ASSUME_NONNULL_END
