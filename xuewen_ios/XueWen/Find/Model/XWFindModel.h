//
//  XWFindModel.h
//  XueWen
//
//  Created by aaron on 2018/10/18.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWFindListModel : NSObject
//公司id
@property (nonatomic, strong) NSString * mid;
//公司名
@property (nonatomic, strong) NSString * coName;
//公司简介
@property (nonatomic, strong) NSString * coIntroduction;
@property (nonatomic, strong) NSString * logoUrl;
//公司logo图全链接
@property (nonatomic, strong) NSString * logoUrlAll;
@property (nonatomic, strong) NSString * pictureUrl;
//公司图全链接
@property (nonatomic, strong) NSString * pictureUrlAll;
// 商学院名称
@property (nonatomic, strong) NSString *college_name;

@end


@interface XWFindModel : NSObject

@property (nonatomic,strong) NSArray <XWFindListModel *> * data;
@property (nonatomic,copy) NSString * last_page;
@property (nonatomic,copy) NSString * current_page;
@property (nonatomic,copy) NSString * per_page;
@property (nonatomic,copy) NSString * total;
//顶部的banner图片全链接
@property (nonatomic,copy) NSString * banner_photo_url;

//获取发现列表
+ (void)getDiscoveryWithIsFirstLoad:(BOOL)isFirst
                     Success:(void(^)(NSMutableArray * list, BOOL isLast))success
                     failure:(void(^)(NSString *error))failure;

@end

NS_ASSUME_NONNULL_END
