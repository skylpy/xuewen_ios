//
//  ConfirmOrderViewController.m
//  XueWen
//
//  Created by ShaJin on 2018/3/1.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "ConfirmOrderCell.h"
#import "SelectCouponViewController.h"
#import "CouponModel.h"
#import "OrderModel.h"
#import "ClassesInfoCell.h"
#import "CourseModel.h"
#import "ProjectModel.h"
#import "SubProjectViewController.h"
#import "ConfirmOrderBuyView.h"
#import <objc/runtime.h>
@interface ConfirmOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) void (^UpdateBlock)(void);
@property (nonatomic, strong) OrderModel *order;
@property (nonatomic, assign) float gold;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL canBuy;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) CouponModel *coupon;
@property (nonatomic, assign) NSInteger couponCount;
@property (nonatomic, strong) ConfirmOrderBuyView *buyView;
@property (nonatomic, strong) NSString *coupons;
@property (nonatomic, assign) float couponPrice;


@end

@implementation ConfirmOrderViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && self.couponCount > 0) {
        WeakSelf;
        SelectCouponViewController *vc = [[SelectCouponViewController alloc] initWithPrice:[self.order.price floatValue] completeBlock:^(NSString *coupons, float price) {
            weakSelf.coupons = coupons;
            weakSelf.couponPrice = price;
            [weakSelf checkMoney];
            [weakSelf.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = (indexPath.section == 0) ? 98 : 50;
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (section == 0) ? 0 : 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ClassesInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassInfo"];
        [cell setCourse:[self.order.type isEqualToString:@"0"] ? self.order.purchaseInfo : nil project:[self.order.type isEqualToString:@"1"] ? self.order.purchaseInfo : nil price:self.order.price];
        return cell;
    }else{
        ConfirmOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        cell.title = (indexPath.section == 1) ? @"奖学金" : @"余额";
        cell.showMore = (indexPath.section == 1);
        cell.content = (indexPath.section == 1) ? ((self.couponCount == 0) ? @"暂无可用" : @"请选择") : [NSString stringWithFormat:@"%.2f",self.gold];
        NSString *content = nil;
        if (indexPath.section == 1) {
            if (self.couponCount == 0) {
                content = @"暂无可用";
            }else{
                if (self.coupons) {
                    float price = MIN(self.couponPrice, [self.order.price floatValue]);
                    content = [NSString stringWithFormat:@"-%.2f",price];
                }else{
                    content = @"请选择";
                }
            }
        }else{
            content = [NSString stringWithFormat:@"%.2f",self.gold];
        }
        cell.content = content;
        
        
        cell.selectionStyle = 0;
        return cell;
    }
}

#pragma mark- CustomMethod
- (void)buyAction:(UIButton *)sender{
    if (_canBuy) {
        WeakSelf;
        [XWNetworking purchaseOrderWithOrderID:self.order.orderID couponID:self.coupons completionBlock:^(BOOL succeed) {
            if (succeed) {
                if (_UpdateBlock) {
                    _UpdateBlock();
                }
                [XWNetworking getAccountInfoWithCompletionBlock:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }//
        }];
    }else{
        [self.navigationController pushViewController:[ViewControllerManager WalletViewController] animated:YES];
    }
}

- (BOOL)hiddenNaviLine{
    return NO;
}

- (void)initUI{
    self.title = @"确认订单";
    
    self.view.backgroundColor = DefaultBgColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.buyView];
    [self.view addSubview:self.tipLabel];
    self.buyView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, kBottomH).heightIs(49);
    self.tipLabel.sd_layout.bottomSpaceToView(self.buyView, 10).centerXEqualToView(self.view).leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(16);
}
- (void)loadData{
    WeakSelf;
    [XWNetworking creatOrderWithID:_identifier type:_type completeBlock:^(float gold, OrderModel *order) {
        weakSelf.gold = gold;
        weakSelf.order = order;
        [weakSelf checkMoney];
        [weakSelf.tableView reloadData];
    }];
    [XWNetworking getCouponListWithType:@"1" page:1 completeBlock:^(NSArray *array, NSInteger totalCount, BOOL isLast) {
        if (totalCount > 0) {
            weakSelf.couponCount = totalCount;
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)checkMoney{
    float couponPrice = self.couponPrice;
    float orderPrice = [self.order.price floatValue];
    float needPay = (couponPrice >= orderPrice) ? 0.0 : (orderPrice - couponPrice);
    if (self.gold >= needPay) {
        self.tipLabel.hidden = YES;
        [self.buyView setCanBuy:YES price:[NSString stringWithFormat:@"%.2f",needPay]];
        self.canBuy = YES;
        
    }else{
        self.canBuy = NO;
        self.tipLabel.text = [NSString stringWithFormat:@"余额不足，还差￥%.2f",needPay - self.gold];
        [self.buyView setCanBuy:NO price:nil];
        
    }
}
#pragma mark- Setter
#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        NSDictionary *dict =@{@"ClassesInfoCell" : @"ClassInfo",@"ConfirmOrderCell" : CellID};
        _tableView = [UITableView tableViewWithFrame:CGRectMake(0, 0, kWidth, kHeight - kNaviBarH - 49 - kBottomH) style:UITableViewStylePlain delegate:self dataSource:self registerClass:dict];
    }
    return _tableView;
}

- (ConfirmOrderBuyView *)buyView{
    if (!_buyView) {
        _buyView = [[ConfirmOrderBuyView alloc] initWithTarget:self action:@selector(buyAction:)];
    }
    return _buyView;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel labelWithTextColor:DefaultTitleAColor size:16];
        _tipLabel.textAlignment = 1;
    }
    return _tipLabel;
}

#pragma mark- LifeCycle
- (instancetype)initWithID:(NSString *)identifier type:(int)type updateBlcok:(void(^)(void))updateBlock{
    if (self = [super init]) {
        self.identifier = identifier;
        self.type = type;
        self.UpdateBlock = updateBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
