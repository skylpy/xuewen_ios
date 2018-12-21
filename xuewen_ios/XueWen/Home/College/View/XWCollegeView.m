//
//  XWCollegeView.m
//  XueWen
//
//  Created by Karron Su on 2018/8/13.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCollegeView.h"
#import "ProjectModel.h"
#import "XWProjectIntroduceCell.h"
#import "XWProjectHeaderView.h"
#import "XWProjectCoursCell.h"

static NSString *const XWProjectIntroduceCellID = @"XWProjectIntroduceCellID";
static NSString *const XWProjectCoursCellID = @"XWProjectCoursCellID";


@interface XWCollegeView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSString *projectID;
@property (nonatomic, strong) NSString *projectName;
@property (nonatomic, strong) ProjectModel *model;

@end

@implementation XWCollegeView

#pragma mark - Getter
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.backgroundColor = Color(@"#F4F4F4");
//        table.scrollEnabled = NO;
        [table registerClass:[XWProjectIntroduceCell class] forCellReuseIdentifier:XWProjectIntroduceCellID];
        [table registerClass:[XWProjectCoursCell class] forCellReuseIdentifier:XWProjectCoursCellID];
        _tableView = table;
    }
    return _tableView;
}

- (instancetype)initWithPageTitle:(NSString *)title projectID:(NSString *)projectID{
    if (self = [super initWithPageTitle:title]) {
        self.projectID = projectID;
        self.projectName = title;
        [self addNotificationWithName:@"UPDATEPROJECTPRICE" selector:@selector(loadData)];
    }
    return self;
}

- (void)didAppeared{
    [self addSubview:self.tableView];
    [self loadData];
}

- (void)loadData{
    XWWeakSelf
    [XWNetworking getThematicInfoWithID:self.projectID completeBlock:^(ProjectModel *model) {
        weakSelf.model = model;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.model.projects.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:XWProjectIntroduceCellID cacheByIndexPath:indexPath configuration:^(XWProjectIntroduceCell* cell) {
            cell.introduce = self.model.introduction;
        }];
    }
    return 425;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        XWProjectIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:XWProjectIntroduceCellID forIndexPath:indexPath];
        cell.introduce = self.model.introduction;
        return cell;
    }
    XWProjectCoursCell *cell = [tableView dequeueReusableCellWithIdentifier:XWProjectCoursCellID forIndexPath:indexPath];
    ProjectModel *project = self.model.projects[indexPath.section-1];
    if (project.courses.count < 4) {
        cell.dataSoure = project.courses;
    }else{
        cell.dataSoure = [project.courses subarrayWithRange:NSMakeRange(0, 4)];
    }
    
    cell.model = project;
    cell.buy = project.buy;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    
    ProjectModel *project = self.model.projects[section-1];
    CGFloat height = [NSString stringHeightWithString:[NSString filterHTML:project.introduction] size:12 maxWidth:kWidth-50];
    
    return height + 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    XWProjectHeaderView *headerView = [[XWProjectHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 100)];
    headerView.model = self.model.projects[section-1];
    headerView.projectName = self.projectName;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 10;
}


@end
