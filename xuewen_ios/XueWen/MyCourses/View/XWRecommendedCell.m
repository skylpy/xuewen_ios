//
//  XWRecommendedCell.m
//  XueWen
//
//  Created by aaron on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWRecommendedCell.h"
#import "CourseCollectionViewCell.h"
#import "XWCourseCell.h"
#define Recommend       @"XWCourseCellID"


@interface XWRecommendedCell()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,assign) CGFloat recommendWidth;
@property (nonatomic,assign) CGFloat recommendHeight;

@end

@implementation XWRecommendedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    
    self.recommendWidth = (kWidth - 70) / 2.0;
    self.recommendHeight = self.recommendWidth / 165 * 102 + 62;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self);
    }];
}

- (void)setDataSoure:(NSArray *)dataSoure {
    _dataSoure = dataSoure;
    
    [self.collectionView reloadData];
}

#pragma mark- Getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init]; // 瀑布流
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; // 纵向
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        flowLayout.minimumInteritemSpacing = 25;      // cell之间左右间隔
        flowLayout.minimumLineSpacing = 15;          // cell之间上下间隔
        [_collectionView registerNib:[UINib nibWithNibName:@"XWCourseCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:Recommend];
      
    }
    return _collectionView;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 20, 15, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeZero;
    size = CGSizeMake(kWidth , 45);
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
    cell.model = self.dataSoure[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CourseModel * model = self.dataSoure[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(recommendedCellDidSelect:)]) {
        [self.delegate recommendedCellDidSelect:model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
