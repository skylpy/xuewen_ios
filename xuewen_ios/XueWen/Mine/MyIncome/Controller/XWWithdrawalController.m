//
//  XWWithdrawalController.m
//  XueWen
//
//  Created by Karron Su on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWWithdrawalController.h"
#import "XWWithdrawalHeaderView.h"
#import "XWWithdrawalCell.h"
#import "XWTransactionListHeaderView.h"
#import "XWBoundAliPayController.h"

static NSString *const XWWithdrawalCellID = @"XWWithdrawalCellID";

@interface XWWithdrawalController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XWWithdrawalHeaderView *headerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

/** 支付宝账号*/
@property (nonatomic, strong) NSString *payeeAccount;

@property (nonatomic, strong) UIView *statusView;

@end

@implementation XWWithdrawalController

#pragma mark - Getter
- (XWWithdrawalHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[XWWithdrawalHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 302)];
    }
    return _headerView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kNaviBarH) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.tableHeaderView = self.headerView;
        [table registerNib:[UINib nibWithNibName:@"XWWithdrawalCell" bundle:nil] forCellReuseIdentifier:XWWithdrawalCellID];
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

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:Color(@"#3376FF")];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:Color(@"#ffffff")];
    [self.statusView removeFromSuperview];
}

- (void)initUI{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:LoadImage(@"icon_audio_back") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backTopVC) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"提现";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:kMedFont size:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    self.statusView = [[UIView alloc] initWithFrame:CGRectMake(0, -kStasusBarH, kWidth, 20)];
    self.statusView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:self.statusView];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    [self addNotificationWithName:@"BindingAccountSuccess" selector:@selector(loadData)];
    
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - kNaviBarH;;
}

 
- (void)loadData{
    XWWeakSelf
    [XWHttpTool getMyTransactionListWithIsFirstLoad:YES success:^(NSMutableArray *array, BOOL isLast) {
        weakSelf.dataArray = array;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        if (isLast) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSString *errorInfo) {
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD showTipMessageInView:errorInfo];
    }];
    
    [XWHttpTool getPayeeAccountSuccess:^(NSString *bonusesPrice, NSString *payeeAccount) {
        weakSelf.headerView.bonusesPrice = bonusesPrice;
        weakSelf.headerView.payeeAccount = payeeAccount;
        weakSelf.payeeAccount = payeeAccount;
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showTipMessageInView:errorInfo];
    }];
}

#pragma mark - Custom Methods

- (void)loadMore{
    XWWeakSelf
    [XWHttpTool getMyTransactionListWithIsFirstLoad:YES success:^(NSMutableArray *array, BOOL isLast) {
        [weakSelf.dataArray addObjectsFromArray:array];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        if (isLast) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSString *errorInfo) {
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD showTipMessageInView:errorInfo];
    }];
}

- (void)backTopVC{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWWithdrawalCell *cell = [tableView dequeueReusableCellWithIdentifier:XWWithdrawalCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[XWTransactionListHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 80)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)dealloc{
    [self removeNotificationWithName:@"BindingAccountSuccess"];
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
