//
//  XWCompanyCoursCell.m
//  XueWen
//
//  Created by Karron Su on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCompanyCoursCell.h"
#import "XWCompanyCollectionCell.h"

static NSString *const XWCompanyCollectionCellID = @"XWCompanyCollectionCellID";


@interface XWCompanyCoursCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation XWCompanyCoursCell

#pragma mark - Getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((kWidth-100)/2, (kWidth-100)/2*1.4);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 12.5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(35, 0, kWidth-70, (kWidth-100)*1.4) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"XWCompanyCollectionCell" bundle:nil] forCellWithReuseIdentifier:XWCompanyCollectionCellID];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setImage:LoadImage(@"icon_left") forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:LoadImage(@"icon_right_n") forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (NSMutableArray *)array{
    if (!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
}


#pragma mark - lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    self.index = 0;
    [self addSubview:self.collectionView];
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(5);
        make.size.mas_equalTo(CGSizeMake(19, 37));
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-5);
        make.size.mas_equalTo(CGSizeMake(19, 37));
    }];
}

#pragma mark - Setter
- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    self.array = [[NSMutableArray splitArray:_dataArray withSubSize:4] mutableCopy];
    NSLog(@"newArray is %@", self.array);
    self.dataArr = self.array[self.index];
}

- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self.collectionView reloadData];
}


#pragma mark - Action
- (void)rightBtnAction{
    if (self.index == self.array.count - 1) {
        [MBProgressHUD showTipMessageInWindow:@"已经是最后一页啦!"];
        return;
    }
    self.index++;
    self.dataArr = self.array[self.index];
}

- (void)leftBtnAction{
    if (self.index == 0) {
        [MBProgressHUD showTipMessageInWindow:@"已经是第一页啦!"];
        return;
    }
    self.index--;
    self.dataArr = self.array[self.index];
}

#pragma mark - UICollectionView Delegate / DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XWCompanyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XWCompanyCollectionCellID forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.item];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    XWCompanyCoursModel *model = self.dataArr[indexPath.item];
//    if ([model.courseType isEqualToString:@"2"]) {
//        [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseId isAudio:YES] animated:YES];
//    }else{
        [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseId isAudio:NO] animated:YES];
//    }
}


@end
