//
//  XWOrgManagerModel.h
//  XueWen
//
//  Created by Karron Su on 2018/12/11.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWOrgManagerModel : NSObject

/** 用户id*/
@property (nonatomic, strong) NSString *userID;
/** 公司id*/
@property (nonatomic, strong) NSString *companyId;
/** 姓名*/
@property (nonatomic, strong) NSString *name;
/** 全链接头像地址*/
@property (nonatomic, strong) NSString *pictureAll;
/** 职位*/
@property (nonatomic, strong) NSString *post;
/** 角色信息*/
@property (nonatomic, strong) NSString *roleName;
/** 首字母*/
@property (nonatomic, strong) NSString *first;

@end

NS_ASSUME_NONNULL_END
