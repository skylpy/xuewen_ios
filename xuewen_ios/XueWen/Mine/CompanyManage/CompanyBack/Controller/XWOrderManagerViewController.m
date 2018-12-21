//
//  XWOrderManagerViewController.m
//  XueWen
//
//  Created by aaron on 2018/12/12.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWOrderManagerViewController.h"
#import "XWOrderDateilViewController.h"
#import "MainNavigationViewController.h"
#import "XWOrderManagerCell.h"
#import "XWCourseManageModel.h"
#import "XWCompanyBackModel.h"

static NSString *const XWOrderManagerCellID = @"XWOrderManagerCellID";

@interface XWOrderManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,assign) NSInteger page;

@end

@implementation XWOrderManagerViewController

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawUI];
    [self requestData];
}

//刷新
- (void)loadData {
    
    self.page = 1;
    [self requestData];
}

//加载更多
- (void)moreData {
    self.page ++;
    [self requestData];
}

- (void)requestData {
    
    [XWCompanyBackModel getPurchaseRecord:self.page success:^(NSArray * _Nonnull list) {
        
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
    
    self.page = 1;
    self.title = @"订单管理";
    self.view.backgroundColor = Color(@"#F9F9F9");
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XWCompanyOrderModel * model = self.dataArray[indexPath.section];
    return [model.status isEqualToString:@"0"]?200:170;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XWOrderManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:XWOrderManagerCellID forIndexPath:indexPath];
    XWCompanyOrderModel * model = self.dataArray[indexPath.section];
    cell.model = model;
    @weakify(self)
    [cell setPayButtonClick:^(XWCompanyOrderModel * _Nonnull pmodel) {
        @strongify(self)
        [XWPopupWindow popupWindowsWithTitle:@"您确定要支付吗？" message:@"" leftTitle:@"取消" rightTitle:@"立即支付" leftBlock:nil rightBlock:^{
            
            if ([[XWInstance shareInstance].userInfo.company_gold floatValue] < [pmodel.price floatValue]) {
                [XWPopupWindow popupWindowsWithTitle:@"余额不足请充值！" message:@"" leftTitle:@"取消" rightTitle:@"我要充值" leftBlock:nil rightBlock:^{
                    
                    UIViewController * vc = [NSClassFromString(@"MyWalletViewController") new];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }else {
                
                [self buyPay:pmodel.orderID withCouponID:pmodel.couponId];
            }
        }];
    }];
    [cell setCanceButtonClick:^(XWCompanyOrderModel * _Nonnull pmodel) {
        @strongify(self)
        [XWPopupWindow popupWindowsWithTitle:@"您确定要取消订单吗？" message:@"" leftTitle:@"取消" rightTitle:@"确定" leftBlock:nil rightBlock:^{
            [XWNetworking deleteOrderOrderWithOrderID:pmodel.orderID completionBlock:^(BOOL succeed) {
                self.page = 1;
                [self requestData];
            }];
            
        }];
        
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XWOrderDateilViewController * vc = [XWOrderDateilViewController new];
    XWCompanyOrderModel * model = self.dataArray[indexPath.section];
    vc.orderId = model.orderID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)buyPay:(NSString *)orderId withCouponID:(NSString *)couponID{
    
    WeakSelf;
    [XWCourseManageModel orderCourseId:orderId couponId:couponID success:^(NSString * _Nonnull suc) {
        
        [MBProgressHUD showSuccessMessage:@"支付成功" completionBlock:^{
            
            [weakSelf requestData];
        }];
        
    } failure:^(NSString * _Nonnull error) {
        
        [MBProgressHUD showErrorMessage:error];
    }];
    
}


- (UITableView *)tableView {
    if (!_tableView) {
        
        UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        [tableview registerNib:[UINib nibWithNibName:@"XWOrderManagerCell" bundle:nil]  forCellReuseIdentifier:XWOrderManagerCellID];
        
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
