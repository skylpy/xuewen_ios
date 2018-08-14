//
//  XWAudioCourseListController.m
//  XueWen
//
//  Created by Karron Su on 2018/5/12.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWAudioCourseListController.h"
#import "XWAudioCoursesListCell.h"
#import "ViewControllerManager.h"
#import "MainNavigationViewController.h"
#import "XWAudioSearchController.h"

static NSString *const XWAudioCoursesListCellID = @"XWAudioCoursesListCellID";

@interface XWAudioCourseListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation XWAudioCourseListController

#pragma mark - Lazy / Getter
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        [table registerNib:[UINib nibWithNibName:@"XWAudioCoursesListCell" bundle:nil] forCellReuseIdentifier:XWAudioCoursesListCellID];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = table;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:Color(@"#57A2FF")] forBarMetrics:(UIBarMetricsDefault)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:Color(@"#ffffff"),NSFontAttributeName:[UIFont fontWithName:kRegFont size:18]}];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:Color(@"#ffffff")] forBarMetrics:(UIBarMetricsDefault)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:Color(@"#333333"),NSFontAttributeName:[UIFont fontWithName:kRegFont size:18]}];
}

#pragma mark - Super Methods

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - kNaviBarH - 50;
}

- (void)initUI{
    self.title = @"音频课程";
    [self.view addSubview:self.tableView];
    // 设置导航栏
    [self setNavigationController];
    //刷新
    [self setRefresh];
}

- (void)loadData{
    XWWeakSelf
    [XWHttpTool getAudioCoursesWithName:@"" isFirstLoad:YES success:^(NSMutableArray *array, BOOL isLast) {
        weakSelf.dataArray = array;
        if (isLast) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showErrorMessage:errorInfo];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMore{
    XWWeakSelf
    [XWHttpTool getAudioCoursesWithName:@"" isFirstLoad:NO success:^(NSMutableArray *array, BOOL isLast) {
        [weakSelf.dataArray addObjectsFromArray:array];
        if (isLast) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showErrorMessage:errorInfo];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Custom Methods

- (void)setRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

- (void)setNavigationController{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:LoadImage(@"icon_audio_back") forState:UIControlStateNormal];
    @weakify(self)
    [[[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = [self.navigationController getRightBtnItemWithImgName:@"icon_audio_search" target:self method:@selector(rightButtonClick)];
}

- (void)rightButtonClick{
    XWAudioSearchController *vc = [[XWAudioSearchController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XWWeakSelf
    return [tableView fd_heightForCellWithIdentifier:XWAudioCoursesListCellID cacheByIndexPath:indexPath configuration:^(XWAudioCoursesListCell* cell) {
        XWAudioCoursModel *model = weakSelf.dataArray[indexPath.row];
        cell.model = model;
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWAudioCoursesListCell *cell = [tableView dequeueReusableCellWithIdentifier:XWAudioCoursesListCellID forIndexPath:indexPath];
    XWAudioCoursModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XWAudioCoursModel *model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseId isAudio:YES] animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
