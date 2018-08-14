//
//  MyWalletViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/11/16.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MyWalletViewController.h"
#import "MyWalletHeaderView.h"
#import "TransactionDetailsViewController.h"
#import "SelectPriceView.h"
#import "SelectPriceCell.h"
#import "PayTypeView.h"
#import "PayStatusVC.h"
#import "PayView.h"
@interface MyWalletViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) MyWalletHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SelectPriceView *priceView;
@property (nonatomic, strong) UIButton *rechargeButton;
@property (nonatomic, strong) PayTypeView *payTypeView;

@end

@implementation MyWalletViewController


#pragma mark- TableView&&Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = kWidth / 375.0 * 194.0;
    
    return kHeight - height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    return cell;
}
#pragma mark- CustomMethod

- (void)paySecceed{
    WeakSelf;
    [XWNetworking getAccountInfoWithCompletionBlock:^(NSString *status) {
        [weakSelf setDefaultsData];
    }];
    SelectPriceCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell clear];
}

- (void)payFailure{
}

- (void)infoUpdate{
    [self setDefaultsData];
}

- (void)rechargeAction:(UIButton *)sender{
    SelectPriceCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell.price <= 0) {
        [XWPopupWindow popupWindowsWithTitle:@"提示" message:@"请输入或选择金额" buttonTitle:@"好的" buttonBlock:nil];
    }else if (cell.price > 50000){
        [XWPopupWindow popupWindowsWithTitle:@"提示" message:@"单次充值不能超过50000元" buttonTitle:@"好的" buttonBlock:nil];
    }else{
        PayView *payView = [[PayView alloc] initWithPrice:cell.price];
        payView.animationType = kAnimationBottom;
        [payView show];
    }
}

- (void)backAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)detailAction:(UIButton *)detailAction{
    NSLog(@"明细");
    TransactionDetailsViewController *vc = [TransactionDetailsViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)initUI{
    self.title = @"我的钱包";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.rechargeButton];
    [self setDefaultsData];
    _rechargeButton.sd_layout.bottomSpaceToView(self.view, IsIPhoneX ? 34 : 8).leftSpaceToView(self.view, 15).rightSpaceToView(self.view, 15).heightIs(44);
    
    UIButton *detailButton = [UIButton buttonWithType:0];
    [detailButton addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
    [detailButton setTitleColor:DefaultTitleAColor forState:UIControlStateNormal];
    detailButton.titleLabel.font = kFontSize(14);
    [detailButton setTitle:@"明细" forState:UIControlStateNormal];
    detailButton.frame = CGRectMake(0, 0, 40, 15);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];
}

- (void)setDefaultsData{
    self.headerView.money = [XWInstance shareInstance].userInfo.gold;
    [self.tableView reloadData];
}

- (void)loadData{
    
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kNaviBarH - kBottomH - 110;
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight ) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = DefaultBgColor;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        [_tableView registerNib:[UINib nibWithNibName:@"SelectPriceCell" bundle:[NSBundle mainBundle]]  forCellReuseIdentifier:@"CellID"];
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (MyWalletHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[MyWalletHeaderView alloc] initWithTarget:self backAction:@selector(backAction:) detailAction:@selector(detailAction:)];
    }
    return _headerView;
}

- (SelectPriceView *)priceView{
    if (!_priceView) {
        _priceView = [SelectPriceView new];
    }
    return _priceView;
}

- (UIButton *)rechargeButton{
    if (!_rechargeButton) {
        _rechargeButton = [UIButton buttonWithType:0];
        _rechargeButton.backgroundColor = kThemeColor;
        ViewRadius(_rechargeButton, 1);
        [_rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
        [_rechargeButton addTarget:self action:@selector(rechargeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeButton;
}

- (PayTypeView *)payTypeView{
    if (!_payTypeView) {
        _payTypeView = [PayTypeView new];
    }
    return _payTypeView;
}
#pragma mark- LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 设置导航控制器的代理为self
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySecceed) name:PaySucceed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFailure) name:PayFailure object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoUpdate) name:PersonalInformationUpdate object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
