//
//  XWDepartmentModel.h
//  XueWen
//
//  Created by Karron Su on 2018/12/12.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 子组织机构Model*/
@interface XWChildrenDepartmentModel : NSObject

/** 组织机构id*/
@property (nonatomic, strong) NSString *oid;
/** 公司id*/
@property (nonatomic, strong) NSString *com_id;
/** 组织机构名称*/
@property (nonatomic, strong) NSString *department_name;
/** 上级id*/
@property (nonatomic, strong) NSString *pid;
/** 子机构组织*/
@property (nonatomic, strong) NSArray *children;


@end

/** 组织机构Model*/
@interface XWDepartmentModel : NSObject

/** 公司id*/
@property (nonatomic, strong) NSString *com_id;
/** 组织机构名称*/
@property (nonatomic, strong) NSString *department_name;
/** 上级id*/
@property (nonatomic, strong) NSString *pid;
/** 组织机构id*/
@property (nonatomic, strong) NSString *oid;
/** 子机构组织*/
@property (nonatomic, strong) NSArray <XWChildrenDepartmentModel *> *children;

@end

/**组织直属人员列表Model */
@interface XWDepartmentUserModel : NSObject
/** 用户id*/
@property (nonatomic, strong) NSString *userId;
/** 姓名*/
@property (nonatomic, strong) NSString *name;
/** 头像*/
@property (nonatomic, strong) NSString *picture;
/** 岗位*/
@property (nonatomic, strong) NSString *post;
/** 是否选中*/
@property (nonatomic, assign) BOOL isSelect;

@end

@interface XWDepartmentListModel : NSObject

/** 组织机构*/
@property (nonatomic, strong) NSArray <XWDepartmentModel *> *depeparList;
/** 组织总人数*/
@property (nonatomic, strong) NSString *nums;
/** 组织直属人员列表*/
@property (nonatomic, strong) NSMutableArray <XWDepartmentUserModel *> *userList;
/** 组织导航条*/
@property (nonatomic, strong) NSArray <XWChildrenDepartmentModel *> *Department;

@end



NS_ASSUME_NONNULL_END
