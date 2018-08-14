//
//  SelectCouponViewController.m
//  XueWen
//
//  Created by ShaJin on 2018/3/5.
//  Copyright © 2018年 ShaJin. All rights reserved.
//
// 支付页面选择优惠券
#import "SelectCouponViewController.h"
#import "CouponModel.h"
#import "CouponCell.h"

static int page = 1;

@interface SelectCouponViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) void (^CompleteBlock)(NSString *coupons ,float price);
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CouponModel *> *coupons;
@property (nonatomic, assign) NSInteger currentSection;
@property (nonatomic, assign) float price;
@property (nonatomic, strong) NSMutableArray<CouponModel *> *selectCoupon;

@end

@implementation SelectCouponViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponModel *coupon = self.coupons[indexPath.section];
    if (coupon.canUse) {
        if ([self.selectCoupon containsObject:coupon]) {
            [self.selectCoupon removeObject:coupon];
        }else{
            float price = 0.0;
            for (CouponModel *model in self.selectCoupon) {
                price += [model.price floatValue];
            }
            if (self.price <= price) {
                // 代金券已足够支付该课程了
                [XWPopupWindow popupWindowsWithTitle:@"提示" message:@"奖学金已足够支付该课程了" buttonTitle:@"好的" buttonBlock:nil];
            }else{
                [self.selectCoupon addObject:coupon];
            }
        }
        [self.tableView reloadData];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (section == 0) ? 15 : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.coupons.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    CouponModel *model = self.coupons[indexPath.section];
    cell.model = model;
    cell.hasSelect = [self.selectCoupon containsObject:model];
    return cell;
}
#pragma mark- CustomMethod
- (void)confirmAction:(UIButton *)sender{
    if (self.CompleteBlock) {
        float price = 0.0;
        NSString *coupons = @"";
        for (CouponModel *coupon in self.selectCoupon) {
            price += [coupon.price floatValue];
            if (coupons.length > 0) {
                coupons = [NSString stringWithFormat:@"%@,%@",coupons,coupon.couponID];
            }else{
                coupons = coupon.couponID;
            }
        }
        self.CompleteBlock(coupons,price);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)hiddenNaviLine{
    return NO;
}

- (void)initUI{
    self.title = @"使用奖学金";
    self.view.backgroundColor = DefaultBgColor;
    self.scrollView = self.tableView;
    [self addHeaderWithAction:@selector(loadCoupons)];
    [self addFooterWithAction:@selector(loadMore)];
    [self beginLoadData];
    self.currentSection = -1;
    [self setRightItemWithTitle:@"确定" action:@selector(confirmAction:)];
}

- (void)loadCoupons{
    page = 1;
    WeakSelf;
    [XWNetworking getCouponListWithType:@"1" page:page completeBlock:^(NSArray *array, NSInteger totalCount, BOOL isLast) {
        [weakSelf loadedDataWithArray:array isLast:isLast];
    }];
}

- (void)loadMore{
    page++;
    WeakSelf;
    [XWNetworking getCouponListWithType:@"1" page:page completeBlock:^(NSArray *array, NSInteger totalCount, BOOL isLast) {
        [weakSelf loadedDataWithArray:array isLast:isLast];
    }];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kNaviBarH - kBottomH - 50;
}
#pragma mark- Setter
#pragma mark- Getter
- (NSMutableArray<CouponModel *> *)selectCoupon{
    if (!_selectCoupon) {
        _selectCoupon = [NSMutableArray array];
    }
    return _selectCoupon;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView tableViewWithFrame:CGRectMake(0, 0, kWidth, kHeight - kBottomH - kNaviBarH) style:UITableViewStylePlain delegate:self dataSource:self registerClass:@{@"CouponCell" : CellID}];
    }
    return _tableView;
}

- (NSMutableArray<CouponModel *> *)coupons{
    if (!_coupons) {
        _coupons = self.array;
    }
    return _coupons;
}
#pragma mark- LifeCycle

- (instancetype)initWithPrice:(float)price completeBlock:(void (^)(NSString *coupons ,float price))complete{
    if (self = [super init]) {
        self.price = price;
        self.CompleteBlock = complete;
    }
    return self;
}
@end
