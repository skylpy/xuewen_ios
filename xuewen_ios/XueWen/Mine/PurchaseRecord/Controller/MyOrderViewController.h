//
//  MyOrderViewController.h
//  XueWen
//
//  Created by ShaJin on 2017/12/19.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "XWListViewController.h"

@interface MyOrderViewController : XWListViewController
// 0未完成 1 已完成 2已关闭
- (instancetype)initWithType:(NSString *)type;

@end
