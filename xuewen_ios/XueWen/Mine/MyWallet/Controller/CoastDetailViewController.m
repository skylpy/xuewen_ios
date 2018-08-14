//
//  CoastDetailViewController.m
//  XueWen
//
//  Created by Pingzi on 2017/12/8.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "CoastDetailViewController.h"
#import "TransactionDetailsCell.h"
#import "MJRefresh.h"
#import "TransactionModel.h"


@interface CoastDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, strong) UIImageView  *icon;
@property (nonatomic, strong) UILabel      *noResultLabel;
@property (nonatomic, strong) NSArray      *dataSource;

@end

@implementation CoastDetailViewController

#pragma mark - --- Life Cycle ---

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI
{
    self.title = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [_tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}



- (void)loadData
{
    self.tableView.mj_footer.hidden = YES;
    WeakSelf;
    [XWNetworking getTransactionRecordWithType:[NSString stringWithFormat:@"%lu",(unsigned long)self.type] startTime:0 endTime:0 completionBlock:^(NSArray<TransactionModel *> *transactions, BOOL isLast) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        weakSelf.tableView.mj_footer.hidden = NO;
        weakSelf.dataSource = transactions;
        if (weakSelf.dataSource.count == 0) {
            [weakSelf showNoResult];
        }else{
            [weakSelf.tableView reloadData];
        }
        if (isLast) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
    
}

- (void)loadMoreData
{

}

#pragma mark - --- Table ---
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataSource.count - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, kWidth , 0, 0);
    }else{
        cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransactionDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    TransactionModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - --- Custom Method ---

- (void)showNoResult
{
    self.tableView.hidden = YES;
    [self.view addSubview:self.icon];
    [self.view addSubview:self.noResultLabel];
    NSString *text = @"暂无相关记录";
    self.icon.sd_layout.topSpaceToView(self.view,139).centerXIs(kWidth / 2.0).widthIs(70).heightIs(70);
    self.noResultLabel.sd_layout.topSpaceToView(self.icon,9).centerXIs(kWidth / 2.0).widthIs([text widthWithSize:14]).heightIs(14);
    self.noResultLabel.text = text;
}

#pragma mark - --- Lazy Load ---

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = DefaultBgColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.sectionHeaderHeight = 0.0;
        [_tableView registerClass:[TransactionDetailsCell class] forCellReuseIdentifier:@"CellID"];
        _tableView.separatorStyle = 0;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.separatorColor = COLOR(222, 222, 222);
    }
    return _tableView;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.image = LoadImage(@"iconRecordEmpty");
    }
    return _icon;
}

- (UILabel *)noResultLabel{
    if (!_noResultLabel) {
        _noResultLabel = [UILabel new];
        _noResultLabel.font = [UIFont systemFontOfSize:14];
        _noResultLabel.textColor = COLOR(153, 153, 153);
        _noResultLabel.textAlignment = 1;
    }
    return _noResultLabel;
}



@end
