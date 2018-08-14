//
//  PurchaseRecordViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/12/19.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "PurchaseRecordViewController.h"
#import "SGPageView.h"
#import "MyOrderViewController.h"
@interface PurchaseRecordViewController ()<SGPageTitleViewDelegate,SGPageContentViewDelegare>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;
@property (nonatomic, strong) MyOrderViewController *uncompleteOrder;  // 未完成
@property (nonatomic, strong) MyOrderViewController *completeOrder;    // 已完成
@property (nonatomic, strong) MyOrderViewController *closedOrder;      // 已关闭

@end

@implementation PurchaseRecordViewController
#pragma mark- SGDeledate
- (void)SGPageContentView:(SGPageContentView *)SGPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}

#pragma mark- CustomMethod
- (void)initUI{
    self.title = @"我的订单";
    self.view.backgroundColor = DefaultBgColor;
    [self.view addSubview:self.pageContentView];
    [self.view addSubview:self.pageTitleView];
    //为了阴影
    [self.view bringSubviewToFront:self.pageTitleView];
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
        _pageTitleView = [[SGPageTitleView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 45) delegate:self titleNames:@[@"待付款",@"已完成",@"已关闭"]];
        _pageTitleView.isNeedBounces = NO;
        _pageTitleView.titleColorStateNormal = DefaultTitleAColor;
        _pageTitleView.titleColorStateSelected = kThemeColor;
        _pageTitleView.indicatorColor = kThemeColor;
        _pageTitleView.indicatorHeight = 5.0f;
        _pageTitleView.indicatorWidth = 40;
        _pageTitleView.indicatorLengthStyle = SGIndicatorLengthTypeEqual;
        _pageTitleView.layer.shadowColor = COLOR(204, 208, 225).CGColor;
        _pageTitleView.layer.shadowOpacity = 0.2;
        _pageTitleView.layer.shadowOffset = CGSizeMake(0, 2.5);
        
    }
    return _pageTitleView;
}

- (SGPageContentView *)pageContentView{
    if (!_pageContentView) {
        _pageContentView = [[ SGPageContentView alloc] initWithFrame:CGRectMake(0, 45, kWidth, kHeight - 45 - 64 ) parentVC:self childVCs:@[self.uncompleteOrder,self.completeOrder,self.closedOrder]];
        _pageContentView.delegatePageContentView = self;
    }
    return _pageContentView;
}

- (MyOrderViewController *)uncompleteOrder{
    if (!_uncompleteOrder) {
        _uncompleteOrder = [[MyOrderViewController alloc] initWithType:@"0"];
    }
    return _uncompleteOrder;
}

- (MyOrderViewController *)completeOrder{
    if (!_completeOrder) {
        _completeOrder = [[MyOrderViewController alloc] initWithType:@"1"];
    }
    return _completeOrder;
}

- (MyOrderViewController *)closedOrder{
    if (!_closedOrder) {
        _closedOrder = [[MyOrderViewController alloc] initWithType:@"2"];
    }
    return _closedOrder;
}

#pragma mark- LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Analytics event:EventMyOrder label:nil];
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
