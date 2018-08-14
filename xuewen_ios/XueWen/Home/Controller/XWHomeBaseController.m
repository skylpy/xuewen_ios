//
//  XWHomeBaseController.m
//  XueWen
//
//  Created by Karron Su on 2018/7/19.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHomeBaseController.h"
#import "XWHomeFreeCell.h"
#import "XWHeaderBannerView.h"
#import "XWHomeHeaderView.h"
#import "XWHomeHotCell.h"
#import "XWHomeCell.h"
#import "XWHomeHeavyCell.h"
#import "XWHomeLickCell.h"
#import "XWNearFutureViewController.h"
#import "XWHotCoursListController.h"
#import "XWHotCoursViewController.h"

static NSString *const XWHomeFreeCellID = @"XWHomeFreeCellID";
static NSString *const XWHomeHotCellID = @"XWHomeHotCellID";
static NSString *const XWHomeCellID = @"XWHomeCellID";
static NSString *const XWHomeHeavyCellID = @"XWHomeHeavyCellID";
static NSString *const XWHomeLickCellID = @"XWHomeLickCellID";


@interface XWHomeBaseController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) XWHeaderBannerView *bannerView;
/** 存放猜你喜欢*/
@property (nonatomic, strong) NSMutableArray *lickArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation XWHomeBaseController

#pragma mark - Getter
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kBottomH) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.backgroundColor = [UIColor whiteColor];
        table.tableHeaderView = self.bannerView;
        [table registerClass:[XWHomeFreeCell class] forCellReuseIdentifier:XWHomeFreeCellID];
        [table registerNib:[UINib nibWithNibName:@"XWHomeHotCell" bundle:nil] forCellReuseIdentifier:XWHomeHotCellID];
        [table registerNib:[UINib nibWithNibName:@"XWHomeCell" bundle:nil] forCellReuseIdentifier:XWHomeCellID];
        [table registerNib:[UINib nibWithNibName:@"XWHomeHeavyCell" bundle:nil] forCellReuseIdentifier:XWHomeHeavyCellID];
        [table registerNib:[UINib nibWithNibName:@"XWHomeLickCell" bundle:nil] forCellReuseIdentifier:XWHomeLickCellID];
        _tableView = table;
    }
    return _tableView;
}

- (XWHeaderBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[XWHeaderBannerView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 150)];
    }
    return _bannerView;
}

- (NSMutableArray *)lickArray{
    if (!_lickArray) {
        _lickArray = [[NSMutableArray alloc] init];
    }
    return _lickArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isFirst = YES;
}

- (void)dealloc{
    [self removeNotificationWithName:TabbarDoubleHome];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isFirst) {
        self.isFirst = NO;
        [MBProgressHUD showActivityMessageInWindow:@"加载中..."];
    }
    
}


#pragma mark - Super Methods
- (void)initUI{
    [self.view addSubview:self.tableView];
    
    [self setRefresh];
    [self addObserver];
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
        } cid:@"1"];
        
        return nil;
    }];
    
    /** 请求猜你喜欢数据*/
    RACSignal *signal4 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        XWWeakSelf
        [XWHttpTool getLickCourseWith:@"5" isFirstLoad:YES success:^(NSMutableArray *array, BOOL isLast) {
            weakSelf.lickArray = array;
            [weakSelf.tableView reloadData];
            [subscriber sendNext:@"1"];
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showErrorMessage:errorInfo];
            [weakSelf.tableView.mj_header endRefreshing];
            [subscriber sendNext:@"0"];
        }];
        
        return nil;
    }];
    
    /** 请求*/
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        XWWeakSelf
        [XWHttpTool getCourseIndexWithOrderType:@"3" success:^(NSMutableArray *array, BOOL isLast) {
            weakSelf.dataArray = array;
            [weakSelf.tableView reloadData];
            [subscriber sendNext:@"1"];
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showErrorMessage:errorInfo];
            [weakSelf.tableView.mj_header endRefreshing];
            [subscriber sendNext:@"0"];
        }];
        
        return nil;
    }];
    
    [self rac_liftSelector:@selector(completedRequest1:request2:request3:) withSignalsFromArray:@[signal1, signal3, signal4]];
    
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - 50;;
}

#pragma mark - Custom Methods
- (void)completedRequest1:(NSString *)data1 request2:(NSString *)data2 request3:(NSString *)data3{
    if ([data1 isEqualToString:@"1"] && [data2 isEqualToString:@"1"] && [data3 isEqualToString:@"1"]) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
    }else{
        [MBProgressHUD showErrorMessage:@"加载失败,请重新加载!"];
        [MBProgressHUD hideHUD];
    }
    
}

- (void)loadMore{
    XWWeakSelf
    [XWHttpTool getLickCourseWith:@"10" isFirstLoad:NO success:^(NSMutableArray *array, BOOL isLast) {
        [weakSelf.lickArray addObjectsFromArray:array];
        [weakSelf.tableView reloadData];
        if (isLast) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showErrorMessage:errorInfo];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)setRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

- (void)addObserver{
    [self addNotificationWithName:TabbarDoubleHome selector:@selector(tabbarDoubleAction)];
}

/** 双击tabbar事件*/
- (void)tabbarDoubleAction{
    [self.tableView.mj_header beginRefreshing];
}

/** 热门课程点击更多*/
- (void)hotCourseAction{
//    XWHotCoursListController *vc = [[XWHotCoursListController alloc] init];
    XWHotCoursViewController *vc = [[XWHotCoursViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/** 近期上线点击更多*/
- (void)nearCourseMoreAction{
    XWNearFutureViewController *vc = [[XWNearFutureViewController alloc] init];
    vc.type = ControllerTypeNear;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 4) {
        return self.lickArray.count;
    }
    if (section == 3) {
        return 3;
    }
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) { // 免费课程
        XWCourseIndexModel *model = [self.dataArray firstObject];
        if (model.courseId == nil) {
            return 0;
        }
        return ((kWidth-50)*0.44) + 45;
    }
    if (indexPath.section == 1) { // 热门课程
        if (self.dataArray.count != 0) {
            NSArray *arr = self.dataArray[1];
            if (arr.count == 0) {
                return 0;
            }
        }
        
        if (indexPath.row == 0) {
            return ((kWidth-50)*0.44) + 45;
        }
        return 200;
    }
    if (indexPath.section == 2) { // 重磅推荐
        return ((kWidth-50)*0.44) + 45 + 64;
    }
    // 近期上线和猜你喜欢
    return 154;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) { // 免费课程
        XWHomeFreeCell *cell = [tableView dequeueReusableCellWithIdentifier:XWHomeFreeCellID forIndexPath:indexPath];
        cell.model = [self.dataArray firstObject];
        return cell;
    }
    
    if (indexPath.section == 1) { // 热门课程
        
        if (indexPath.row == 0) {
            XWHomeFreeCell *cell = [tableView dequeueReusableCellWithIdentifier:XWHomeFreeCellID forIndexPath:indexPath];
            if (self.dataArray.count != 0) {
                NSArray *arr = self.dataArray[1];
                if (arr.count != 0) {
                    cell.model = [[self.dataArray objectAtIndex:1] firstObject];
                }
                
            }
            
            return cell;
        }
        XWHomeHotCell *cell = [tableView dequeueReusableCellWithIdentifier:XWHomeHotCellID forIndexPath:indexPath];
        if (self.dataArray.count != 0) {
            NSArray *arr = self.dataArray[1];
            if (arr.count != 0) {
                cell.dataArray = self.dataArray[indexPath.section];
            }
            
        }
        
        return cell;
    }
    
    if (indexPath.section == 2) { // 重磅推荐
        XWHomeHeavyCell *cell = [tableView dequeueReusableCellWithIdentifier:XWHomeHeavyCellID forIndexPath:indexPath];
        if (self.dataArray.count != 0) {
            cell.model = self.dataArray[indexPath.section];
        }
        
        return cell;
    }
    
    if (indexPath.section == 3) { // 近期上线
        XWHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:XWHomeCellID forIndexPath:indexPath];
        if (self.dataArray.count != 0) {
            NSArray *data = self.dataArray[indexPath.section];
            cell.lickModel = data[indexPath.row];
            if (data.count-1 == indexPath.row) {
                cell.hideLine = YES;
            }else{
                cell.hideLine = NO;
            }
        }
        
        return cell;
    }
    
    // 猜你喜欢
    XWHomeLickCell *cell = [tableView dequeueReusableCellWithIdentifier:XWHomeLickCellID forIndexPath:indexPath];
    cell.model = self.lickArray[indexPath.row];
    if (self.lickArray.count - 1 == indexPath.row) {
        cell.hideLine = YES;
    }else{
        cell.hideLine = NO;
    }
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XWCourseIndexModel *model = [[XWCourseIndexModel alloc] init];
    BOOL isAudio;
    if (indexPath.section == 0) { // 免费课程
        model = [self.dataArray firstObject];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) { // 热门课程
        model = [[self.dataArray objectAtIndex:1] firstObject];
    }
    
    if (indexPath.section == 2) { // 重磅推荐
        model = self.dataArray[indexPath.section];
    }
    
    if (indexPath.section ==3) { // 近期上线
        model = self.dataArray[indexPath.section][indexPath.row];
    }
    
    if (indexPath.section == 4) { // 猜你喜欢
        model = self.lickArray[indexPath.row];
    }
    
    if ([model.courseType isEqualToString:@"2"]) {
        isAudio = YES;
    }else{
        isAudio = NO;
    }
    
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseId isAudio:isAudio] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count != 0) {
        if (section == 1) {
            NSArray *arr = self.dataArray[1];
            if (arr.count == 0) {
                return 0;
            }
        }
    }
    if (section == 0) {
        XWCourseIndexModel *model = [self.dataArray firstObject];
        if (model.courseId == nil) {
            return 0;
        }
    }
    
    return 75;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    XWHomeHeaderView *headerView = [[XWHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 75)];
    switch (section) {
        case 0:
        {
            [headerView setTitle:@"免费课程" showMoreBtn:NO btnAction:nil target:self iconName:@"icon_free"];
        }
            break;
        case 1:
        {
            [headerView setTitle:@"热门课程" showMoreBtn:YES btnAction:@selector(hotCourseAction) target:self iconName:@"icon_hot"];
        }
            break;
        case 2:
        {
            [headerView setTitle:@"重磅推荐" showMoreBtn:NO btnAction:nil target:self iconName:@"icon_recommand"];
        }
            break;
        case 3:
        {
            [headerView setTitle:@"近期上线" showMoreBtn:YES btnAction:@selector(nearCourseMoreAction) target:self iconName:@"icon_new"];
        }
            break;
        case 4:
        {
            [headerView setTitle:@"为你推荐" showMoreBtn:NO btnAction:nil target:self iconName:@"icon_like"];
        }
            break;
            
        default:
            break;
    }
    
    if (self.dataArray.count != 0) {
        if (section == 1) {
            NSArray *arr = self.dataArray[1];
            if (arr.count == 0) {
                return nil;
            }
        }
    }
    
    if (section == 0) {
        XWCourseIndexModel *model = [self.dataArray firstObject];
        if (model == nil) {
            return nil;
        }
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.isDraging) {
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

- (UIScrollView *)preferScrollView{
    return self.tableView;
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
