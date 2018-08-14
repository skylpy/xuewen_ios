//
//  TransactionDetailsViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/11/16.
//  Copyright © 2017年 ShaJin. All rights reserved.
//
// 交易明细界面
#import "TransactionDetailsViewController.h"
#import "SGPageView.h"
#import "CoastDetailViewController.h"

@interface TransactionDetailsViewController ()<UINavigationControllerDelegate,SGPageTitleViewDelegate, SGPageContentViewDelegare>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@end

@implementation TransactionDetailsViewController

#pragma mark- CustomMethod
- (void)initUI{
    self.title = @"交易明细";

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pageTitleView];
    
    [self.view addSubview:self.pageContentView];
    //为了阴影
    [self.view bringSubviewToFront:self.pageTitleView];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kNaviBarH - kBottomH - 50;
}

#pragma mark- LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

#pragma mark- SGDeledate

- (void)SGPageContentView:(SGPageContentView *)SGPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}


- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}


#pragma mark - --- Lazy Load ---

- (SGPageTitleView *)pageTitleView{
    if (!_pageTitleView) {
        _pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, kWidth, 45) delegate:self titleNames:@[@"充值明细",@"消费明细"]];
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
        CGFloat contentViewHeight = kHeight - kNaviBarH - kStasusBarH - self.pageTitleView.height;
        CoastDetailViewController *leftVc = [CoastDetailViewController new];
        leftVc.type = CoastIn;
        CoastDetailViewController *rightVc = [CoastDetailViewController new];
        rightVc.type = CoastOut;
        _pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, self.pageTitleView.bottom, kWidth, contentViewHeight) parentVC:self childVCs:@[leftVc,rightVc]];
        _pageContentView.delegatePageContentView = self;
        [_pageContentView.collectionView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    }
    return _pageContentView;
}

@end
