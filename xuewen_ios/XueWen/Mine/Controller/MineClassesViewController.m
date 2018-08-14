//
//  MineClassesViewController.m
//  XueWen
//
//  Created by ShaJin on 2018/1/17.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "MineClassesViewController.h"
#import "SGPageView.h"
#import "MyClassesViewController.h"
@interface MineClassesViewController ()<SGPageTitleViewDelegate,SGPageContentViewDelegare>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@end

@implementation MineClassesViewController
#pragma mark- CustomMethod
- (void)initUI{
    self.title = @"我的课程";
    [self.view addSubview:self.pageTitleView];
    [self.view addSubview:self.pageContentView];
    // 阴影
    [self.view bringSubviewToFront:self.pageTitleView];
}

- (void)loadData{
    
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kNaviBarH - kBottomH - 50;
}
#pragma mark- Setter
#pragma mark- Getter
- (SGPageContentView *)pageContentView{
    if (!_pageContentView) {
        MyClassesViewController *myClassVC = [[MyClassesViewController alloc] initWithType:kMyClasses];
        MyClassesViewController *companyClassVC = [[MyClassesViewController alloc] initWithType:kCompanyClasses];
        _pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 45, kWidth, kHeight - 45 - 64) parentVC:self childVCs:@[myClassVC,companyClassVC]];
        _pageContentView.delegatePageContentView = self;
        [_pageContentView.collectionView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    }
    return _pageContentView;
}

- (SGPageTitleView *)pageTitleView{
    if (!_pageTitleView){
        _pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0,0, kWidth, 45) delegate:self titleNames:@[@"我的课程",@"企业课程"]];
        _pageTitleView.indicatorLengthStyle = SGIndicatorLengthTypeEqual;
        _pageTitleView.titleColorStateNormal = DefaultTitleAColor;
        _pageTitleView.titleColorStateSelected = kThemeColor;
        _pageTitleView.indicatorColor = kThemeColor;
        _pageTitleView.indicatorHeight = 3.0;
        _pageTitleView.layer.shadowColor = (COLOR(204, 208, 225)).CGColor;
        _pageTitleView.layer.shadowOffset = CGSizeMake(0, 5);
        _pageTitleView.layer.shadowRadius = 5;
        _pageTitleView.layer.shadowOpacity = 0.2;
        
        // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
        _pageTitleView.layer.masksToBounds = NO;
    }
    return _pageTitleView;
}

#pragma mark- LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
#pragma mark- SGPageViewDelegate
- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex{
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}

- (void)SGPageContentView:(SGPageContentView *)SGPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex{
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}
@end
