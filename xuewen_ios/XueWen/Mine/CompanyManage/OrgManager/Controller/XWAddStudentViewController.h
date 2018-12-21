//
//  XWAddStudentViewController.h
//  XueWen
//
//  Created by Karron Su on 2018/12/12.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XWAddStudentViewController : XWBaseViewController

/** 部门id*/
@property (nonatomic, strong) NSString *oid;
/** 部门名称*/
@property (nonatomic, strong) NSString *department_name;

@end

NS_ASSUME_NONNULL_END
