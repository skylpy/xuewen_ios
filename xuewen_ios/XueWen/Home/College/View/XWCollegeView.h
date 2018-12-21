//
//  XWCollegeView.h
//  XueWen
//
//  Created by Karron Su on 2018/8/13.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "EScrollPageView.h"

@interface XWCollegeView : EScrollPageItemBaseView

@property(nonatomic,retain)UITableView *tableView;

- (instancetype)initWithPageTitle:(NSString *)title projectID:(NSString *)projectID;

@end
