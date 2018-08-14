//
//  InvitationDetailViewController.m
//  XueWen
//
//  Created by ShaJin on 2018/3/8.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "InvitationDetailViewController.h"
#import "InvitationHeaderView.h"
#import "InvitationDetailCell.h"
#import "InvitationedModel.h"
#import "InvitationDetailListViewController.h"
#import "SGPageView.h"
@interface InvitationDetailViewController ()<SGPageTitleViewDelegate,SGPageContentViewDelegare,UIPickerViewDelegate>

@property (nonatomic, strong) InvitationHeaderView *headerView;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) InvitationDetailListViewController *companyViewController;
@property (nonatomic, strong) InvitationDetailListViewController *personalViewController;
@property (nonatomic, strong) InvitationDetailListViewController *currentViewController;
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;
@property (nonatomic, strong) BaseAlertView *alertView;
@property (nonatomic, strong) UIPickerView *datePicker;
@property (nonatomic, strong) NSArray *dateArray;

@end

@implementation InvitationDetailViewController
#pragma mark- SGDeledate
- (void)SGPageContentView:(SGPageContentView *)SGPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
    self.currentViewController = targetIndex == 0 ? self.companyViewController : self.personalViewController;
    [self.currentViewController beginLoadData];
}


- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
    self.currentViewController = selectedIndex == 0 ? self.companyViewController : self.personalViewController;
    [self.currentViewController beginLoadData];
}

#pragma mark- PickerDeleaget
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dateArray.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)componen{
    return self.dateArray[row];
}

#pragma mark- CustomMethod
- (void)show{
    [self.alertView show];
}

- (void)confirmAction:(UIButton *)sender{
    NSInteger index = [self.datePicker selectedRowInComponent:0];
    self.date = self.dateArray[index];
    self.companyViewController.date = self.date;
    self.personalViewController.date = self.date;
    [self.currentViewController beginLoadData];
    [self.alertView dismiss];
    
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kNaviBarH - kBottomH - 50;
}

- (void)cancelAction:(UIButton *)sender{
    [self.alertView dismiss];
}

- (void)initUI{
    self.title = @"邀请明细";
    self.view.backgroundColor = DefaultBgColor;
    [self setRightItemWithImage:LoadImage(@"ico_date") action:@selector(show)];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.pageTitleView];
    [self.view addSubview:self.pageContentView];
    [self.view bringSubviewToFront:self.pageTitleView]; // 为了阴影
}

- (void)loadData{
    WeakSelf;
    [XWNetworking getInvitationCountWithCompleteBlock:^(NSInteger people, NSString *coupon) {
        [weakSelf.headerView setCount:people money:coupon];
    }];
}

- (BOOL)hiddenNaviLine{
    return NO;
}
#pragma mark- Setter
- (void)setDate:(NSString *)date{
    _date = date;
    [self beginLoadData];
}

#pragma mark- Getter
- (InvitationHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [InvitationHeaderView new];
        WeakSelf;
        _headerView.CompleteBlock = ^(NSString *date) {
            weakSelf.date = date;
        };
    }
    return _headerView;
}

- (SGPageTitleView *)pageTitleView{
    if (!_pageTitleView) {
        _pageTitleView = [[SGPageTitleView alloc] initWithFrame:CGRectMake(0, 63, kWidth, 45) delegate:self titleNames:@[@"企业明细",@"个人明细"]];
        _pageTitleView.isNeedBounces = NO;
        _pageTitleView.titleColorStateNormal = DefaultTitleAColor;
        UIColor *selectColor = Color(@"#192041");
        _pageTitleView.titleColorStateSelected = selectColor;
        _pageTitleView.indicatorColor = selectColor;
        _pageTitleView.indicatorHeight = 3.0f;
        _pageTitleView.indicatorWidth = 40;
        _pageTitleView.indicatorLengthStyle = SGIndicatorLengthTypeEqual;
        _pageTitleView.layer.shadowColor = COLOR(204, 208, 225).CGColor;
        _pageTitleView.layer.shadowOpacity = 0.2;
        _pageTitleView.layer.shadowOffset = CGSizeMake(0, 3);
        _pageTitleView.backgroundColor = [UIColor whiteColor];
        
    }
    return _pageTitleView;
}

- (SGPageContentView *)pageContentView{
    if (!_pageContentView) {
        _pageContentView = [[ SGPageContentView alloc] initWithFrame:CGRectMake(0, 108, kWidth, kHeight - kNaviBarH - 108  ) parentVC:self childVCs:@[self.companyViewController,self.personalViewController]];
        _pageContentView.delegatePageContentView = self;
    }
    return _pageContentView;
}

- (InvitationDetailListViewController *)companyViewController{
    if (!_companyViewController) {
        _companyViewController = [[InvitationDetailListViewController alloc] initWithCompany:YES];
        _companyViewController.date = self.dateArray[0];
    }
    return _companyViewController;
}

- (InvitationDetailListViewController *)personalViewController{
    if (!_personalViewController) {
        _personalViewController = [[InvitationDetailListViewController alloc] initWithCompany:NO];
        _personalViewController.date = self.dateArray[0];
    }
    return _personalViewController;
}

- (BaseAlertView *)alertView{
    if (!_alertView) {
        _alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, kHeight - 194 - kBottomH, kWidth, 194 + kBottomH)];
        _alertView.animationType = kAnimationBottom;
        _alertView.cornerRadius = 0;
        _alertView.backgroundColor = DefaultBgColor;
        // 背景
        UIView *backgroundView = [UIView new];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [_alertView addSubview:backgroundView];
        backgroundView.sd_layout.topSpaceToView(_alertView, 44).leftSpaceToView(_alertView, 0 ).bottomSpaceToView(_alertView, 0).rightSpaceToView(_alertView, 0);
        
        [backgroundView addSubview:self.datePicker];
        self.datePicker.sd_layout.topSpaceToView(backgroundView, 0).leftSpaceToView(backgroundView, 0).bottomSpaceToView(backgroundView, kBottomH).rightSpaceToView(backgroundView, 0);
        // 确认
        UIButton *confirmButton = [UIButton buttonWithType:0];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:kThemeColor forState:UIControlStateNormal];
        confirmButton.titleLabel.font = kFontSize(16);
        [confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:confirmButton];
        confirmButton.sd_layout.topSpaceToView(_alertView, 0).rightSpaceToView(_alertView, 0).heightIs(44).widthIs(70);
        
        // 取消
        UIButton *cancelButton = [UIButton buttonWithType:0];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:DefaultTitleBColor forState:UIControlStateNormal];
        cancelButton.titleLabel.font = kFontSize(16);
        [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:cancelButton];
        cancelButton.sd_layout.topSpaceToView(_alertView, 0).leftSpaceToView(_alertView, 0).heightIs(44).widthIs(70);
        
        
    }
    return _alertView;
}

- (UIPickerView *)datePicker{
    if (!_datePicker) {
        _datePicker = [UIPickerView new];
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
    }
    return _datePicker;
}

- (NSArray *)dateArray{
    if (!_dateArray) {
        NSString *date = [NSDate dateWithFormat:@"YYYY-MM"];
        NSArray *array = [date componentsSeparatedByString:@"-"];
        if (array.count == 2) {
            NSMutableArray *mArray = [NSMutableArray array];
            int year = [array[0] intValue];
            int month = [array[1] intValue];
            for (int i = 0; i < 12; i++) {
                [mArray addObject:[NSString stringWithFormat:@"%d-%02d",year,month--]];
                if (month <= 0) {
                    month = 12;
                    year -= 1;
                }
            }
            _dateArray = mArray;
        }
    }
    return _dateArray;
}

#pragma mark- LifeCycle
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Analytics event:EventInvitationDetail label:nil];
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
