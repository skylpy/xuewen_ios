//
//  XWFirmOrderViewController.m
//  XueWen
//
//  Created by aaron on 2018/12/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWFirmOrderViewController.h"
#import "XWScholarShipViewController.h"
#import "MyWalletViewController.h"
#import "XWOrderFooterView.h"
#import "XWCompanyBackModel.h"
#import "XWFirmOrderCell.h"

static NSString *const XWFirmOrderCellID = @"XWFirmOrderCellID";
static NSString *const XWPlainCellID = @"XWPlainCellID";

@interface XWFirmOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

//列表
@property (nonatomic,strong) UITableView * tableView;
//数组
@property (nonatomic,strong) NSMutableArray * dataArray;
//底部按钮
@property (nonatomic,strong) UIButton * bottomBtn;
//头部说明
@property (nonatomic,strong) UIView * headerView;
//总价
@property (nonatomic,assign) CGFloat allMoney;
//优惠
@property (nonatomic,assign) CGFloat coupon;
//尾部
@property (nonatomic,strong) XWOrderFooterView * footerView;
//订单编号
@property (nonatomic,strong) UILabel * orderLabel;
//全选按钮
@property (nonatomic,strong) UIButton * selectButton;
//订单号
@property (nonatomic,copy) NSString * orderID;
//优惠券号
@property (nonatomic,copy) NSString * couponID;

@end

@implementation XWFirmOrderViewController

/**
 *注释
 *初始化数组
 */
- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

/**
 *注释
 *底部按钮
 */
- (UIButton *)bottomBtn {
    
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn setTitle:@"余额不足，去充值" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _bottomBtn.backgroundColor = Color(@"#F1BD30");
        @weakify(self)
        [[_bottomBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if ([_bottomBtn.titleLabel.text isEqualToString:@"马上结算"]) {

                [self sureOrder];

            }else {

                MyWalletViewController * vc = [NSClassFromString(@"MyWalletViewController") new];
                vc.isCompany = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    return _bottomBtn;
}

/**
 *注释
 *支付请求，跳到订单管理页面
 */
- (void)buyPay:(NSString *)orderId withCouponID:(NSString *)couponID{
    
    WeakSelf;
    [XWCourseManageModel orderCourseId:orderId couponId:couponID success:^(NSString * _Nonnull suc) {
        
        [MBProgressHUD showSuccessMessage:@"支付成功" completionBlock:^{
            UIViewController * vc = [NSClassFromString(@"XWOrderManagerViewController") new];
            [vc setValue:@"1" forKey:@"manger"];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        
    } failure:^(NSString * _Nonnull error) {
        
        [MBProgressHUD showErrorMessage:error completionBlock:^{
            
        }];
    }];
}

/**
 *注释
 *再次确认订单，编辑订单数据
 */
- (void)sureOrder {
    
    NSMutableArray * arr = [NSMutableArray array];
    for (XWCourseManageModel *model in self.dataArray) {
        
        if (model.isSelect) {
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setValue:model.Id forKey:@"course_id"];
            [dic setValue:@(model.people_count) forKey:@"people_count"];
            [arr addObject:dic];
        }
    }
    WeakSelf;
    [XWCourseManageModel sureOrderID:self.orderID couponId:self.couponID course:arr success:^(NSString * _Nonnull suc) {
        
        [XWPopupWindow popupWindowsWithTitle:@"您确定要支付吗？" message:@"" leftTitle:@"取消" rightTitle:@"立即支付" leftBlock:nil rightBlock:^{
            
            [weakSelf buyPay:weakSelf.orderID withCouponID:weakSelf.couponID];
            
        }];
        
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

/**
 *注释
 *列表头部说明
 */
- (UIView *)headerView {
    
    if (!_headerView) {
        
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 50)];
        _headerView = header;
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectButton = button;
        button.selected = YES;
        button.frame = CGRectMake(0, 0, 100, 50);
        [button setTitle:[NSString stringWithFormat:@" 全选(%lu)",(unsigned long)self.dataArray.count] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [button setTitleColor:Color(@"#666666") forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"noChecklist"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"Checklist"] forState:UIControlStateSelected];
        [header addSubview:button];
        [button addTarget:self action:@selector(bu:) forControlEvents:UIControlEventTouchUpInside];

        UILabel * orderLabel = [UILabel createALabelText:@"订单编号：18120722527479" withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#999999")];
        self.orderLabel = orderLabel;
        orderLabel.textAlignment = UITextAlignmentRight;
        [header addSubview:orderLabel];
        [orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(header);
            make.right.equalTo(header.mas_right).offset(-15);
            
        }];
        
        if (self.dataArray > 0) {
            XWCourseManageModel *model = self.dataArray[0];
            self.orderID = model.order_id;
            self.orderLabel.text = [NSString stringWithFormat:@"订单编号：%@",model.order_id];
        }
    }
    return _headerView;
}

/**
 *注释
 *全选按钮点击事件
 */
- (void)bu:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self ergodic:sender.selected];
    [self.tableView reloadData];
    
}
/**
 *注释
 *遍历反选
 */
- (void)ergodic:(BOOL)isSel {
    
    for (XWCourseManageModel *model in self.dataArray) {
        
        model.isSelect = isSel;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawUI];
    [self request];
}

/**
 *注释
 *初始化数据
 */
- (void)request {
    self.allMoney = 0;
    self.coupon = 0;
    NSArray * arr = [NSArray modelArrayWithClass:[XWCourseManageModel class] json:self.dict[@"purchaserecord"][@"data"]];
    
    for (XWCourseManageModel *model in arr) {
        
        model.isSelect = YES;
        self.allMoney += [model.price floatValue];
        
    }
    self.footerView = [XWOrderFooterView shareOrderFooterView];
    self.footerView.payableLabel.text = [NSString stringWithFormat:@"%.2f元",self.allMoney];
    self.footerView.sureLabel.text = [NSString stringWithFormat:@"%.2f元",self.allMoney];
    @weakify(self)
    [[self.footerView.countButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self selectCoupon];
    }];
    [self stateButton:self.allMoney];
    
    [self.dataArray addObjectsFromArray:arr];
    [self.tableView reloadData];
}

/**
 *注释
 *界面显示
 */
- (void)drawUI {
    
    self.title = @"确认订单";
    self.view.backgroundColor = Color(@"#F6F6F6");
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomBtn];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
}

/**
 *注释
 *选择优惠券后并返回
 */
- (void)selectCoupon{
    
    XWScholarShipViewController * vc = [NSClassFromString(@"XWScholarShipViewController") new];
    vc.shipPrice = self.allMoney;
    vc.couponID = self.couponID;
    [vc setScholarShipClick:^(CGFloat totle, NSInteger index,NSString * couponID) {
        self.coupon = totle;
        self.couponID = couponID;
        self.footerView.desLabel.text = [NSString stringWithFormat:@"(共使用了%ld张优惠券)",(long)index];
        self.footerView.countLabel.text = [NSString stringWithFormat:@"-¥ %.2f",totle];
        
        CGFloat money = self.allMoney-totle > 0?self.allMoney-totle:0;
        self.footerView.sureLabel.text = [NSString stringWithFormat:@"¥ %.2f",money];
        [self stateButton:money];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *注释
 *底部状态
 */
- (void)stateButton:(CGFloat)allPrice{
    
    if ([[XWInstance shareInstance].userInfo.company_gold floatValue] < allPrice) {
        
        [self.bottomBtn setTitle:@"余额不足，去充值" forState:UIControlStateNormal];
        [self.bottomBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        self.bottomBtn.backgroundColor = Color(@"#F1BD30");
    }else {
        
        [self.bottomBtn setTitle:@"马上结算" forState:UIControlStateNormal];
        [self.bottomBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        self.bottomBtn.backgroundColor = Color(@"#EA5554");
    }
}

#pragma mark tableView 代理事件

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 50;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return self.footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XWFirmOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:XWFirmOrderCellID forIndexPath:indexPath];
    XWCourseManageModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    @weakify(self)
    [cell setCourseManageClick:^(XWCourseManageModel * _Nonnull cmodel) {
        @strongify(self)
        
        self.allMoney = 0;
        for (XWCourseManageModel *m in self.dataArray) {
            if (m.isSelect) {
                self.allMoney += m.allprice;
            }
        }
        NSLog(@"%.2f",self.allMoney);
        self.footerView.payableLabel.text = [NSString stringWithFormat:@"%.2f元",self.allMoney];

        CGFloat money = self.allMoney-self.coupon > 0?self.allMoney-self.coupon:0;
        self.footerView.sureLabel.text = [NSString stringWithFormat:@"¥ %.2f",money];
        [self stateButton:self.allMoney];
    }];
    
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        
        UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        [tableview registerNib:[UINib nibWithNibName:@"XWFirmOrderCell" bundle:nil]  forCellReuseIdentifier:XWFirmOrderCellID];
        
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.backgroundColor = self.view.backgroundColor;
        tableview.separatorStyle = 0;
        tableview.estimatedSectionFooterHeight = 0.0;
        _tableView = tableview;

    }
    
    return _tableView;
}


@end

