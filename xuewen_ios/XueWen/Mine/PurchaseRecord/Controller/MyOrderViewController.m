//
//  MyOrderViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/12/19.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MJRefresh.h"
#import "OrderModel.h"
#import "MyOrderCell.h"
#import "BottomAlertView.h"
@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,MyOrderCellDelegate>

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<OrderModel *> *dataSource;

@end

@implementation MyOrderViewController
#pragma MyOrderCellDelegate
- (void)payOrder:(OrderModel *)model{
    // 立即支付改成push到订单详情界面支付
    WeakSelf;
    UIViewController *vc = [ViewControllerManager orderInfoWithID:model.orderID type:2 updateBlock:^{
        [weakSelf beginLoadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cancelOrder:(OrderModel *)model{
    WeakSelf;
    [[BottomAlertView alertWithMessage:@"确定取消订单吗？" firstTitle:@"确定" secondTitle:@"取消" firstAction:^{
        [XWNetworking deleteOrderOrderWithOrderID:model.orderID completionBlock:nil];
        [weakSelf removeOrder:model];
    } secondAction:nil] show];
    
}

- (void)removeOrder:(OrderModel *)model{
    NSInteger index = [self.dataSource indexOfObject:model];
    [self.dataSource removeObjectAtIndex:index];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (section == 0) ? 2 : 9;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 196.5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.model = self.dataSource[indexPath.section];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *model = self.dataSource[indexPath.section];
    
    if ([model.type isEqualToString:@"0"]) {
        [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseID isAudio:NO] animated:YES];
    }else if ([model.type isEqualToString:@"1"]){
        UIViewController * vc = [NSClassFromString(@"XWCollegeBaseViewController") new];
        [vc setValue:model.collegeID forKey:@"labelID"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([model.type isEqualToString:@"3"]){
        [self.navigationController pushViewController:[NSClassFromString(@"XWSuperOrgViewController") new] animated:YES];
    }
}

#pragma mark- CustomMethod
- (void)initUI{
    self.view.backgroundColor = DefaultBgColor;
    self.scrollView = self.tableView;
    [self addHeaderFooterAction:@selector(loadOrderList)];
    [self beginLoadData];

}

- (void)loadOrderList{
    WeakSelf;
    [XWNetworking getPurchaseRecordWithType:self.type page:self.page++ completeBlock:^(NSArray<OrderModel *> *orders, BOOL isLast) {
        [weakSelf loadedDataWithArray:orders isLast:isLast];
    }];
}
#pragma mark- Setter
#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 45 - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        [_tableView registerClass:[MyOrderCell class] forCellReuseIdentifier:@"CellID"];
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    return _tableView;
}

- (NSMutableArray<OrderModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = self.array;
    }
    return _dataSource;
}
#pragma mark- LifeCycle
- (instancetype)initWithType:(NSString *)type{
    if (self = [super init]) {
        self.type = type;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
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
