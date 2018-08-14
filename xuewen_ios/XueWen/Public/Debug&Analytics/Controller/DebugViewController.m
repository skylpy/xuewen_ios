//
//  DebugViewController.m
//  XueWen
//
//  Created by ShaJin on 2018/3/19.
//  Copyright © 2018年 ShaJin. All rights reserved.
//
// 用于调试的界面，只有测试账号能看到
#import "DebugViewController.h"

@interface DebugViewController ()

@end

@implementation DebugViewController

#pragma mark- CustomMethod
- (void)initUI{
    self.title = @"测试";
    self.view.backgroundColor = DefaultBgColor;
}

- (BOOL)hiddenNaviLine{
    RandColor;
    
    return NO;
}
#pragma mark- Setter
#pragma mark- Getter
#pragma mark- LifeCycle
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
