//
//  XWRankViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWRankViewController.h"
#import "XWStudyRankCell.h"
#import "XWStudyHeaderView.h"
#import "XWRankTableCell.h"

static NSString *const XWStudyRankCellID = @"XWStudyRankCellID";
static NSString *const XWRankTableCellID = @"XWRankTableCellID";

@interface XWRankViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XWStudyHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *orderType;

@end

@implementation XWRankViewController

#pragma mark - Getter
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kBottomH-48-kNaviBarH) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.backgroundColor = Color(@"#ffffff");
        [table registerNib:[UINib nibWithNibName:@"XWStudyRankCell" bundle:nil] forCellReuseIdentifier:XWStudyRankCellID];
        [table registerNib:[UINib nibWithNibName:@"XWRankTableCell" bundle:nil] forCellReuseIdentifier:XWRankTableCellID];
//        table.tableHeaderView = self.headerView;
        _tableView = table;
    }
    return _tableView;
}

- (XWStudyHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[XWStudyHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 90)];
    }
    return _headerView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSString *)orderType{
    if (!_orderType) {
        _orderType = [[NSString alloc] init];
    }
    return _orderType;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)initUI{
    //1是周榜 2月榜 0总榜
    //0为总排名；1为周排名；2为月排名；
    switch (self.type) {
        case ControllerTypeWeek:
        {
            self.orderType = @"1";
        }
            break;
        case ControllerTypeMonth:
        {
            self.orderType = @"2";
        }
            break;
        case ControllerTypeAll:
        {
            self.orderType = @"0";
        }
            break;
        default:
            break;
    }
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

- (void)loadData{
    
    if (self.index == 0) { // 学习排名
        XWWeakSelf
        [XWHttpTool getCountPlayTimeWithOrderType:self.orderType isFirstLoad:YES success:^(NSMutableArray *array, BOOL isLast, XWCountPlayTimeModel *rankModel) {
            weakSelf.dataArray = array;
            weakSelf.headerView.rankModel = rankModel;
            weakSelf.headerView.type = self.type;
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
            if (isLast) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showTipMessageInWindow:errorInfo];
            
            [weakSelf.tableView.mj_header endRefreshing];
        } size:@"100" companyId:@""];
    }else{ // 目标排名
        XWWeakSelf
        [XWHttpTool getTargetDataWith:YES type:self.orderType success:^(NSMutableArray *array, BOOL isLast, XWTargetRankModel *rankModel) {
            weakSelf.dataArray = array;
            
            weakSelf.headerView.goalModel = rankModel;
            [weakSelf.tableView.mj_header endRefreshing];
            weakSelf.headerView.type = self.type;
            [weakSelf.tableView reloadData];
            if (isLast) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showTipMessageInWindow:errorInfo];
            
            [weakSelf.tableView.mj_header endRefreshing];
        } size:@"100" companyId:@""];
    }
}

- (void)loadMore{
    if (self.index == 0) { // 学习排名
        XWWeakSelf
        [XWHttpTool getCountPlayTimeWithOrderType:self.orderType isFirstLoad:NO success:^(NSMutableArray *array, BOOL isLast, XWCountPlayTimeModel *rankModel) {
            [weakSelf.dataArray addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            if (isLast) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showTipMessageInWindow:errorInfo];
            
            [weakSelf.tableView.mj_header endRefreshing];
        } size:@"100" companyId:@""];
    }else{ // 目标排名
        XWWeakSelf
        [XWHttpTool getTargetDataWith:NO type:self.orderType success:^(NSMutableArray *array, BOOL isLast, XWTargetRankModel *rankModel) {
            [weakSelf.dataArray addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            if (isLast) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showTipMessageInWindow:errorInfo];
            
            [weakSelf.tableView.mj_header endRefreshing];
        } size:@"100" companyId:@""];
    }
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <= 2) {
        return 92;
    }
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row <= 2) {
        XWRankTableCell *cell = [tableView dequeueReusableCellWithIdentifier:XWRankTableCellID forIndexPath:indexPath];
        cell.isLast = indexPath.row == 2 ? YES : NO;
        if (self.index == 0) {
            cell.model = self.dataArray[indexPath.row];
        }else{
            cell.targetModel = self.dataArray[indexPath.row];
        }
        cell.idx = indexPath.row;
        return cell;
    }
    XWStudyRankCell *cell = [tableView dequeueReusableCellWithIdentifier:XWStudyRankCellID forIndexPath:indexPath];
    cell.isLast = indexPath.row == self.dataArray.count-1 ? YES : NO;
    if (self.index == 0) {
        cell.model = self.dataArray[indexPath.row];
    }else{
        cell.targetModel = self.dataArray[indexPath.row];
    }
    cell.idx = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
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
