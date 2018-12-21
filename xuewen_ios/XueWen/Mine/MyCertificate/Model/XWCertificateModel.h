//
//  XWCertificateModel.h
//  XueWen
//
//  Created by aaron on 2018/8/18.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWHttpBaseModel.h"

@class XWCerDataModel,XWCerChildrenModel;

//证书列表Model
@interface XWCerListModel : NSObject

//证书ID
@property (nonatomic,copy) NSString * id;
//证书名称
@property (nonatomic,copy) NSString * achievement_name;
//上级ID
@property (nonatomic,copy) NSString * pid;
@property (nonatomic,copy) NSString * lock;
//考试ID
@property (nonatomic,copy) NSString * test_id;
//是否通过考试
@property (nonatomic,copy) NSString * pass_type;
//照片
@property (nonatomic,copy) NSString * show_picture_all;
//创建时间
@property (nonatomic,copy) NSString * create_time;

@property (nonatomic,copy) NSString * Percentage;
//岗位名称
@property (nonatomic,copy) NSString * job;
//证书编号
@property (nonatomic,copy) NSString * certificate_number;
//注册链接
@property (nonatomic,copy) NSString * nosignShare_url;

@end

//我的证书Model
@interface XWCertificateModel : NSObject

@property (nonatomic,strong) NSArray <XWCerDataModel *> * data;
@property (nonatomic,copy) NSString * total;
@property (nonatomic,copy) NSString * per_page;
@property (nonatomic,copy) NSString * current_page;
@property (nonatomic,copy) NSString * last_page;

//生成证书名称
@property (nonatomic,copy) NSString * achievement_name;
//工作
@property (nonatomic,copy) NSString * jobs;
//创建时间
@property (nonatomic,copy) NSString * create_time;
//证书编码
@property (nonatomic,copy) NSString * certificate_number;
//注册链接
@property (nonatomic,copy) NSString * nosignShare_url;

//生成证书
+ (void)createcertificatetestId:(NSString *)testId
                       withName:(NSString *)cuname
                        success:(void(^)(XWCertificateModel * cmodel))success
                        failure:(void(^)(NSString *error))failure;

//我的证书
+ (void)myCertificateThematicList:(NSInteger)thematic
                             Page:(NSInteger)page
                          success:(void(^)(XWCertificateModel * cmodel))success
                          failure:(void(^)(NSString *error))failure ;

//证书列表
+ (void)certificateThematicListID:(NSString *)cuid
                         withName:(NSString *)cuname
                          success:(void(^)(NSArray * list))success
                          failure:(void(^)(NSString *error))failure;

@end

@interface XWCerDataModel : NSObject

@property (nonatomic,copy) NSString * uid;
@property (nonatomic,copy) NSString * achievement_name;
@property (nonatomic,copy) NSString * pid;
@property (nonatomic,copy) NSArray <XWCerChildrenModel *> * children;
@property (nonatomic,assign) CGFloat cellHeight;

@end

@interface XWCerChildrenModel : NSObject

@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * achievement_name;
@property (nonatomic,copy) NSString * pid;
@property (nonatomic,assign) NSInteger light;
@property (nonatomic,copy) NSString * medal_picture_all;
@property (nonatomic,copy) NSString * medal_back_picture_all;
@property (nonatomic,copy) NSString * red_point;


@end
