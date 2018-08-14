//
//  BannerModel.h
//  XueWen
//
//  Created by ShaJin on 2017/12/21.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 "company_id" = 1;
 "create_time" = 1513762335;
 id = 21;
 picture = "http://xuewen-oss.oss-cn-shenzhen.aliyuncs.com/uploads/20171220/1513762298157.png";
 "picture_desc" = test1;
 "picture_link" = "<null>";
 "picture_sort" = 1;
 "picture_url" = "uploads/20171220/1513762298157.png";
 type = 2;

 */
@interface BannerModel : NSObject
/** 组织（公司）ID */
@property (nonatomic, strong) NSString *companyID;
/** 创建时间 */
@property (nonatomic, strong) NSString *creatTime;
/** 图片ID */
@property (nonatomic, strong) NSString *imageID;
/** 图片地址 */
@property (nonatomic, strong) NSString *picture;
/** 图片描述 */
@property (nonatomic, strong) NSString *desc;
/** 图片链接 */
@property (nonatomic, strong) NSString *link;
/** 图片序号 */
@property (nonatomic, strong) NSString *sort;
/** 图片类型（App端类型为2） */
@property (nonatomic, strong) NSString *type;
/** 约定好的跳转url*/
@property (nonatomic, strong) NSString *appurl;
@end
