//
//  ClassesListViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/11/15.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "ClassesListViewController.h"
#import "ClassesInfoCell.h"
#import "ClassesHeaderView.h"
#import "ClassesInfoHeaderView.h"
#import "CourseModel.h"
#import "MJRefresh.h"
@interface ClassesListViewController ()<UITableViewDelegate,UITableViewDataSource,ClassesSelectViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ClassesInfoHeaderView *cellHeaderView;
@property (nonatomic, strong) ClassesHeaderView *headerView;
@property (nonatomic, strong) CourseLabelModel *model;
@property (nonatomic, strong) NSMutableArray<CourseModel *> *dataSource;
@property (nonatomic, strong) NSString *free;
@property (nonatomic, strong) NSString *orderType;

@end

@implementation ClassesListViewController
#pragma mark- ClassesSelectViewDelegate
- (void)sortLessionDidSelect:(NSString *)text dismiss:(BOOL)dismiss{
    self.orderType = text;
}

- (void)allLessionDidSelectLabel:(CourseLabelModel *)model dismiss:(BOOL)dismiss{
    if (![self.model isEqual:model]) {
        self.model = model;
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)selectLessionDidSelect:(NSString *)text dismiss:(BOOL)dismiss{
    self.free = text;
}

#pragma mark- TableView&&Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CourseModel *model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseID isAudio:NO] animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.cellHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 27;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassesInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassesId" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark- CustomMethod
- (void)initUI{
    self.page = 1;
    self.title = @"课程列表";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.headerView];
    self.headerView.allButtonTitle = (self.model.labelName.length > 0) ? self.model.labelName : @"全部";
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadData{
    self.page = 1;
    self.tableView.mj_footer.hidden = YES;
    WeakSelf;
    NSString *labelID = self.model.labelID;
    [XWNetworking getCoursLabelInfoWithID:labelID order:self.orderType free:self.free take:nil page:self.page++ CompletionBlock:^(NSArray *array, NSInteger totalCount, BOOL isLast) {
        weakSelf.tableView.mj_footer.hidden = NO;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.dataSource addObjectsFromArray:array];
        [weakSelf.tableView reloadData];
        weakSelf.cellHeaderView.count = totalCount;
        if (totalCount <= weakSelf.dataSource.count) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)loadMoreData{
    WeakSelf;
    NSString *labelID = self.model.labelID;
    [XWNetworking getCoursLabelInfoWithID:labelID order:self.orderType free:self.free take:nil page:self.page++ CompletionBlock:^(NSArray *array, NSInteger totalCount, BOOL isLast) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.dataSource addObjectsFromArray:array];
        [weakSelf.tableView reloadData];
        weakSelf.cellHeaderView.count = totalCount;
        if (totalCount <= weakSelf.dataSource.count) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (BOOL)hiddenNavigationBar {
    return NO;
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kNaviBarH - kBottomH - 50;
}

#pragma mark- Setter
- (void)setOrderType:(NSString *)orderType{
    if ([orderType isEqualToString:@"最新发布"]) {
        _orderType = @"1";
    }else if ([orderType isEqualToString:@"人气最高"]){
        _orderType = @"2";
    }else if ([orderType isEqualToString:@"价格由低到高"]){
        _orderType = @"3";
    }else if ([orderType isEqualToString:@"价格由高到低"]){
        _orderType = @"4";
    }else{
        _orderType = @"0";
    }
    [self.tableView.mj_header beginRefreshing];
}

- (void)externalSetOrderTtpe:(NSString *)orderType{
    _orderType = orderType;
}

- (void)setFree:(NSString *)free{
    if ([free isEqualToString:@"全部"]) {
        _free = @"0";
    }else if ([free isEqualToString:@"免费"]){
        _free = @"1";
    }else if ([free isEqualToString:@"付费"]){
        _free = @"2";
    }
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,45, kWidth, kHeight - 64 - 46) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        [_tableView registerClass:NSClassFromString(@"ClassesInfoCell") forCellReuseIdentifier:@"ClassesId"];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _tableView;
}

- (ClassesInfoHeaderView *)cellHeaderView{
    if (!_cellHeaderView) {
        _cellHeaderView = [ClassesInfoHeaderView new];
    }
    return _cellHeaderView;
}

- (ClassesHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ClassesHeaderView alloc ] initWithFrame:CGRectMake(0, 0, kWidth, 45) all:YES];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (NSMutableArray<CourseModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark- LifeCycle
- (instancetype)initWithCourseMode:(CourseLabelModel *)model{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.headerView removeSubViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
