//
//  PayStatusVC.m
//  XueWen
//
//  Created by Pingzi on 2017/12/8.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "PayStatusVC.h"



@interface PayStatusVC ()<UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView  *statusImgV;
@property (nonatomic, strong) UILabel *statusLB;
@property (nonatomic, strong) UIButton *statusBtn;

@end

@implementation PayStatusVC

#pragma mark - --- Life Cycle ---

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
}

// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:!isShowHomePage animated:YES];
}

#pragma mark - --- Custom Method ---

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.statusImgV];
    [self.view addSubview:self.statusLB];
    [self.view addSubview:self.statusBtn];
    switch (self.status)
    {
        case PaySuccess:
        {
            self.title = @"支付成功";
            self.statusLB.text = @"支付成功";
            self.statusLB.textColor = COLOR(14, 201, 80);
            self.statusImgV.image = LoadImage(@"payIcoSuccess");
            [self.statusBtn setTitle:@"确定" forState:UIControlStateNormal];
        }
            break;
        case PayFail:
        {
            self.title = @"支付失败";
            self.statusLB.text = @"支付失败，请重新尝试";
            self.statusLB.textColor = COLOR(251, 27, 27);
            self.statusImgV.image = LoadImage(@"payIcoFailure");
            [self.statusBtn setTitle:@"继续支付" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)buttonAction
{
    switch (self.status)
    {
        case PaySuccess:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case PayFail:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - --- Lazy Load ---

- (UIImageView *)statusImgV
{
    if (!_statusImgV)
    {
        _statusImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/2.0 - 35, 60, 70, 70)];
    }
    return _statusImgV;
}

- (UILabel *)statusLB
{
    if (!_statusLB)
    {
        _statusLB = [UILabel creatLabelWithFrameX:kWidth/2.0 - 90 Y:self.statusImgV.bottom + 15 W:180 H:15 Text:@"" fontSize:15 TextColor:[UIColor whiteColor] BGColor:[UIColor clearColor]];
        _statusLB.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLB;
}

- (UIButton *)statusBtn
{
    if (!_statusBtn)
    {
        _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusBtn.backgroundColor = kThemeColor;
        _statusBtn.frame = CGRectMake(15, self.statusLB.bottom + 50, kWidth - 30, 44);
        [_statusBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        ViewRadius(_statusBtn, 1.0);
    }
    return _statusBtn;
}



@end
