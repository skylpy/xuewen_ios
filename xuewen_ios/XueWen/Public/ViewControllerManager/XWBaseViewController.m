//
//  XWBaseViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/12/26.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "XWBaseViewController.h"
#import "MainNavigationViewController.h"
@interface XWBaseViewController ()<UINavigationControllerDelegate>
@end

@implementation XWBaseViewController
#pragma mark- CustomMethod
- (void)initUI{
    
}

- (void)loadData{
    
}

/** 隐藏导航栏底部细线 */
- (BOOL)hiddenNaviLine{
    return YES;
}

/** 隐藏导航栏 */
- (BOOL)hiddenNavigationBar{
    return NO;
}

/** POP回到指定的界面 */
- (void)popToViewController:(NSString *)className{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:NSClassFromString(className)]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
}

/** AudioPlayerView的height */
- (CGFloat)audioPlayerViewHieght{
    return 0.0f;
}

- (void)showAudioPlayerView{
    if ([self audioPlayerViewHieght] > 0 && [XWAudioInstanceController hasInstance]) {
        UIView *playerView = [XWAudioInstanceController getPlayerView];
        playerView.frame = CGRectMake(0, kHeight, kWidth, 50);
        [self.view addSubview:playerView];
        [UIView animateWithDuration:0.25 animations:^{
            playerView.frame = CGRectMake(0, [self audioPlayerViewHieght], kWidth, 50);
            [XWAudioInstanceController shareInstance].origentFrame = playerView.frame;
        }];
    }
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_isDraging) {
        float y = scrollView.contentOffset.y;
        // 判断滑动方向
        static float oldY = 0;
        if ([XWAudioInstanceController hasInstance] && y != oldY) {
            if (y > oldY) {
                [XWAudioInstanceController playerViewDisappear];
            }else{
                [XWAudioInstanceController playerViewAppear];
            }
        }
        oldY = y;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    NSLog(@"开始滑动");
    _isDraging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    NSLog(@"结束滑动");
    _isDraging = NO;
}
#pragma mark- Setter
/** 设置右侧按钮（文字形式） */
- (UIButton *)setRightItemWithTitle:(NSString *)title action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:0];
    button.frame = CGRectMake(0, 0, 70, 20);
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:kThemeColor forState:UIControlStateNormal];
    [button setTitleColor:DefaultTitleDColor forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, button.width - [button.titleLabel.text widthWithSize:16], 0,0);
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
    return button;
}
//* 设置右侧按钮（图片形式） 
- (UIButton *)setRightItemWithImage:(UIImage *)image action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:0];
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
    return button;
}

#pragma mark- Getter

#pragma mark- LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self loadData];
    if ([self.navigationController isKindOfClass:[MainNavigationViewController class]]) {
        MainNavigationViewController *navi = (MainNavigationViewController *)self.navigationController;
        navi.hiddenLine = [self hiddenNaviLine];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAudioPlayerView) name:@"showAudioPlayerView" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 设置AudioPlayerView
    [self showAudioPlayerView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    [self removeNotification];
}

// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isSelf = [viewController isKindOfClass:[self class]];
    if (isSelf){
        [navigationController setNavigationBarHidden:(isSelf && [self hiddenNavigationBar]) animated:YES];
    }else if ([viewController isKindOfClass:[XWBaseViewController class]]){
        XWBaseViewController *baseViewController = (XWBaseViewController *)viewController;
        [navigationController setNavigationBarHidden:[baseViewController hiddenNavigationBar] animated:YES];
    }
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
