//
//  ClassesViewController.m
//  XueWen
//
//  Created by ShaJin on 2018/1/29.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "ClassesViewController.h"
#import "SearchView.h"
#import "CourseModel.h"
#import "XWClassesCollectionViewCell.h"
#import "ClassesHeaderReusableView.h"
#import "ClassesListViewController.h"
#import "ProjectViewController.h"
#import "ProjectCoverCollectionViewCell.h"
#import "ProjectModel.h"
#import "CourseLabelTableViewCell.h"
#import "CollegeViewController.h"
//#import "CollegeViewController.h"

@interface ClassesViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) SearchView *searchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger currentSection;
@property (nonatomic, assign) NSInteger currentIndex;//
@property (nonatomic, strong, readonly) CourseLabelModel *currentModel;

@end

@implementation ClassesViewController
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.currentModel.thematics.count == 0 || indexPath.section == 1){
    
        [self.navigationController pushViewController:[[CollegeViewController alloc] initWithLabelID:self.currentModel.labelID title:self.currentModel.labelName index:indexPath.row+1] animated:YES];
//    }else{
//        CourseProjectModel *model = self.currentModel.thematics[indexPath.row];
//        [self.navigationController pushViewController:[[ProjectViewController alloc] initWithProjectID:model.projectID] animated:YES];
//    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size;
//    if (self.currentModel.thematics.count == 0 || indexPath.section == 1) {
        CGFloat width = floor((kWidth - 146) / 3.0);
        size = CGSizeMake(width, 40);
//    }else{
//        CGFloat width = kWidth - 130;
//        size = CGSizeMake(width, width / 245.0 * 85.0 );
//    }
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 15, 0, 15);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return (self.currentModel.thematics.count > 0) ? 2 : 1;
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = 0;
//    if (self.currentModel.thematics.count == 0 || section == 1) {
        count = self.currentModel.children.count;
//    }else{
//        count = self.currentModel.thematics.count;
//    }
    return count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = nil;
//    if (self.currentModel.thematics.count == 0 || indexPath.section == 1) {
        XWClassesCollectionViewCell *aCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
        aCell.title = self.currentModel.children[indexPath.row].labelName;
        cell = aCell;
//    }else{
//        ProjectCoverCollectionViewCell *aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CoverID" forIndexPath:indexPath];
//        aCell.image = self.currentModel.thematics[indexPath.row].picture;
//        cell = aCell;
//    }
    return cell;
}

#pragma mark- UItableVIew&&Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentIndex = indexPath.row;
    self.currentSection = indexPath.section;
    
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.courseLabelList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.courseLabelList[section].children.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CourseLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    [cell setText:self.courseLabelList[indexPath.section].children[indexPath.row].labelName isSelect:(indexPath.row == _currentIndex && indexPath.section == _currentSection)];
    return cell;
}

#pragma mark- CustomMethod
- (void)initUI{
    self.title = @"全部课程";
//    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
}

- (void)loadData{
    WeakSelf;
    // 进入界面更新标签列表（App启动时也会更新一次）
    [XWNetworking getCoursLabelListWithCompletionBlock:^(BOOL succeed) {
        if (succeed) {
            [weakSelf.tableView reloadData];
            [weakSelf.collectionView reloadData];
        }
    }];
}

- (BOOL)hiddenNavigationBar{
    return NO;
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - kNaviBarH;
}

//NSString *getKey(NSInteger section , NSInteger row){
//    return [NSString stringWithFormat:@"section:%ldrow:%ld",(long)section,(long)row];
//}
#pragma mark- Setter
#pragma mark- Getter
- (SearchView *)searchView{
    if (!_searchView) {
        _searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, kStasusBarH, kWidth, 44)];
        _searchView.viewController = self;
    }
    return _searchView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, kHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = YES;
        _tableView.separatorStyle = 0;
        [_tableView registerClass:[CourseLabelTableViewCell class] forCellReuseIdentifier:CellID];
        _tableView.backgroundColor = COLOR(247, 247, 247);
    }
    return _tableView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init]; // 瀑布流
        flowLayout.minimumLineSpacing = 10; // 垂直
        flowLayout.minimumInteritemSpacing = 8; // 水平
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(100,0,kWidth - 100 , kHeight) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XWClassesCollectionViewCell class] forCellWithReuseIdentifier:CellID];
        [_collectionView registerClass:[ProjectCoverCollectionViewCell class] forCellWithReuseIdentifier:@"CoverID"];
        [_collectionView registerClass:[ClassesHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID"];
    }
    return _collectionView;
}

- (NSArray<CourseLabelModel *> *)courseLabelList{
    return [XWInstance shareInstance].courseLabelList;
}

- (CourseLabelModel *)currentModel{
    return [XWInstance shareInstance].courseLabelList[_currentSection].children[_currentIndex];
}

#pragma mark- LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
