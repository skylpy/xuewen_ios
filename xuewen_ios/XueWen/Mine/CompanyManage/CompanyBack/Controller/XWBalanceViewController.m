//
//  XWBalanceViewController.m
//  XueWen
//
//  Created by aaron on 2018/12/11.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWBalanceViewController.h"
#import "XWBalanceCell.h"
#import "XWBalancesView.h"
#import "XWCompanyBackModel.h"

static NSString *const XWBalanceCellID = @"XWBalanceCellID";

@interface XWBalanceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,copy) NSString * oid;
@end

@implementation XWBalanceViewController

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawUI];
    self.oid = @"0";
    self.page = 1;
    [self requestData:self.oid];
}

//刷新
- (void)loadData {
    
    self.page = 1;
    [self requestData:self.oid];
}

//加载更多
- (void)moreData {
    self.page ++;
    [self requestData:self.oid];
}

- (void)requestData:(NSString *)oid {
    
    [XWCompanyBackModel getTransactionRecordType:oid Page:self.page success:^(NSArray * _Nonnull list) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

- (void)drawUI {
    
    self.title = @"余额记录";

    XWBalancesView * header = [XWBalancesView shareBalanceView];
    WeakSelf;
    [header setBalancesClick:^(NSString * _Nonnull o_id) {
        self.page = 1;
        weakSelf.oid = o_id;
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    [self.view addSubview:header];
    [self.view addSubview:self.tableView];
    
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.offset(45);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(header.mas_bottom);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XWBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:XWBalanceCellID forIndexPath:indexPath];
    XWRecordModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (UITableView *)tableView {
    if (!_tableView) {
        
        UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        [tableview registerNib:[UINib nibWithNibName:@"XWBalanceCell" bundle:nil]  forCellReuseIdentifier:XWBalanceCellID];
        
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.backgroundColor = self.view.backgroundColor;
        tableview.separatorStyle = 0;
        tableview.estimatedSectionFooterHeight = 0.0;
        _tableView = tableview;
        
        tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        
        tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    }
    
    return _tableView;
}

@end
