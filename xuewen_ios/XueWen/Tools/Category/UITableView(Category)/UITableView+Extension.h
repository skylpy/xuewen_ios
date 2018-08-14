//
//  UITableView+Extension.h
//  XueWen
//
//  Created by ShaJin on 2018/3/2.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Extension)
/** tableView的便利构造方法 registerClass参数是tableView注册Cell的参数 key是要注册的cell类名 value是cell的identifier */
+ (instancetype)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style delegate:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource registerClass:(NSDictionary *)registerClass;
@end
