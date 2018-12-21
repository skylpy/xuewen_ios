//
//  XWMyCoursesViewController.m
//  XueWen
//
//  Created by aaron on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWMyCoursesViewController.h"
#import "MyNotesViewController.h"
#import "MyExamViewController.h"
#import "MineClassesViewController.h"
#import "ClassesInfoCell.h"
#import "XWCoursesHeaderCell.h"
#import "XWEveryDayCell.h"
#import "XWMyPlanCell.h"
#import "XWNMyCourseCell.h"
#import "XWRecommendedCell.h"
#import "XWExplainCell.h"
#import "XWMyPlanModel.h"

static NSString * const XWCoursesHeaderCellID = @"XWCoursesHeaderCell";
static NSString * const XWEveryDayCellID = @"XWEveryDayCellID";
static NSString * const XWMyPlanCellID = @"XWMyPlanCellID";

static NSString * const XWNMyCourseCellID = @"XWNMyCourseCellID";
static NSString * const XWRecommendedCellID = @"XWRecommendedCellID";
static NSString * const XWExplainCellID = @"XWExplainCellID";

#define cellHeight 11 * ((kWidth - 70) / 2.0 / 165 * 102 + 62)+50

@interface XWMyCoursesViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,XWRecommendedCellDelegate>

@property (strong,nonatomic)UITableView * tableView;
//我的课程header
@property (strong,nonatomic)UIView * myCoursesHeaderView;
//推荐课程header
@property (strong,nonatomic)UIView * recommendedView;
//分页
@property (nonatomic, assign) NSInteger page;
//推荐课程
@property (nonatomic,strong) NSMutableArray * recommendedArray;
//我的课程
@property (nonatomic,strong) NSMutableArray * myCoursesArray;
//学习计划
@property (nonatomic,strong) NSMutableArray * learningPlanArray;
//我的计划
@property (nonatomic,strong) XWMyPlanModel *planModel;

@end

@implementation XWMyCoursesViewController

- (NSMutableArray *)learningPlanArray {
    
    if (!_learningPlanArray) {
        NSMutableArray * array = [NSMutableArray array];
        _learningPlanArray = array;
    }
    return _learningPlanArray;
}


- (NSMutableArray *)recommendedArray {
    
    if (!_recommendedArray) {
        NSMutableArray * array = [NSMutableArray array];
        _recommendedArray = array;
    }
    return _recommendedArray;
}

- (NSMutableArray *)myCoursesArray {
    
    if (!_myCoursesArray) {
        NSMutableArray * array = [NSMutableArray array];
        _myCoursesArray = array;
    }
    return _myCoursesArray;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self delayLoadData];
    [self.view addSubview:self.tableView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header beginRefreshing];
    });
    
    
    // 去除导航栏底部细线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
}

- (void)delayLoadData{
    self.page = 1;
    [MBProgressHUD showActivityMessageInWindow:@"正在加载..."];
    @weakify(self)
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        
        [XWNetworking getCoursLabelInfoWithID:nil order:@"5" free:@"0" page:self.page++ CompletionBlock:^(NSArray *array, NSInteger totalCount, BOOL isLast) {
            
            
            [self.recommendedArray removeAllObjects];
            
            [self.recommendedArray addObjectsFromArray:array];
            [subscriber sendNext:@"1"];
        }];
        
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        
        [XWNetworking getLearningPlanListWithPage:1 completeBlock:^(NSArray<LearningPlanModel *> *plans, BOOL isLast) {
            [self.learningPlanArray removeAllObjects];
            [self.learningPlanArray addObjectsFromArray:plans];
            [subscriber sendNext:@"1"];
        }];
        
        return nil;
    }];
    
    RACSignal *signal3 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        
        [XWNetworking getCourseListWithMyClassWithID:[XWInstance shareInstance].userInfo.oid completeBlock:^(XWMyPlanModel *model) {
            
            self.planModel = model;
            [subscriber sendNext:@"1"];
        }];
        
        return nil;
    }];
    
    RACSignal *signal4 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        
        [XWNetworking getCourseListWithMyClass:YES page:1 CompletionBlock:^(NSArray *array, NSInteger totalCount, BOOL isLast) {
            
            [self.myCoursesArray removeAllObjects];
            [self.myCoursesArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [subscriber sendNext:@"1"];
        }];
        
        return nil;
    }];
    
    [self rac_liftSelector:@selector(completedRequest1:request2:request3:request4:) withSignalsFromArray:@[signal1, signal2, signal3, signal4]];
}

- (void)completedRequest1:(NSString *)data1 request2:(NSString *)data2 request3:(NSString *)data3 request4:(NSString *)data4{
    if ([data1 isEqualToString:@"1"] && [data2 isEqualToString:@"1"] && [data3 isEqualToString:@"1"] && [data4 isEqualToString:@"1"]) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
    }else{
        [MBProgressHUD showErrorMessage:@"加载失败,请重新加载!"];
        [MBProgressHUD hideHUD];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            return 175;
            break;
        case 1:
            return 185;
            break;
        case 2:
            return 74;
            break;
        case 3:
        {
            if (self.learningPlanArray.count == 0) {
                
                return 260;
            }
            LearningPlanModel * model = self.learningPlanArray[indexPath.row];
            if (model.scheduleInfo.count == 0) {
                
                return 260;
            }else if (model.scheduleInfo.count == 1){
                
                return 300;
            }else if (model.scheduleInfo.count == 2){
                
                return 330;
            }
            return 345;
        }
            
            break;
        case 4:
            return 125;
            break;
        case 5:
            return self.recommendedArray.count > 0 ? cellHeight  : 0;
            break;
        default:
            return 100;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 0.01;
            break;
        case 4:
            return 50;
            break;
        case 3:
        {
            if ([[XWInstance shareInstance].userInfo.company_id isEqualToString:@"0"]) {
                
                return 0.01;
            }else {
                return 10;
            }
        }
            break;
        default:
            return 10;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 4) {
        
        return self.myCoursesHeaderView;
    }
    if (section == 5) {
        
        return self.recommendedView;
    }
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 4) {
        
        if (self.myCoursesArray.count > 3) {
            
            return 3;
        }
        return self.myCoursesArray.count;
    }
    if (section == 3) {
        
        if ([[XWInstance shareInstance].userInfo.company_id isEqualToString:@"0"]) {
            
            return 0;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            XWCoursesHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:XWCoursesHeaderCellID forIndexPath:indexPath];
            if (self.planModel) {
                cell.model = self.planModel;
            }
            
            return cell;
        }
            break;
        case 1:
        {
            XWEveryDayCell * cell = [tableView dequeueReusableCellWithIdentifier:XWEveryDayCellID forIndexPath:indexPath];
            if (self.planModel) {
                cell.model = self.planModel;
            }
            return cell;
        }
            break;
        case 2:
        {
            XWExplainCell* cell = [tableView dequeueReusableCellWithIdentifier:XWExplainCellID forIndexPath:indexPath];
            if (self.planModel) {
                cell.model = self.planModel;
            }
            @weakify(self)
            [cell setHistroyClick:^{
                 @strongify(self)
                UIViewController * vc = [NSClassFromString(@"XWHistoricalViewController") new];
                [vc setValue:self.planModel.sumviewnum forKey:@"size"];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [cell setNoteClick:^{
                @strongify(self)
                [self.navigationController pushViewController:[MyNotesViewController new] animated:YES];
            }];
            [cell setTestClick:^{
                @strongify(self)
                [self.navigationController pushViewController:[MyExamViewController new] animated:YES];
            }];
            return cell;
        }
            break;
        case 3:
        {
            XWMyPlanCell * cell = [tableView dequeueReusableCellWithIdentifier:XWMyPlanCellID forIndexPath:indexPath];
            
            if (self.learningPlanArray.count > 0) {
                cell.model = self.learningPlanArray[indexPath.row];
            }
            @weakify(self)
            [cell setMoreMyPlanClick:^{
                @strongify(self)
                UIViewController * vc = [NSClassFromString(@"XWPlanListViewController") new];
                
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [cell setCouresDateilClick:^(NSString *cid) {
                @strongify(self)
                [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:cid isAudio:NO] animated:YES];
            }];
            return cell;
        }
            break;
        case 4:
        {
            XWNMyCourseCell * cell = [tableView dequeueReusableCellWithIdentifier:XWNMyCourseCellID forIndexPath:indexPath];
            if (self.myCoursesArray.count > 0) {
                cell.model = self.myCoursesArray[indexPath.row];
            }
            
            return cell;
        }
            break;
        default:{
            XWRecommendedCell * cell = [tableView dequeueReusableCellWithIdentifier:XWRecommendedCellID forIndexPath:indexPath];
            cell.dataSoure =  self.recommendedArray;
            cell.delegate = self;
            return cell;
        }
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3) {
        if (self.learningPlanArray.count == 0) {
            
            return ;
        }
        LearningPlanModel * model =  self.learningPlanArray[indexPath.row];
        UIViewController * vc = [NSClassFromString(@"XWPlanDateilViewController") new];
        
        [vc setValue:model forKey:@"model"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if (indexPath.section == 4){
        
        CourseModel *model = self.myCoursesArray[indexPath.row];
        NSString *courseID = model.courseID;
        [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:courseID isAudio:NO] animated:YES];
    }
    if (indexPath.section == 5) {
        
        CourseModel *model = self.recommendedArray[indexPath.row];
        NSString *courseID = model.courseID;
        [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:courseID isAudio:NO] animated:YES];
    }
}

- (UIView *)recommendedView {
    
    if (!_recommendedView) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 50)];
        _recommendedView = headerView;
        UIView * bobyView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kWidth, 40)];
        bobyView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:bobyView];
        
        UILabel * titleLabel = [UILabel createALabelText:@"推荐课程" withFont:[UIFont fontWithName:kMedFont size:14] withColor:Color(@"#323232")];
        [bobyView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bobyView.mas_left).offset(25);
            make.centerY.equalTo(bobyView);
        }];
    }
    return _recommendedView;
}

- (UIView *)myCoursesHeaderView {
    
    if (!_myCoursesHeaderView) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 50)];
        _myCoursesHeaderView = headerView;
        UIView * bobyView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kWidth, 40)];
        bobyView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:bobyView];
        
        UILabel * titleLabel = [UILabel createALabelText:@"我的课程" withFont:[UIFont fontWithName:kMedFont size:14] withColor:Color(@"#323232")];
        [bobyView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bobyView.mas_left).offset(25);
            make.centerY.equalTo(bobyView);
        }];
        
        UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeCustom];

        [moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [moreButton setTitleColor:Color(@"#999999") forState:UIControlStateNormal];
        moreButton.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [moreButton setImage:[UIImage imageNamed:@"right_copy"] forState:UIControlStateNormal];
        // 重点位置开始
        [moreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, moreButton.currentImage.size.width)];
        [moreButton setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, -moreButton.titleLabel.bounds.size.width)];
        [bobyView addSubview:moreButton];
        [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bobyView.mas_right).offset(-10);
            make.centerY.equalTo(bobyView);
            make.height.offset(16);
            make.width.offset(60);
        }];
        @weakify(self)
        [[moreButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            MineClassesViewController * vc = [[MineClassesViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    
    return _myCoursesHeaderView;
}


#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        CGFloat height = IsIPhoneX ? 44 : 20;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,height, kWidth, kHeight - height - 46) style:UITableViewStyleGrouped];
    
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        [_tableView registerClass:NSClassFromString(@"ClassesInfoCell") forCellReuseIdentifier:@"ClassesId"];
        [_tableView registerClass:[XWCoursesHeaderCell class] forCellReuseIdentifier:XWCoursesHeaderCellID];
        [_tableView registerClass:[XWEveryDayCell class] forCellReuseIdentifier:XWEveryDayCellID];
        [_tableView registerClass:[XWMyPlanCell class] forCellReuseIdentifier:XWMyPlanCellID];
        [_tableView registerClass:[XWRecommendedCell class] forCellReuseIdentifier:XWRecommendedCellID];
        [_tableView registerClass:[XWExplainCell class] forCellReuseIdentifier:XWExplainCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"XWNMyCourseCell" bundle:nil] forCellReuseIdentifier:XWNMyCourseCellID];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(delayLoadData)];
    }
    return _tableView;
}

//XWRecommendedCellDelegate
- (void)recommendedCellDidSelect:(CourseModel *)model {
    
    NSString *courseID = model.courseID;
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:courseID isAudio:NO] animated:YES];
}

#pragma mark- LifeCycle

- (void)setHeaderInfo{
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addNotificationWithName:PersonalInformationUpdate selector:@selector(setHeaderInfo)];
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 35 - kNaviBarH;;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNotification];
}

- (void)dealloc{
    NSLog(@"%s DEALLOC",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]);
}
#pragma mark - --- UINavigationControllerDelegate ---
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
