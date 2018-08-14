//
//  XWCompanyInfoModel.h
//  XueWen
//
//  Created by Karron Su on 2018/7/28.
//  Copyright © 2018年 KarronSu. All rights reserved.
//
// 公司信息Model

#import <Foundation/Foundation.h>

@interface XWCompanyInfoModel : NSObject

/** 公司名称*/
@property (nonatomic, strong) NSString *co_name;
/** 简介*/
@property (nonatomic, strong) NSString *co_introduction;
/** 企业logo*/
@property (nonatomic, strong) NSString *co_picture_all;
/** 企业文化*/
@property (nonatomic, strong) NSString *co_culture;
/** 企业制度*/
@property (nonatomic, strong) NSString *co_system;
/** 企业产品*/
@property (nonatomic, strong) NSString *co_product;



@end
