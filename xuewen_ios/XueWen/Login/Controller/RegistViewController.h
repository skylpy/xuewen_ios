//
//  RegistViewController.h
//  XueWen
//
//  Created by ShaJin on 2017/11/30.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "XWBaseViewController.h"

@interface RegistViewController : XWBaseViewController
/** 页面类型 1 注册 2 重置密码 3 修改密码 */
- (instancetype)initWithType:(NSInteger)type;
@end
