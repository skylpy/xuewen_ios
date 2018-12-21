//
//  XWDepartmentSetViewController.h
//  XueWen
//
//  Created by Karron Su on 2018/12/13.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XWDepartmentSetViewController : XWBaseViewController

/** 部门id*/
@property (nonatomic, strong) NSString *oid;
/** 部门名称*/
@property (nonatomic, strong) NSString *name;
/** 上级id*/
@property (nonatomic, strong) NSString *pid;

@end

NS_ASSUME_NONNULL_END
