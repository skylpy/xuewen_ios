//
//  XWCompanyCoursView.h
//  XueWen
//
//  Created by Karron Su on 2018/7/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "EScrollPageView.h"

@interface XWCompanyCoursView : EScrollPageItemBaseView

@property(nonatomic,retain)UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *learnArray;

@property (nonatomic, strong) NSMutableArray *companyCoursArray;

@end
