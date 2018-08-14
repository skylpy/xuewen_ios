//
//  PayView.m
//  XueWen
//
//  Created by ShaJin on 2017/12/8.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "PayView.h"
#import "PayViewCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
@interface PayView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) CGFloat space; // 确认按钮到tableView之间的距离
@property (nonatomic, assign) NSInteger selectIdx;
@end
@implementation PayView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PayViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.canSelect) {
        cell.isSelect = YES;
        self.selectIdx = indexPath.row;
        for (int i = 0; i < self.dataSource.count; i++) {
            PayViewCell *aCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell != aCell) {
                aCell.isSelect = NO;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    NSDictionary *dic = self.dataSource[indexPath.row];
    [cell setTitle:dic[@"title"] content:dic[@"content"] icon:LoadImage(dic[@"icon"])];
    cell.canSelect = YES ;
    cell.isSelect = indexPath.row == 0 ;
    cell.isFirst = indexPath.row == 0 ;
    return cell;
}
#pragma mark- CustomMethod
- (void)initUI{
    self.cornerRadius = 0.0;
    [self addSubview:self.titleLabel];
    [self addSubview:self.cancelButton];
    [self addSubview:self.tableView];
    [self addSubview:self.confirmButton];
}

- (void)cancelAction:(UIButton *)sender{
    [self dismiss];
}

- (void)confirmAction:(UIButton *)sender{
    NSLog(@"确认支付");
    NSLog(@"selectIdx is %ld", self.selectIdx);
    [Analytics event:EventRecharge label:[NSString stringWithFormat:@"%d",(int)self.price]];
    if (self.selectIdx == 0) { // 支付宝支付
        [XWNetworking getZhiFuBaoParameterWithPrice:self.price withCompletionBlock:^(NSString *orderString) {
            AlipaySDK *pay = [AlipaySDK defaultService];
            [pay payOrder:orderString fromScheme:@"XueWen" callback:^(NSDictionary *resultDic) {
                
            }];
        }];
    }else{ // 微信支付
        NSLog(@"微信支付");
        [XWHttpTool getWXParamterWithPrice:self.price success:^(id result) {
            PayReq *req = [[PayReq alloc] init];
            req.partnerId = result[@"partnerid"];
            req.package = @"Sign=WXPay";
            req.prepayId = result[@"prepayid"];
            req.timeStamp = [result[@"timestamp"] intValue];
            req.nonceStr = result[@"noncestr"];
            req.sign = result[@"sign"];
            [WXApi sendReq:req];
        } failure:^(NSString *error) {
            
        }];
    }
    
}

- (void)show{
    [super show];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:PaySucceed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:PayFailure object:nil];
}

- (void)dismiss{
    [super dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark- Setter
#pragma mark- Getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
        _titleLabel.textColor = DefaultTitleAColor;
        _titleLabel.textAlignment = 1 ;
        _titleLabel.text = @"请选择支付方式";
    }
    return _titleLabel;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:0];
        _cancelButton.frame = CGRectMake(self.width - 60, 0, 60, 44);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:kThemeColor forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:0];
        _confirmButton.frame = CGRectMake(15, 164 + self.space, self.width - 30, 44);
        [_confirmButton setTitle:@"确认支付" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setBackgroundColor:kThemeColor];
        [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.width, 120)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = 0;
        [_tableView registerClass:[PayViewCell class] forCellReuseIdentifier:@"CellID"];
    }
    return _tableView;
}

- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource =
  @[
    @{
        @"title":@"支付宝支付",
        @"content":@"推荐安装支付宝的用户使用",
        @"icon":@"icoZhifubao",
        },
    @{
        @"title":@"微信支付",
        @"content":@"推荐安装微信的用户使用",
        @"icon":@"icoWechat",
        }
    ];
    }
    return _dataSource;
}

#pragma mark- LifeCycle
- (instancetype)initWithPrice:(NSInteger)price{
    CGFloat space = 16;
    CGFloat height = (IsIPhoneX ? 250 : 216) + space;
    self = [super initWithFrame:CGRectMake(0, kHeight - height, kWidth, height)];
    if (self) {
        self.price = price;
        self.space = space;
        [self initUI];
    }
    return self;
}

- (void)dealloc{
    NSLog(@"%@ dealloc",self.class);
}
@end
