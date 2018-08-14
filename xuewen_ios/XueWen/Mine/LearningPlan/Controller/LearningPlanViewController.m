//
//  LearningPlanViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/12/25.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "LearningPlanViewController.h"
#import "LearningPlanCell.h"
#import "LearningPlanModel.h"
@interface LearningPlanViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<LearningPlanModel *> *dataSource;

@end

@implementation LearningPlanViewController

#pragma mark - UICollectionView Delegate / DataSource
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 112 + self.dataSource[indexPath.row].scheduleInfo.count * 38;
    return CGSizeMake(kWidth - 30, height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LearningPlanCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark- CustomMethod
- (void)initUI{
    self.title = @"学习计划";
    self.view.backgroundColor = DefaultBgColor;
    self.scrollView = self.collectionView;
    [self addHeaderWithAction:@selector(loadMyLearningPlanData)];
    [self addFooterWithAction:@selector(loadMyLearningPlanData)];
    [self beginLoadData];
}

- (void)loadMyLearningPlanData{
    WeakSelf;
    [XWNetworking getLearningPlanListWithPage:self.page++ completeBlock:^(NSArray<LearningPlanModel *> *plans, BOOL isLast) {
        [weakSelf loadedDataWithArray:plans isLast:isLast];
        [weakSelf.collectionView reloadData];
    }];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kNaviBarH - kBottomH - 50;
}

- (BOOL)hiddenNaviLine{
    return NO;
}
#pragma mark- Setter
#pragma mark- Getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init]; // 瀑布流
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; // 纵向
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,kWidth,kHeightNoNaviBar) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        flowLayout.minimumInteritemSpacing = 10;    // cell之间左右间隔
        flowLayout.minimumLineSpacing = 15;         // cell之间上下间隔
        [_collectionView registerClass:[LearningPlanCell class] forCellWithReuseIdentifier:CellID];
        _collectionView.backgroundColor = self.view.backgroundColor;
    }
    return _collectionView;
}

- (NSMutableArray<LearningPlanModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = self.array;
    }
    return _dataSource;
}

#pragma mark- LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
