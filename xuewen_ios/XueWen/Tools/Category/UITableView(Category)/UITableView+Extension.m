//
//  UITableView+Extension.m
//  XueWen
//
//  Created by ShaJin on 2018/3/2.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView (Extension)

+ (instancetype)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style delegate:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource registerClass:(NSDictionary *)registerClass{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    tableView.dataSource = dataSource;
    tableView.delegate = delegate;
    tableView.separatorStyle = 0;
    tableView.backgroundColor = DefaultBgColor;
    if ([registerClass allKeys].count > 0) {
        for (NSString *className in [registerClass allKeys]) {
            [tableView registerClass:NSClassFromString(className) forCellReuseIdentifier:registerClass[className]];
        }
    }
    return tableView;
}
@end
