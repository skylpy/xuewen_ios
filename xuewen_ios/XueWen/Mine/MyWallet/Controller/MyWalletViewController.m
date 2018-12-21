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
#import "XWIAPManager.h"
#import "XWWalletFooterView.h"

//最好保存在服务器上，就可以不更新版本实现在Apple后台动态配置商品了

static  NSString  * const productXuewen6 =@"product_xuewen_6";

static const NSString * const productXuewen12 =@"product_xuewen_12";

static const NSString * const productXuewen30 =@"product_xuewen_30";

static const NSString *const productXuewen68 =@"product_xuewen_68";

static const NSString * const productXuewen108 =@"product_xuewen_108";

static const NSString *const productXuewen1048 =@"product_xuewen_1048";

@interface MyWalletViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,XWIAPManagerDelegate>

@property (nonatomic, strong) MyWalletHeaderView *headerView;
@property (nonatomic, strong) XWWalletFooterView * footerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SelectPriceView *priceView;
@property (nonatomic, strong) UIButton *rechargeButton;
@property (nonatomic, strong) PayTypeView *payTypeView;
@property (nonatomic,copy) NSString * productId;

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
    
    return 230;//kHeight - height;
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
    
    switch (cell.price) {
        case 6:
            self.productId = productXuewen6;
            break;
        case 12:
            self.productId = productXuewen12;
            break;
        case 30:
            self.productId = productXuewen30;
            break;
        case 68:
            self.productId = productXuewen68;
            break;
        case 108:
            self.productId = productXuewen108;
            break;
        case 1048:
            self.productId = productXuewen1048;
            break;
        default:
            break;
    }
    [MBProgressHUD showActivityMessageInView:@"正在支付..."];
    [[XWIAPManager sharedManager] requestProductWithId:self.productId];
    
//    SelectPriceCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    if (cell.price <= 0) {
//        [XWPopupWindow popupWindowsWithTitle:@"提示" message:@"请输入或选择金额" buttonTitle:@"好的" buttonBlock:nil];
//    }else if (cell.price > 50000){
//        [XWPopupWindow popupWindowsWithTitle:@"提示" message:@"单次充值不能超过50000元" buttonTitle:@"好的" buttonBlock:nil];
//    }else{
//        PayView *payView = [[PayView alloc] initWithPrice:cell.price];
//        payView.animationType = kAnimationBottom;
//        [payView show];
//    }
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
    
    self.title = self.isCompany ? @"充值":@"我的钱包";
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
    
    detailButton.hidden = !self.isCompany;
    
    [XWIAPManager sharedManager].delegate = self;
}

- (void)setDefaultsData{
    
    NSString * gold = self.isCompany ? [XWInstance shareInstance].userInfo.company_gold:[XWInstance shareInstance].userInfo.gold;
    self.headerView.money = gold;
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
        _tableView.scrollEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        [_tableView registerNib:[UINib nibWithNibName:@"SelectPriceCell" bundle:[NSBundle mainBundle]]  forCellReuseIdentifier:@"CellID"];
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        
    }
    return _tableView;
}

- (XWWalletFooterView *)footerView {
    
    if (!_footerView) {
        _footerView = [XWWalletFooterView shareWalletFooterView];
    }
    return _footerView;
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

#pragma mark - ================ XWIAPManager Delegate =================

- (void)receiveProduct:(SKProduct *)product {
    
    if (product != nil) {
        //购买商品
        if (![[XWIAPManager sharedManager] purchaseProduct:product]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"您禁止了应用内购买权限,请到设置中开启" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"失败" message:@"无法连接App store!" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)successedWithReceipt:(NSData *)transactionReceipt {
    NSLog(@"购买成功");
    
    [MBProgressHUD hideHUD];
    NSString  *transactionReceiptString = [transactionReceipt base64EncodedStringWithOptions:0];

    NSLog(@"%@",transactionReceiptString);
    if ([transactionReceiptString length] > 0) {
        
        NSString * comId = self.isCompany ? [XWInstance shareInstance].userInfo.company_id:@"0";
        [XWIAPModel purchaseReceipt:transactionReceiptString companyId:comId  success:^(NSString * gold){
            if (self.isCompany) {
                [XWInstance shareInstance].userInfo.company_gold = gold;
            }else {
                [XWInstance shareInstance].userInfo.gold = gold;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:applePaySucceed object:nil];
            self.headerView.countLabel.text = gold;
            NSLog(@"==%@",gold);
        } failure:^(NSString * _Nonnull error) {
            
        }];
        // 向自己的服务器验证购买凭证（此处应该考虑将凭证本地保存,对服务器有失败重发机制）
        /**
         服务器要做的事情:
         接收ios端发过来的购买凭证。
         判断凭证是否已经存在或验证过，然后存储该凭证。
         将该凭证发送到苹果的服务器验证，并将验证结果返回给客户端。
         如果需要，修改用户相应的会员权限
         */
        
        /**
         if (凭证校验成功) {
         [[MLIAPManager sharedManager] finishTransaction];
         }
         */
    }
}

- (void)failedPurchaseWithError:(NSString *)errorDescripiton {
    NSLog(@"购买失败");
    [MBProgressHUD hideHUD];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"失败" message:errorDescripiton delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
    [alert show];
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
