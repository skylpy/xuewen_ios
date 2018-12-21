//
//  XWCollegeCell.m
//  XueWen
//
//  Created by Karron Su on 2018/4/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCollegeCell.h"
#import "XWCollegeCollectionCell.h"
#import "CollegeViewController.h"
#import "XWCollegeBaseViewController.h"
#import "ClassesViewController.h"

static NSString *const XWCollegeCollectionCellID = @"XWCollegeCollectionCellID";

@interface XWCollegeCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *colorArray;

@end

@implementation XWCollegeCell

#pragma mark - Getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(60, 60);
        layout.minimumLineSpacing = 12;
        layout.minimumInteritemSpacing = 7;
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 13);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 82) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"XWCollegeCollectionCell" bundle:nil] forCellWithReuseIdentifier:XWCollegeCollectionCellID];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (NSMutableArray *)colorArray{
    if (!_colorArray) {
        _colorArray = [[NSMutableArray alloc] init];
        [_colorArray addObject:Color(@"#191A1F")];
        [_colorArray addObject:Color(@"#2E2B38")];
        [_colorArray addObject:Color(@"#2B3038")];
        [_colorArray addObject:Color(@"#302B38")];
        [_colorArray addObject:Color(@"#373E51")];
        [_colorArray addObject:Color(@"#382B30")];
        [_colorArray addObject:Color(@"#4F4C57")];
        [_colorArray addObject:Color(@"#555555")];
    }
    return _colorArray;
}

#pragma mark - Setter
- (void)setArray:(NSMutableArray *)array{
    _array = array;
    [self.collectionView reloadData];
}

#pragma mark - lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    [self addSubview:self.collectionView];
}

#pragma mark - UICollectionView Delegate / DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XWCollegeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XWCollegeCollectionCellID forIndexPath:indexPath];
    
    cell.labelModel = self.array[indexPath.item];
    if (self.colorArray.count <= indexPath.item) {
        
    }else{
        cell.bgColor = self.colorArray[indexPath.item];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    XWCourseLabelModel *model = self.array[indexPath.item];
    if ([model.labelName isEqualToString:@"全部"]) {
        [Analytics event:EventAll];
        ClassesViewController *vc = [[ClassesViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        switch (indexPath.item) {
            case 1:
            {
                [Analytics event:EventHr];
            }
                break;
            case 2:
            {
                [Analytics event:EventAdministrative];
            }
                break;
            case 3:
            {
                [Analytics event:EventMarketing];
            }
                break;
            case 4:
            {
                [Analytics event:EventTreasure];
            }
                break;
            case 5:
            {
                [Analytics event:EventProduce];
            }
                break;
            case 6:
            {
                [Analytics event:EventStorage];
            }
                break;
            case 7:
            {
                [Analytics event:EventInternet];
            }
                break;
            case 8:
            {
                [Analytics event:EventService];
            }
                break;
                
            default:
                break;
        }
        XWCollegeBaseViewController *vc = [[XWCollegeBaseViewController alloc] init];
        vc.labelID = model.labelId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
