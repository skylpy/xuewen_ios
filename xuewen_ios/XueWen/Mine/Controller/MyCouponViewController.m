//
//  MyCouponViewController.m
//  XueWen
//
//  Created by ShaJin on 2018/3/5.
//  Copyright © 2018年 ShaJin. All rights reserved.
//
// 我的优惠券页面
#import "MyCouponViewController.h"

#import "SGPageView.h"
#import "CouponListViewController.h"
@interface MyCouponViewController ()<SGPageTitleViewDelegate,SGPageContentViewDelegare>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@end

@implementation MyCouponViewController
#pragma mark- PageViewDelegate
- (void)SGPageContentView:(SGPageContentView *)SGPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}

#pragma mark- CustomMethod
- (void)initUI{
    self.title = @"我的奖学金";
    self.view.backgroundColor = DefaultBgColor;
    [self.view addSubview:self.pageTitleView];
    [self.view addSubview:self.pageContentView];
}

- (void)loadData{
    
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kNaviBarH - kBottomH - 50;
}

#pragma mark- Setter
#pragma mark- Getter

- (SGPageTitleView *)pageTitleView{
    if (!_pageTitleView) {
        _pageTitleView = [[SGPageTitleView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 45) delegate:self titleNames:@[@"未使用",@"已使用"]];
        _pageTitleView.isNeedBounces = NO;
        _pageTitleView.indicatorLengthStyle = SGIndicatorLengthTypeEqual;
        _pageTitleView.titleColorStateNormal = DefaultTitleAColor;
        _pageTitleView.titleColorStateSelected = kThemeColor;
        _pageTitleView.indicatorColor = kThemeColor;
        _pageTitleView.indicatorHeight = 3.0;
        _pageTitleView.layer.shadowColor = (COLOR(204, 208, 225)).CGColor;
        _pageTitleView.layer.shadowOffset = CGSizeMake(0, 5);
        _pageTitleView.layer.shadowRadius = 5;
        _pageTitleView.layer.shadowOpacity = 0.2;
        _pageTitleView.layer.masksToBounds = NO;
        
    }
    return _pageTitleView;
}

- (SGPageContentView *)pageContentView{
    if (!_pageContentView) {
        CouponListViewController *hasUsedVC = [[CouponListViewController alloc] initWithHasUsed:YES];
        CouponListViewController *unUsedVC = [[CouponListViewController alloc] initWithHasUsed:NO];
        _pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 45, kWidth, kHeight - kNaviBarH - 45) parentVC:self childVCs:@[unUsedVC,hasUsedVC]];
        _pageContentView.delegatePageContentView = self;
    }
    return _pageContentView;
}

#pragma mark- LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Analytics event:EventMyCoupon label:nil];
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
