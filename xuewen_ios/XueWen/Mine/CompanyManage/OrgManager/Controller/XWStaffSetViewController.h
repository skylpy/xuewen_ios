//
//  XWStaffSetViewController.h
//  XueWen
//
//  Created by Karron Su on 2018/12/14.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XWStaffSetViewController : XWBaseViewController

/** 用户id*/
@property (nonatomic, strong) NSString *userId;
/** 输入框默认值*/
@property (nonatomic, strong) NSString *plachor;

@end

NS_ASSUME_NONNULL_END
