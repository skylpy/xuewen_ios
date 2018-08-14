//
//  XWScreenView.m
//  XueWen
//
//  Created by ShaJin on 2018/1/15.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "XWScreenView.h"
#import "XWScreenCell.h"
#import "XWScreenHeaderView.h"
#import "CourseModel.h"
@interface XWScreenView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) NSString *labelID;
@end
@implementation XWScreenView
#pragma mark- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    /** 先找出分区对应的字典，然后从字典中找出映射表，再找出选择的cell的title，根据映射表查出title对应的参数，把参数存到select关键字中 */
    NSMutableDictionary *dict = self.dataSource[indexPath.section];
    NSDictionary *mapping = dict[@"mapping"];
    NSString *title = dict[@"data"][indexPath.row];
    NSString *select = mapping[title];
    [dict setObject:select forKey:@"select"];
    [collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.width, 54);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    XWScreenHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderID" forIndexPath:indexPath];
    headerView.title = self.dataSource[indexPath.section][@"title"];
    return headerView;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.width - 50) / 3.0, 30);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *data = self.dataSource[section][@"data"];
    return data.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XWScreenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    NSDictionary *dict = self.dataSource[indexPath.section];
    NSArray *array = dict[@"data"];
    cell.title = array[indexPath.row];
    cell.isSelect = [dict[@"mapping"][cell.title] isEqualToString:dict[@"select"]];
    return cell;
}

#pragma mark- CustomMethod
- (void)resetAction:(UIButton *)sender{
    [self dismiss];
}

- (void)confirmAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(confirmWithSort:pay:type:labelID:)]) {
        [self.delegate confirmWithSort:self.dataSource[0][@"select"] pay:self.dataSource[1][@"select"] type:self.dataSource[2][@"select"] labelID:self.dataSource[3][@"select"]];
    }
    [self dismiss];
}

- (void)showWithSort:(NSString *)sort pay:(NSString *)pay type:(NSString *)type labelID:(NSString *)labelID{
    NSArray *array = @[sort,pay,type,labelID];
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dict = self.dataSource[i];
        [dict setObject:array[i] forKey:@"select"];
    }
    [self.collectionView reloadData];
    [self show];
}

#pragma mark- LifeCycle
- (instancetype)initWithLabelID:(NSString *)labelID{
    if (self = [super initWithFrame:CGRectMake(40, 0, kWidth - 40, kHeight)]) {
        self.labelID = labelID;
        self.cornerRadius = 0.0;
        self.animationType = kAnimationRight;
        [self addSubview:self.collectionView];
        
        [self addSubview:self.resetButton];
        [self addSubview:self.confirmButton];
        
        self.resetButton.sd_layout.leftSpaceToView(self,0).bottomSpaceToView(self,0).widthIs(self.width / 2.0).heightIs(49);
        self.confirmButton.sd_layout.leftSpaceToView(self.resetButton,0).bottomSpaceToView(self,0).rightSpaceToView(self,0).heightIs(49);
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init]; // 瀑布流
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; // 纵向
        flowLayout.minimumInteritemSpacing = 10;      // cell之间左右间隔
        flowLayout.minimumLineSpacing = 10;          // cell之间上下间隔
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,20,self.width ,self.height - 69) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XWScreenCell class] forCellWithReuseIdentifier:CellID];
        [_collectionView registerClass:[XWScreenHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderID"];
    }
    return _collectionView;
}

- (UIButton *)resetButton{
    if (!_resetButton) {
        _resetButton = [UIButton buttonWithType:0];
        [_resetButton setTitle:@"取消" forState:UIControlStateNormal];
        _resetButton.layer.borderColor = COLOR(238, 238, 238).CGColor;
        _resetButton.layer.borderWidth = 0.5;
        [_resetButton setTitleColor:DefaultTitleAColor forState:UIControlStateNormal];
        _resetButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_resetButton addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

- (UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:0];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setBackgroundColor:kThemeColor];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:
                       @[
                         [NSMutableDictionary dictionaryWithDictionary:@{@"title":@"排序",@"data":@[@"综合排序",@"最新发布",@"人气最高",@"价格从低到高",@"价格从高到低"],@"mapping":@{@"综合排序":@"0",@"最新发布":@"1",@"人气最高":@"2",@"价格从低到高":@"3",@"价格从高到低":@"4"},@"select":@"0"}],
                         [NSMutableDictionary dictionaryWithDictionary:@{@"title":@"筛选",@"data":@[@"全部",@"免费",@"付费"],@"mapping":@{@"全部":@"0",@"免费":@"1",@"付费":@"2"},@"select":@"0"}],
                         [NSMutableDictionary dictionaryWithDictionary:@{@"title":@"类型",@"data":@[@"全部",@"必修",@"选修"],@"mapping":@{@"全部":@"0",@"必修":@"1",@"选修":@"2"},@"select":@"0"}]
                         ]];
        [_dataSource addObject:[self getLabels]];
    }
    return _dataSource;
}

- (NSMutableDictionary *)getLabels{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"title":@"分类",@"select":self.labelID}];
    NSMutableArray *data = [NSMutableArray array];
    NSMutableDictionary *mapping = [NSMutableDictionary dictionary];
    NSArray<CourseLabelModel *> *courseLabelList = [XWInstance shareInstance].courseLabelList;
    for (int i = 0; i < courseLabelList.count; i++) {
        for (int j = 0; j < courseLabelList[i].children.count; j++) {
            CourseLabelModel *label = courseLabelList[i].children[j];
            [data addObject:label.labelName];
            [mapping setObject:label.labelID forKey:label.labelName];
        }
    }
    [dict setObject:data forKey:@"data"];
    [dict setObject:mapping forKey:@"mapping"];
    return dict;
}

NSString *getSelect(NSArray *array , int index){
    NSDictionary *dict = array[index];
    return dict[@"select"];
}
@end
