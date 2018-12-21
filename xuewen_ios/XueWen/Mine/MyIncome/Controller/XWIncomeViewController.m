//
//  XWIncomeViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWIncomeViewController.h"
#import "XWIncomeHeaderView.h"
#import "SGPageView.h"
#import "XWIncomeListController.h"

@interface XWIncomeViewController () <SGPageTitleViewDelegate, SGPageContentViewDelegare>

@property (nonatomic, strong) XWIncomeHeaderView *headerView;
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;
@property (nonatomic, strong) XWIncomeListController *brokerageVC;
@property (nonatomic, strong) XWIncomeListController *redpacketVC;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation XWIncomeViewController

#pragma mark - Getter
- (XWIncomeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[XWIncomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 151)];
    }
    return _headerView;
}

- (SGPageTitleView *)pageTitleView{
    if (!_pageTitleView) {
        _pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 152, kWidth, 40) delegate:self titleNames:@[@"佣金收益", @"红包收益"]];
        _pageTitleView.isNeedBounces = NO;
        _pageTitleView.titleColorStateNormal = Color(@"#666666");
        _pageTitleView.titleColorStateSelected = Color(@"#3E7EFF");
        _pageTitleView.isShowIndicator = NO;
        _pageTitleView.backgroundColor = [UIColor whiteColor];
    }
    return _pageTitleView;
}

- (SGPageContentView *)pageContentView{
    if (!_pageContentView) {
        _pageContentView = [SGPageContentView pageContentViewWithFrame:CGRectMake(0, 202, kWidth, kHeight-202) parentVC:self childVCs:@[self.brokerageVC, self.redpacketVC]];
        _pageContentView.delegatePageContentView = self;
    }
    return _pageContentView;
}

- (XWIncomeListController *)brokerageVC{
    if (!_brokerageVC) {
        _brokerageVC = [[XWIncomeListController alloc] init];
        _brokerageVC.type = @"2";
    }
    return _brokerageVC;
}

- (XWIncomeListController *)redpacketVC{
    if (!_redpacketVC) {
        _redpacketVC = [[XWIncomeListController alloc] init];
        _redpacketVC.type = @"1";
    }
    return _redpacketVC;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = Color(@"#EEEEEE");
    }
    return _lineView;
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - kNaviBarH;;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadData];
}

- (void)initUI{
    self.title = @"我的收益";
    self.view.backgroundColor = Color(@"#f3f3f3");
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.pageTitleView];
    [self.view addSubview:self.pageContentView];
    [self.pageTitleView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.pageTitleView);
        make.centerY.mas_equalTo(self.pageTitleView);
        make.size.mas_equalTo(CGSizeMake(1, 27));
    }];
}

- (BOOL)hiddenNaviLine{
    return NO;
}

- (void)loadData{
    XWWeakSelf
    [XWHttpTool getPayeeAccountSuccess:^(NSString *bonusesPrice, NSString *payeeAccount) {
        weakSelf.headerView.bonusesPrice = bonusesPrice;
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showTipMessageInView:errorInfo];
    }];
}

#pragma mark- SGPageViewDelegate
- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex{
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}

- (void)SGPageContentView:(SGPageContentView *)SGPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex{
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
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
