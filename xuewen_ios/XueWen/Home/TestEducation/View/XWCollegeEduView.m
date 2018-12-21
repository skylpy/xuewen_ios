//
//  XWCollegeEduView.m
//  XueWen
//
//  Created by aaron on 2018/10/18.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCollegeEduView.h"
#import "ProjectModel.h"
#import "XWProjectIntroduceCell.h"
#import "XWProjectHeaderView.h"
#import "XWCourseCell.h"
#import "CourseModel.h"

static NSString *const XWProjectIntroduceCellID = @"XWProjectIntroduceCellID";
static NSString *const XWProjectCoursCellID = @"XWProjectCoursCellID";
#define Recommend       @"XWCourseCellID"
@interface XWCollegeEduView () <UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSString *projectID;
@property (nonatomic, strong) NSString *jobsType;
@property (nonatomic, strong) NSString *projectName;
@property (nonatomic, strong) ProjectModel *model;
@property (nonatomic,assign) CGFloat recommendWidth;
@property (nonatomic,assign) CGFloat recommendHeight;
@property (nonatomic, strong) NSMutableArray * dataSoure;
@end
@implementation XWCollegeEduView

- (NSMutableArray *)dataSoure {
    
    if(!_dataSoure){
        _dataSoure = [NSMutableArray array];
    }
    return _dataSoure;
}

#pragma mark- Getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init]; // 瀑布流
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; // 纵向
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        flowLayout.minimumInteritemSpacing = 25;      // cell之间左右间隔
        flowLayout.minimumLineSpacing = 15;          // cell之间上下间隔
        [_collectionView registerNib:[UINib nibWithNibName:@"XWCourseCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:Recommend];
        
    }
    return _collectionView;
}

- (instancetype)initWithPageTitle:(NSString *)title projectID:(NSString *)projectID withJobsType:(NSString *)jobsType{
    if (self = [super initWithPageTitle:title]) {
        self.projectID = projectID;
        self.jobsType = jobsType;
        self.projectName = title;
        self.recommendWidth = (kWidth - 70) / 2.0;
        self.recommendHeight = self.recommendWidth / 165 * 102 + 62;
        [self addNotificationWithName:@"UPDATEPROJECTPRICE" selector:@selector(loadData)];
    }
    return self;
}

- (void)didAppeared{
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self loadData];
}

- (void)loadData{
    XWWeakSelf
    [XWCollegeEduModel getCollegeEduCoursListWithlabelID:self.projectID andJobsType:self.jobsType Success:^(NSMutableArray * _Nonnull dataSource, BOOL isLast) {
        weakSelf.dataSoure = dataSource;
        [weakSelf.collectionView reloadData];
        if (isLast) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.collectionView.mj_footer endRefreshing];
        }
    } failure:^(NSString * _Nonnull error) {
        [MBProgressHUD showTipMessageInWindow:error];
    } isFirstLoad:YES];

}

- (void)loadMore{
    XWWeakSelf
    [XWCollegeEduModel getCollegeEduCoursListWithlabelID:self.projectID andJobsType:self.jobsType Success:^(NSMutableArray * _Nonnull dataSource, BOOL isLast) {
        [weakSelf.dataSoure addObjectsFromArray:dataSource];
        [weakSelf.collectionView reloadData];
        if (isLast) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.collectionView.mj_footer endRefreshing];
        }
    } failure:^(NSString * _Nonnull error) {
        [MBProgressHUD showTipMessageInWindow:error];
    } isFirstLoad:NO];
}

#pragma mark - UITableView Delegate / DataSource

#pragma mark - CollectionViewDelegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 20, 15, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeZero;
    size = CGSizeMake(kWidth , 25);
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    
    
    size = CGSizeMake(self.recommendWidth, self.recommendHeight);
    return size;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return self.dataSoure.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XWCourseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Recommend forIndexPath:indexPath];
    cell.model = self.dataSoure[indexPath.item];
    CourseModel *model = self.dataSoure[indexPath.item];
    cell.buy = model.buy;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CourseModel * model = self.dataSoure[indexPath.item];
    
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseID isAudio:NO] animated:YES];
}

@end

static NSInteger page = 1;

@implementation XWCollegeEduModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"courseList" : [XWEduLabelModel class],
             @"dataList":[CourseModel class]
             };
}

/**
 *注释
 *YYModel 映射替换字段
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"courseList" : @"course_label",
             @"dataList":@"data"
             };
}


//获取标签
+ (void)getCollegeEduListWithJobsType:(NSString *)jobsType
                             Success:(void(^)(XWCollegeEduModel * model))success
                             failure:(void(^)(NSString *error))failure {
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:jobsType forKey:@"jobs_type"];
    
    [XWHttpBaseModel BGET:BASE_URL(Cours_Label) parameters:dic extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        
        XWCollegeEduModel * emodel = [XWCollegeEduModel modelWithJSON:model.data];
        !success?:success(emodel);
        
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}

//获取课程
+ (void)getCollegeEduCoursListWithlabelID:(NSString *)labelId
                              andJobsType:(NSString *)jobsType
                                  Success:(nonnull void (^)(NSMutableArray * _Nonnull, BOOL))success
                                  failure:(nonnull void (^)(NSString * _Nonnull))failure
                              isFirstLoad:(BOOL)isFirstLoad {
    if (isFirstLoad) {
        page = 1;
    }else{
        page++;
    }
    ParmDict
    [dict setValue:jobsType forKey:@"jobs_type"];
    [dict setValue:labelId forKey:@"id"];
    [dict setValue:@"10" forKey:@"size"];
    [dict setValue:@(page) forKey:@"page"];
    
    [XWHttpBaseModel BGET:BASE_URL(Cours_list) parameters:dict extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        XWHttpModel *hmodel = [XWHttpModel modelWithJSON:model.data];
        NSArray *array = [NSArray modelArrayWithClass:[CourseModel class] json:hmodel.results];
        !success ? : success([array mutableCopy], [hmodel.currentPage integerValue] >= [hmodel.lastPage integerValue]);
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}

@end

@implementation XWEduLabelModel



@end
