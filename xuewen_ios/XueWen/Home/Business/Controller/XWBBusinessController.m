//
//  XWBBusinessController.m
//  XueWen
//
//  Created by Karron Su on 2018/7/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWBBusinessController.h"
#import "XWHeaderBannerView.h"
#import "XWCompanyInfoCell.h"
#import "EScrollPageView.h"
#import "XWStudyRankView.h"
#import "XWCompanyCoursView.h"
#import "XWCompanyInfoModel.h"
#import "XWCompanyInfoController.h"

static NSString *const XWCompanyInfoCellID = @"XWCompanyInfoCellID";


@interface XWBBusinessController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XWHeaderBannerView *bannerView;

@property (nonatomic, retain) EScrollPageView *pageView;

@property (nonatomic, strong) XWStudyRankView *v1;
@property (nonatomic, strong) XWStudyRankView *v2;
@property (nonatomic, strong) XWCompanyCoursView *v3;

@property (nonatomic, strong) XWCompanyInfoModel *companyModel;

@property (nonatomic, strong) NSMutableArray *learnArray;

@end

@implementation XWBBusinessController

#pragma mark - Getter
- (XWHeaderBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[XWHeaderBannerView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 150)];
    }
    return _bannerView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kBottomH-kNaviBarH) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.backgroundColor = Color(@"#F4F4F4");
        table.tableHeaderView = self.bannerView;
        [table registerNib:[UINib nibWithNibName:@"XWCompanyInfoCell" bundle:nil] forCellReuseIdentifier:XWCompanyInfoCellID];
        _tableView = table;
    }
    return _tableView;
}

- (XWStudyRankView *)v1{
    if (!_v1) {
        _v1 = [[XWStudyRankView alloc] initWithPageTitle:@"课时排名"];
        _v1.isMyCompany = [self.companyId isEqualToString:[XWInstance shareInstance].userInfo.company_id];
    }
    return _v1;
}

- (XWStudyRankView *)v2{
    if (!_v2) {
        _v2 = [[XWStudyRankView alloc] initWithPageTitle:@"考核排名"];
        _v2.isMyCompany = [self.companyId isEqualToString:[XWInstance shareInstance].userInfo.company_id];
    }
    return _v2;
}

- (XWCompanyCoursView *)v3{
    if (!_v3) {
        _v3 = [[XWCompanyCoursView alloc] initWithPageTitle:@"企业课程"];
        _v3.isMyCompany = [self.companyId isEqualToString:[XWInstance shareInstance].userInfo.company_id];
    }
    return _v3;
}

- (NSMutableArray *)learnArray{
    if (!_learnArray) {
        _learnArray = [[NSMutableArray alloc] init];
    }
    return _learnArray;
}

- (XWCompanyInfoModel *)companyModel{
    if (!_companyModel) {
        _companyModel = [[XWCompanyInfoModel alloc] init];
        _companyModel.co_introduction = @"";
        _companyModel.co_name = @"";
    }
    return _companyModel;
}


- (EScrollPageView *)pageView{
    if (!_pageView) {
        
        NSArray *vs = @[self.v1,self.v2,self.v3];
        //设置一些参数等等。。。
        EScrollPageParam *param = [[EScrollPageParam alloc] init];
        //头部高度
        param.headerHeight = 60;
        //默认第1个
        param.segmentParam.startIndex = 0;
        //排列类型
        param.segmentParam.type = EPageContentBetween;
        //底部线颜色
        param.segmentParam.lineColor = Color(@"#6699FF");
        //背景颜色
        param.segmentParam.bgColor = 0xFFFFFF;
        //正常字体颜色
        param.segmentParam.textColor = 0x999999;
        //选中的颜色
        param.segmentParam.textSelectedColor = 0x6699FF;
        param.segmentParam.topLineColor = 0xffffff;
        param.segmentParam.botLineColor = 0xffffff;
        _pageView = [[EScrollPageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 988) dataViews:vs setParam:param];
        
    }
    return _pageView;
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    [self.view addSubview:self.tableView];
    [self setRefresh];
    [self addObserver];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - 50;;
}

- (BOOL)hiddenNavigationBar{
    return NO;
}

- (void)loadData{
    
    [MBProgressHUD showActivityMessageInWindow:@"正在加载..."];
    @weakify(self)
    /** 请求轮播图*/
    RACSignal *signal3 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        XWWeakSelf
        [XWNetworking getBannerImagesWithCompleteBlock:^(NSArray<BannerModel *> *banners) {
            weakSelf.bannerView.modelArray = [banners mutableCopy];
            [subscriber sendNext:@"1"];
        } cid:self.companyId];
        
        return nil;
    }];
    
    /** 公司信息*/
    RACSignal *signal4 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        XWWeakSelf
        [XWHttpTool getCompanyInfoWithID:self.companyId success:^(XWCompanyInfoModel *infoModel) {
            weakSelf.companyModel = infoModel;
            [weakSelf.tableView reloadData];
            [subscriber sendNext:@"1"];
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showTipMessageInWindow:errorInfo];
            [subscriber sendNext:@"0"];
            [weakSelf.tableView.mj_header endRefreshing];
        }];
        
        return nil;
    }];
    
    /** 请求大家在学*/
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        XWWeakSelf
        [XWHttpTool getLearningDataWithIsFirstLoad:YES size:@"3" success:^(NSMutableArray *array, BOOL isLast) {
            weakSelf.v3.learnArray = array;
            [subscriber sendNext:@"1"];
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showTipMessageInWindow:errorInfo];
            [subscriber sendNext:@"0"];
            [weakSelf.tableView.mj_header endRefreshing];
        } companyId:self.companyId];
        
        return nil;
    }];
    
    /** 请求企业课程*/
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        XWWeakSelf
        [XWHttpTool getCompanyCourseWithIsFirstLoad:YES size:@"12" success:^(NSMutableArray *array, BOOL isLast) {
            weakSelf.v3.companyCoursArray = array;
            [subscriber sendNext:@"1"];
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showTipMessageInWindow:errorInfo];
            [subscriber sendNext:@"0"];
            [weakSelf.tableView.mj_header endRefreshing];
        } companyId:self.companyId];

        return nil;
    }];
    
    /** 请求课时排名*/
    RACSignal *signal5 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        XWWeakSelf
        [XWHttpTool getCountPlayTimeWithOrderType:@"1" isFirstLoad:YES success:^(NSMutableArray *array, BOOL isLast, XWCountPlayTimeModel *rankModel) {
            self.v1.studyArray = array;
            self.v1.rankModel = rankModel;
            [subscriber sendNext:@"1"];
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showTipMessageInWindow:errorInfo];
            [subscriber sendNext:@"0"];
            [weakSelf.tableView.mj_header endRefreshing];
        } size:@"10" companyId:self.companyId];

        
        return nil;
    }];
    
    /** 请求考核排名*/
    RACSignal *signal6 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        XWWeakSelf
        [XWHttpTool getTargetDataWith:YES type:@"1" success:^(NSMutableArray *array, BOOL isLast, XWTargetRankModel *rankModel) {
            self.v2.targetArray = array;
            self.v2.targetModel = rankModel;
            [subscriber sendNext:@"1"];
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showTipMessageInWindow:errorInfo];
            [subscriber sendNext:@"0"];
            [weakSelf.tableView.mj_header endRefreshing];
        } size:@"10" companyId:self.companyId];
        
        return nil;
    }];
    
    
    [self rac_liftSelector:@selector(completedRequest1:request2:request3:request4:request5:request6:) withSignalsFromArray:@[signal1, signal3, signal4, signal2, signal5, signal6]];
}

- (void)setRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}

- (void)addObserver{
    [self addNotificationWithName:TabbarDoubleCollect selector:@selector(tabbarDoubleAction)];
}

/** 双击tabbar事件*/
- (void)tabbarDoubleAction{
    [self.tableView.mj_header beginRefreshing];
}

- (void)completedRequest1:(NSString *)data1 request2:(NSString *)data2 request3:(NSString *)data3 request4:(NSString *)data4 request5:(NSString *)data5 request6:(NSString *)data6{
    if ([data1 isEqualToString:@"1"] && [data2 isEqualToString:@"1"] && [data3 isEqualToString:@"1"] && [data4 isEqualToString:@"1"] && [data5 isEqualToString:@"1"] && [data6 isEqualToString:@"1"]) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
    }else{
        [MBProgressHUD showErrorMessage:@"加载失败,请重新加载!"];
        [MBProgressHUD hideHUD];
    }
    
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 103;
    }
    return 981;//750+100+68+63;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        XWCompanyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:XWCompanyInfoCellID forIndexPath:indexPath];
        cell.model = self.companyModel;
        return cell;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell addSubview:self.pageView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        XWCompanyInfoController *vc = [[XWCompanyInfoController alloc] init];
        vc.companyId = self.companyId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0.01;
}

- (void)dealloc{
    [self removeNotificationWithName:TabbarDoubleCollect];
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
