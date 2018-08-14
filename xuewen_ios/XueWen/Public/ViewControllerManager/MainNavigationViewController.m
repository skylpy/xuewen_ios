//
//  MainNavigationViewController.m
//  HappySelling
//
//  Created by iOS李鹏 on 2017/6/6.
//  Copyright © 2017年 iOS李鹏. All rights reserved.
//

#import "MainNavigationViewController.h"

@interface MainNavigationViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *line;

@end

@implementation MainNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 去除导航栏底部细线
//    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:(UIBarMetricsDefault)];
//    self.navigationBar.shadowImage = [UIImage new];
    // 自定义底部细线
//    [self.navigationBar addSubview:self.line];
//    self.line.sd_layout.leftSpaceToView(self.navigationBar,0).rightSpaceToView(self.navigationBar,0).bottomSpaceToView(self.navigationBar,0).heightIs(0.5);
    
    
    
    // 导航条背景
//    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:Color(@"#454F58")] forBarMetrics:(UIBarMetricsDefault)];
    
    // 标题颜色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:Color(@"#333333"),NSFontAttributeName:[UIFont fontWithName:kRegFont size:18]}];
    
    //返回箭头颜色设置
//    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
}

- (UIView *)line{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = COLOR(221, 221, 221);
    }
    return _line;
}

- (void)setHiddenLine:(BOOL)hiddenLine{
    _hiddenLine = hiddenLine;
    _line.hidden = hiddenLine;
}
/**
 *  拦截push控制器
 */

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(self.viewControllers.count < 1){
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        viewController.navigationItem.backBarButtonItem = backItem;

    }else{
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationBar setBackIndicatorImage:[[UIImage imageNamed:@"navBack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
        [self.navigationBar setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:@"navBack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        viewController.navigationItem.backBarButtonItem = backItem;
//         ------ 设置返回手势
        self.interactivePopGestureRecognizer.enabled = YES;
        self.interactivePopGestureRecognizer.delegate = self;
    }
    [super pushViewController:viewController animated:YES];
}


/*
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(self.viewControllers.count < 1){

        
    }else{
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [self getBackBtnItemWithImgName:@"navBack"];

        //         ------ 设置返回手势
        self.interactivePopGestureRecognizer.enabled = YES;
        self.interactivePopGestureRecognizer.delegate = self;
    }
    [super pushViewController:viewController animated:YES];
}
 */
 


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
