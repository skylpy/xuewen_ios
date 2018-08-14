//
//  MyCoursesViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/12/6.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MyCoursesViewController.h"
#import "MJRefresh.h"
#import "CompanyDetailViewController.h"
#import "CourseModel.h"
#import "ClassesInfoCell.h"
#import "HomeSectionHeaderView.h"
#import "MyClassesViewController.h"
#import "ClassesListViewController.h"
#import "HeaderTitleView.h"
#import "MyCoursesHeaderView.h"
#import "MyCourseNewHeaderView.h"
#import "LearningPlanModel.h"
#import "LearningPlanViewController.h"
@interface MyCoursesViewController ()<UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) MyCourseNewHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray *sourceData;
@end
#define MyClass         @"MyClass"
#define Recommend       @"recommend"
#define MyPlan          @"MyPlan"
#define HeaderCompanyID @"HeaderCompanyID"
#define HeaderTitleID   @"HeaderTitleID"
@implementation MyCoursesViewController
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 在学课程和推荐课程可以跳转到课程详情
    NSDictionary *dict = self.sourceData[indexPath.section - 1];
    if (![dict[@"identifier"] isEqualToString:MyPlan]) {
        NSArray *array = dict[@"data"];
        CourseModel *model = array[indexPath.row];
        NSString *courseID = model.courseID;
        [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:courseID isAudio:NO] animated:YES];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        MyCourseNewHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderCompanyID forIndexPath:indexPath];
        [view addTarget:self detailAction:@selector(headerViewAction:) learningAction:@selector(learningAction:) continueAction:@selector(continueAction:) totalAction:@selector(totalAction:)];
        [view refresh];
        self.headerView = view;
        return view;
    }else{
        HeaderTitleView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderTitleID forIndexPath:indexPath];
        BOOL showMore = NO;
        NSDictionary *dict = self.sourceData[indexPath.section - 1];
        NSArray *array = dict[@"data"];
        if ([dict[@"index"] isEqualToString:@"1"]) {
            showMore = array.count > 3;
        }else if ([dict[@"index"] isEqualToString:@"2"]){
            showMore = array.count > 1;
        }else if ([dict[@"index"] isEqualToString:@"3"]){
            showMore = YES;
        }
        [view setTitle:dict[@"title"] showIcon:NO showMore:showMore target:self action:@selector(moreAction:)];
        return view;
    }
    return [UICollectionReusableView new];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, (section == 0) ? 0 : 15, 15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeZero;
    if (section == 0) {
        size = CGSizeMake(kWidth, 156.5);
    }else{
        size = CGSizeMake(kWidth , 45);
    }
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    NSDictionary *dict = self.sourceData[indexPath.section - 1];
    NSString *identifier = dict[@"identifier"];
    if ([identifier isEqualToString:MyClass]) {
        size = CGSizeMake(kWidth - 30, 74);
    }else if ([identifier isEqualToString:MyPlan]){
        NSArray *array = dict[@"data"];
        if (array.count > 0) {
            LearningPlanModel *model = array[0];
            CGFloat height = 112 + model.scheduleInfo.count * 38;
            size = CGSizeMake(kWidth - 30, height);
        }
    }else if ([identifier isEqualToString:Recommend]){
        CGFloat width = (kWidth - 45) / 2.0;
        CGFloat height = width / 165 * 102 + 62;
        size = CGSizeMake(width, height);
    }
    return size;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sourceData.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (section > 0) {
        NSDictionary *dict = self.sourceData[section - 1];
        NSArray *array = dict[@"data"];
        if ([dict[@"index"] isEqualToString:@"1"]) {
            count = (array.count > 3) ? 3 : array.count;
        }else if ([dict[@"index"] isEqualToString:@"2"]){
            count = (array.count > 1) ? 1 : array.count;
        }else if ([dict[@"index"] isEqualToString:@"3"]){
            count = array.count;
        }
    }
    return count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.sourceData[indexPath.section - 1];
    NSString *identifier = dict[@"identifier"];
    NSArray *array = dict[@"data"];
    id model = array[indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell setValue:model forKey:@"model"];
    return cell;
}

#pragma mark - --- Custom Method ---
- (void)learningAction:(UIButton *)sender{
    showForbid();
    NSLog(@"在学课程");
}

- (void)continueAction:(UIButton *)sender{
    showForbid();
    NSLog(@"坚持学习");
}

- (void)totalAction:(UIButton *)sender{
    showForbid();
    NSLog(@"累计学时");
}

- (void)moreAction:(UIButton *)sender{
    if (sender.tag == 100) {
        [self.navigationController pushViewController:[[MyClassesViewController alloc]initWithType:kLearningClasses] animated:YES];
    }else if (sender.tag == 200){
        CourseLabelModel *model = [CourseLabelModel new];
        model.labelID = [XWInstance shareInstance].userInfo.label_id;
        [self.navigationController pushViewController:[[ClassesListViewController alloc] initWithCourseMode:model] animated:YES];
    }else if (sender.tag == 500){
        [self.navigationController pushViewController:[LearningPlanViewController new] animated:YES];
    }
}

- (void)initUI{
    self.title = @"我的学习";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)reloadData{
    [self.sourceData sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSInteger index1 = [obj1[@"index"] integerValue];
        NSInteger index2 = [obj2[@"index"] integerValue];
        return index1 > index2;
    }];
    [self.collectionView reloadData];
}

- (void)loadClassData{
    // remove后需要reload collectionView 要不然连续刷新的时候会崩溃
    [self.sourceData removeAllObjects];
    [self.collectionView reloadData];
    self.collectionView.mj_footer.hidden = YES;
    WeakSelf;
    [XWNetworking getMyLearningRecordWithPage:1 CompletionBlock:^(NSArray *array, NSInteger totalCount, BOOL isLast) {
        if (array.count > 0) {
            NSDictionary *dict = @{@"index":@"1",@"title":@"在学课程",@"data":array,@"identifier":MyClass};
            [weakSelf.sourceData addObject:dict];
            [weakSelf reloadData];
        }
    }];
    [self performSelector:@selector(delayLoadData) withObject:nil afterDelay:0.1];
}

- (void)delayLoadData{
    self.page = 1;
    
    WeakSelf;
    [XWNetworking getCoursLabelInfoWithID:nil order:@"5" free:@"0" page:self.page++ CompletionBlock:^(NSArray *array, NSInteger totalCount, BOOL isLast) {
        [weakSelf.collectionView.mj_header endRefreshing];
        
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *dic in weakSelf.sourceData) {
            if ([dic[@"index"] isEqualToString:@"3"]) {
                [mArray addObjectsFromArray:dic[@"data"]];
            }
        }
        [mArray addObjectsFromArray:array];
        NSDictionary *dict = @{@"index":@"3",@"title":@"推荐课程",@"data":mArray,@"identifier":Recommend};
        [weakSelf.sourceData addObject:dict];
        weakSelf.collectionView.mj_footer.hidden = NO;
        [weakSelf reloadData];
        if (mArray.count >= totalCount) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.collectionView.mj_footer endRefreshing];
        }
    }];
    [self performSelector:@selector(delayLoadLearningPlan) withObject:nil afterDelay:0.1];
}

- (void)delayLoadLearningPlan{
    WeakSelf;
    [XWNetworking getLearningPlanListWithPage:1 completeBlock:^(NSArray<LearningPlanModel *> *plans, BOOL isLast) {
        if (plans.count > 0) {
            NSDictionary *dict = @{@"index":@"2",@"title":@"学习计划",@"data":plans,@"identifier":MyPlan};
            [weakSelf.sourceData addObject:dict];
            [weakSelf reloadData];
        }
    }];
    [self performSelector:@selector(loadMineInfo) withObject:nil afterDelay:0.1];
}

- (void)loadMineInfo{
    [XWNetworking getAccountInfoWithCompletionBlock:nil];
}

- (void)loadMoreData{
    WeakSelf;
    [XWNetworking getCoursLabelInfoWithID:nil order:@"5" free:@"0" page:self.page++ CompletionBlock:^(NSArray *array, NSInteger totalCount, BOOL isLast) {
        [weakSelf.collectionView.mj_header endRefreshing];
        
        NSMutableArray *mArray = [NSMutableArray array];
        NSInteger index = -1;
        for (int i = 0; i < weakSelf.sourceData.count; i++) {
            NSDictionary *dict = weakSelf.sourceData[i];
            if ([dict[@"index"] isEqualToString:@"3"]) {
                [mArray addObjectsFromArray:dict[@"data"]];
                index = i;
                break;
            }
        }
        if (index > 0) {
            [weakSelf.sourceData removeObjectAtIndex:index];
        }
        
        [mArray addObjectsFromArray:array];
        NSDictionary *dict = @{@"index":@"3",@"title":@"推荐课程",@"data":mArray,@"identifier":Recommend};
        [weakSelf.sourceData addObject:dict];
        [weakSelf reloadData];
        weakSelf.collectionView.mj_footer.hidden = NO;
        if (mArray.count >= totalCount) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.collectionView.mj_footer endRefreshing];
        }

    }];
}

- (void)headerViewAction:(id)sender{
    [self.navigationController pushViewController:[CompanyDetailViewController new] animated:YES];
}

- (void)setHeaderInfo{
    [self.collectionView reloadData];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - 50;
}

#pragma mark- Getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init]; // 瀑布流
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; // 纵向
        CGFloat height = IsIPhoneX ? 44 : 20;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,height,kWidth, kHeight - kTabBarH - height) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        flowLayout.minimumInteritemSpacing = 10;      // cell之间左右间隔
        flowLayout.minimumLineSpacing = 15;          // cell之间上下间隔
        [_collectionView registerClass:[MyCourseNewHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderCompanyID];
        [_collectionView registerClass:[HeaderTitleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderTitleID];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:NSClassFromString(@"MyCourseInfoCell") forCellWithReuseIdentifier:MyClass];
        [_collectionView registerNib:[UINib nibWithNibName:@"CourseCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:Recommend];
        [_collectionView registerClass:NSClassFromString(@"LearningPlanCell") forCellWithReuseIdentifier:MyPlan];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadClassData)];
    }
    return _collectionView;
}

- (NSMutableArray *)sourceData{
    if (!_sourceData) {
        _sourceData = [NSMutableArray array];
    }
    return _sourceData;
}
#pragma mark- LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 去除导航栏底部细线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self setHeaderInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addNotificationWithName:PersonalInformationUpdate selector:@selector(setHeaderInfo)];
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
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
@end
