//
//  CollegeViewController.m
//  XueWen
//
//  Created by ShaJin on 2018/1/13.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "CollegeViewController.h"
#import "SGPageView.h"
#import "MyCourseInfoCell.h"
#import "CourseModel.h"
#import "XWScreenView.h"
#import "CourseModel.h"
#import "ClassesListViewController.h"
@interface CollegeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SGPageTitleViewDelegate,XWScreenDelegate>

@property (nonatomic, strong) NSString *labelID;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *pay;
@property (nonatomic, strong) NSString *type;
/** 头部视图，titleView和screen在headerView里边 */
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *screenButton;
@property (nonatomic, strong) SGPageTitleView *titleView;
@property (nonatomic, strong) NSMutableArray<CourseModel *> *courses;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) XWScreenView *screenView; // 筛选界面
@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) NSArray<NSString *> *labelIDs;
@property (nonatomic, assign) NSInteger currentIndex;

@end
@implementation CollegeViewController
#pragma mark- SGPageTitleViewDelegate
- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex{
    if (_currentIndex != selectedIndex) {
        _currentIndex = selectedIndex;
        [self beginLoadData];
    }
}

#pragma mark- UICollectionViewDelegte
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CourseModel *model = self.courses[indexPath.row];
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseID isAudio:NO] animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 15, 0, 15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kWidth - 30, 74);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.courses.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyCourseInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    [cell setModel:self.courses[indexPath.row] showProgress:NO];
    return cell;
}

#pragma mark - XWScreenDelegate 筛选代理
- (void)confirmWithSort:(NSString *)sort pay:(NSString *)pay type:(NSString *)type labelID:(NSString *)labelID{
    if (![self.labelID isEqualToString:labelID]) {
        self.labelID = labelID;
        [self updateTitle];
    }
    self.sort = sort;
    self.pay = pay;
    self.type = type;
    [self.titleView removeFromSuperview];
    self.titleView = nil;
    [self initUI];
    [self postNotificationWithName:@"showAudioPlayerView" object:nil];
}

#pragma mark- CustomMethod
/** 更新标题 */
- (void)updateTitle{
    NSArray<CourseLabelModel *> *courseLabelList = [XWInstance shareInstance].courseLabelList;
    for (int i = 0; i < courseLabelList.count; i++) {
        for (int j = 0; j < courseLabelList[i].children.count; j++) {
            CourseLabelModel *label = courseLabelList[i].children[j];
            if ([label.labelID isEqualToString:self.labelID]) {
                self.title = label.labelName;
                return;
            }
        }
    }
}

/** 筛选 */
- (void)screenAction:(UIButton *)sender{
    [self.screenView showWithSort:self.sort pay:self.pay type:self.type labelID:self.labelID];
}

- (void)initUI{
    // 根据标签ID获取标题，如果传了错误的标签不会获取到标题，这时直接根据标签请求课程，不显示筛选界面
    if (self.titles.count == 0) {
        self.scrollView = self.collectionView;
        self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        self.labelIDs = @[self.labelID];
    }else{
        [self.view addSubview:self.headerView];
        [self.headerView addSubview:self.titleView];
        [self.headerView addSubview:self.screenButton];
        self.scrollView = self.collectionView;
        
        self.headerView.sd_layout.topSpaceToView(self.view,0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(40);
        self.screenButton.sd_layout.topSpaceToView(self.headerView,0).rightSpaceToView(self.headerView,0).bottomSpaceToView(self.headerView,0).widthIs(40);
        [self.view bringSubviewToFront:self.headerView];
    }
    [self updateTitle];
    [self addHeaderFooterAction:@selector(loadCourseData)];
    [self beginLoadData];
}

- (void)loadCourseData{
    WeakSelf;
    
    [XWNetworking getCoursLabelInfoWithID:self.labelIDs[_currentIndex] order:self.sort free:self.pay take:self.type page:self.page++ CompletionBlock:^(NSArray *array, NSInteger totalCount, BOOL isLast) {
        [weakSelf loadedDataWithArray:array isLast:isLast];
    }];
}

- (BOOL)hiddenNaviLine{
    return NO;
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kNaviBarH - kBottomH - 50;
}

#pragma mark- Setter
- (void)setLabelID:(NSString *)labelID{
    _labelID = labelID;
    _titles = nil;
    _labelIDs = nil;
}

#pragma mark- Getter
- (NSArray<NSString *> *)titles{
    if (!_titles) {
        NSArray<CourseLabelModel *> *courseLabelList = [XWInstance shareInstance].courseLabelList;
        for (int i = 0; i < courseLabelList.count; i++) {
            for (int j = 0; j < courseLabelList[i].children.count; j++) {
                CourseLabelModel *label = courseLabelList[i].children[j];
                if ([label.labelID isEqualToString:self.labelID]) {
                    NSMutableArray *mArray = [NSMutableArray arrayWithObject:@"全部"];
                    NSMutableArray *labelIDs = [NSMutableArray arrayWithObject:self.labelID];
                    
                    for (int k = 0; k < label.children.count; k++) {
                        CourseLabelModel *model = label.children[k];
                        [mArray addObject:model.labelName];
                        [labelIDs addObject:model.labelID];
                    }

                    _titles = mArray;
                    _labelIDs = labelIDs;
                    break;
                    break;
                }
                
            }
        }
        
    }
    return _titles;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init]; // 瀑布流
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; // 纵向
        flowLayout.minimumInteritemSpacing = 15;      // cell之间左右间隔
        flowLayout.minimumLineSpacing = 10;          // cell之间上下间隔
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,40,kWidth ,kHeight - 40 - kNaviBarH) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[MyCourseInfoCell class] forCellWithReuseIdentifier:CellID];
        
    }
    return _collectionView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.layer.shadowColor = (COLOR(204, 208, 225)).CGColor;
        _headerView.layer.shadowOffset = CGSizeMake(0, 2.5);
        _headerView.layer.shadowRadius = 5;
        _headerView.layer.shadowOpacity = 0.2;
        _headerView.layer.masksToBounds = NO;

    }
    return _headerView;
}

- (SGPageTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[SGPageTitleView alloc] initWithFrame:CGRectMake(0, 0, kWidth - 40, 40) delegate:self titleNames:self.titles];
        _titleView.indicatorLengthStyle = SGIndicatorLengthTypeEqual;
        _titleView.titleColorStateNormal = DefaultTitleAColor;
        _titleView.titleColorStateSelected = kThemeColor;
        _titleView.indicatorColor = kThemeColor;
        _titleView.indicatorHeight = 3.0;
        _titleView.selectedIndex = self.currentIndex;;
    }
    return _titleView;
}

- (UIButton *)screenButton{
    if (!_screenButton) {
        _screenButton = [UIButton buttonWithType:0];
        _screenButton.backgroundColor = [UIColor whiteColor];
        [_screenButton setImage:LoadImage(@"icoScreen") forState:UIControlStateNormal];
        [_screenButton addTarget:self action:@selector(screenAction:) forControlEvents:UIControlEventTouchUpInside];
        _screenButton.layer.shadowColor = (COLOR(204, 208, 225)).CGColor;
        _screenButton.layer.shadowOffset = CGSizeMake(-2.5, 0);
        _screenButton.layer.shadowRadius = 5;
        _screenButton.layer.shadowOpacity = 0.2;
        _screenButton.layer.masksToBounds = NO;
    }
    return _screenButton;
}

- (NSMutableArray<CourseModel *> *)courses{
    return self.array;
}

- (XWScreenView *)screenView{
    if (!_screenView) {
        _screenView = [[XWScreenView alloc] initWithLabelID:self.labelID];
        _screenView.delegate = self;
    }
    return _screenView;
}

#pragma mark- LifeCycle
- (instancetype)initWithLabelID:(NSString *)labelID title:(NSString *)title index:(NSInteger)index{
    if (self = [super init]) {
        self.labelID = labelID;
        [Analytics event:EventCollegeInfo label:labelID];
        self.sort = @"0";
        self.pay = @"0";
        self.type = @"0";
        self.currentIndex = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
