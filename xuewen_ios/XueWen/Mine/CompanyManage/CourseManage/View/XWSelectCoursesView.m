//
//  XWSelectCourseView.m
//  XueWen
//
//  Created by aaron on 2018/12/12.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWSelectCoursesView.h"
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

@interface XWSelectCoursesView()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) SearchView *searchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger currentSection;
@property (nonatomic, assign) NSInteger currentIndex;//
@property (nonatomic, strong, readonly) CourseLabelModel *currentModel;
@property (weak, nonatomic) IBOutlet UIView *showView;

@property (copy, nonatomic) void (^courseClick)(NSString * labelID,NSString * labelName);

@end

@implementation XWSelectCoursesView


+ (instancetype)showCourseView:(UIView *)superView withFrame:(CGRect)frame withCourseClick:(void (^)(NSString * labelID,NSString * labelName))courseClick{
    
    XWSelectCoursesView * courseView = [[NSBundle mainBundle] loadNibNamed:@"XWSelectCoursesView" owner:self options:nil].firstObject;
    [superView addSubview:courseView];
    courseView.frame = frame;
    courseView.courseClick = courseClick;
    [courseView initUI];
    [courseView loadData];
    
    return courseView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        !self.courseClick?:self.courseClick(self.currentModel.labelID,self.currentModel.labelName);
    }else {
        CourseLabelModel * model = self.currentModel.children[indexPath.row];
        !self.courseClick?:self.courseClick(model.labelID,model.labelName);
    }
    
    [self removeFromSuperview];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size;

    CGFloat width = floor((kWidth - 146) / 3.0);
    size = CGSizeMake(width, 40);

    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 15, 0, 15);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }
    NSInteger count = 0;

    count = self.currentModel.children.count;

    return count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    XWClassesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    
    cell.title = indexPath.section == 0?@"全部": self.currentModel.children[indexPath.row].labelName;
    

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
   
    [self.showView addSubview:self.tableView];
    [self.showView addSubview:self.collectionView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.equalTo(self.showView);
        make.width.offset(100);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.top.bottom.equalTo(self.showView);
        make.width.offset(kWidth-100);
    }];
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

//- (BOOL)hiddenNavigationBar{
//    return NO;
//}
//
//- (CGFloat)audioPlayerViewHieght{
//    return kHeight - kBottomH - 49 - kNaviBarH;
//}
//
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
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


@end
