//
//  XWHomeController.m
//  XueWen
//
//  Created by Karron Su on 2018/7/19.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHomeController.h"
#import "XWHomeBaseController.h"
#import "XWBBusinessController.h"
#import "MainNavigationViewController.h"
#import "ClassesSearchViewController.h"
#import "XWRedPakViewController.h"

@interface XWHomeController () <YNPageViewControllerDataSource, YNPageViewControllerDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *searchBtn;
/** 用于判断是否在顶部*/
@property (nonatomic, assign) BOOL isTop;
/** 滚动视图*/
@property (nonatomic, strong) UIScrollView *scrView;

//悬浮按钮
@property(nonatomic,strong) UIButton * suspensionBtn;
//悬浮按钮 状态 点击或拖动
@property(nonatomic,assign) NSInteger suspensionType;

@end

@implementation XWHomeController

#pragma mark - Getter
- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setTitle:@"关键词、老师、课程" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:Color(@"#999999") forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:12];
        _searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _searchBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _searchBtn.backgroundColor = Color(@"#EFEFF4");
        [_searchBtn rounded:12];
        _searchBtn.frame = CGRectMake(7, 6+kStasusBarH, kWidth-14, 26);
        @weakify(self)
        [[_searchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [Analytics event:EventHomeSearch];
            MainNavigationViewController *navi = [[MainNavigationViewController alloc] initWithRootViewController:[ClassesSearchViewController new]];
            [self presentViewController:navi animated:NO completion:nil];
        }];
    }
    return _searchBtn;
}

- (UIView *)topView{
    if (!_topView) {
        CGFloat height = 35;
        
        if ([[XWInstance shareInstance].userInfo.company_id isEqualToString:@"0"]) { // 个人用户
            height = 45;
        }else{
            height = 35;
        }
        
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, height+kStasusBarH)];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

#pragma mark - lifecycle

+ (instancetype)homePageVC{
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionCenter;
    configration.headerViewCouldScale = NO;
    configration.headerViewScaleMode = YNPageHeaderViewScaleModeCenter;
    configration.showTabbar = YES;
    configration.showNavigation = NO;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = YES;
    configration.showBottomLine = NO;
    configration.scrollViewBackgroundColor = [UIColor whiteColor];
//    [XWInstance shareInstance].userInfo.company_id = @"0";
    if ([[XWInstance shareInstance].userInfo.company_id isEqualToString:@"0"]) { // 个人用户
        configration.menuHeight = 0;
    }else{
        configration.menuHeight = 45;
    }
    
    configration.lineColor = Color(@"#6699FF");
    configration.selectedItemColor = Color(@"#6699FF");
    configration.normalItemColor = Color(@"#000000");
    configration.suspenOffsetY = kStasusBarH;
    configration.headerViewCouldScrollPage = YES;
    
    configration.lineHeight = 3;
    
    configration.itemFont = [UIFont fontWithName:kMedFont size:17];
    configration.selectedItemFont = [UIFont fontWithName:kMedFont size:17];
    return [self homePageVCWithConfig:configration];
}

+ (instancetype)homePageVCWithConfig:(YNPageConfigration *)config{
    XWHomeController *vc = [XWHomeController pageViewControllerWithControllers:[self getArrayVCs]
                                                                                  titles:[self getArrayTitles]
                                                                                  config:config];
    vc.dataSource = vc;
    vc.delegate = vc;
    [vc.topView addSubview:vc.searchBtn];
    vc.headerView = vc.topView;
    vc.pageIndex = 0;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kStasusBarH)];
    view.backgroundColor = [UIColor whiteColor];
    [vc.view addSubview:view];
    
    return vc;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self.view addSubview:self.suspensionBtn];
//    
//    [self.suspensionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(60);
//        make.height.offset(54);
//        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-kHeight/2+60);
//        make.right.mas_equalTo(self.view.mas_right).offset(-30);
//    }];
}

- (UIButton *)suspensionBtn {
    if (!_suspensionBtn) {
        _suspensionBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [_suspensionBtn setImage:[UIImage imageNamed:@"red_envelopes"] forState:UIControlStateNormal];
        
        [_suspensionBtn addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
        [_suspensionBtn addTarget:self action:@selector(doClick:) forControlEvents:UIControlEventTouchUpInside];
        _suspensionType=0;
    }
    return _suspensionBtn;
}

-(void)doClick:(UIButton*)sender {
    
    if (self.suspensionType==0) {
        
        NSLog(@"1111");
        XWRedPakViewController * vc = [[XWRedPakViewController alloc] init];
        [[UIViewController getCurrentVC].navigationController pushViewController:vc animated:YES];
        
    }
    self.suspensionType=0;
}

- (void) dragMoving: (UIButton *) c withEvent:ev {
    
    self.suspensionType=1;
    c.center = [[[ev allTouches] anyObject] locationInView:self.view];
    NSLog(@"%f,,,%f",c.center.x,c.center.y);
}

#pragma mark - Custom Methods
+ (NSArray *)getArrayVCs{
    XWHomeBaseController *vc1 = [[XWHomeBaseController alloc] init];
    XWBBusinessController *vc2 = [[XWBBusinessController alloc] init];
    vc2.companyId = [XWInstance shareInstance].userInfo.company_id;
    if ([[XWInstance shareInstance].userInfo.company_id isEqualToString:@"0"]) { // 个人用户
        return @[vc1];
    }else{
        return @[vc1, vc2];
    }
    
}

+ (NSArray *)getArrayTitles{
    
    if ([[XWInstance shareInstance].userInfo.company_id isEqualToString:@"0"]) { // 个人用户
        return @[@"首页"];
    }else{
        NSString *string;
        if ([[XWInstance shareInstance].collegeName isEqualToString:@""] || [XWInstance shareInstance].collegeName == nil) {
            string = @"商学院";
        }else{
            string = [XWInstance shareInstance].collegeName;
        }
        return @[@"首页", string];
    }
}


- (void)tabbarDoubleClick{
    if (self.pageIndex == 0) {
        if (self.isTop) { // 在顶部,通知刷新
            [self postNotificationWithName:TabbarDoubleHome object:nil];
        }else{ // 不在顶部,返回到顶部
            if ([[XWInstance shareInstance].userInfo.company_id isEqualToString:@"0"]) {
                [self.scrView setContentOffset:CGPointMake(0, -65) animated:YES];
            }else{
                [self.scrView setContentOffset:CGPointMake(0, -100) animated:YES];
            }
        }
    }else{
        if (self.isTop) { // 在顶部,通知刷新
            [self postNotificationWithName:TabbarDoubleCollect object:nil];
        }else{ // 不在顶部,返回到顶部
            [self.scrView setContentOffset:CGPointMake(0, -100) animated:YES];
        }
    }
}

#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[XWHomeBaseController class]]) {
        [Analytics event:EventHome];
        self.scrView = [(XWHomeBaseController *)vc tableView];
        return [(XWHomeBaseController *)vc tableView];
    } else {
        [Analytics event:EventBusiness];
        self.scrView = [(XWBBusinessController *)vc tableView];
        return [(XWBBusinessController *)vc tableView];
    }
}
#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
//    NSLog(@"--- contentOffxrset = %f,    progress = %f", contentOffset, progress);
    if (progress == 1) {
        self.searchBtn.hidden = YES;
    }else{
        self.searchBtn.hidden = NO;
    }
    if ([[XWInstance shareInstance].userInfo.company_id isEqualToString:@"0"]) {
        if (contentOffset == -65 && progress == 0) {
            self.isTop = YES;
        }else{
            self.isTop = NO;
        }
    }else{
        if (contentOffset == -100 && progress == 0) {
            self.isTop = YES;
        }else{
            self.isTop = NO;
        }
    }
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
