//
//  XWMyCertificateCell.m
//  XueWen
//
//  Created by aaron on 2018/8/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWMyCertificateCell.h"
#import "XWCertificateCell.h"

#define cellH (kWidth - 70) / 4

static NSString * const XWCertificateCellID = @"XWCertificateCellID";

@interface XWMyCertificateCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSArray <XWCerChildrenModel *> *dataSourec;

@end

@implementation XWMyCertificateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = Color(@"#E8E8E8");
    self.contentView.backgroundColor = Color(@"#E8E8E8");
    self.bgView.layer.cornerRadius = 5;
    self.bgView.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self drawUI];
}

- (void)setModel:(XWCerDataModel *)model {
    _model = model;
    
    self.dataSourec = model.children;
    self.iconImage.image = [model.achievement_name isEqualToString:@"市场营销学院"]?
    LoadImage(@"SchoolMarketing"):[model.achievement_name isEqualToString:@"人力资源管理学院"]?
    LoadImage(@"course_school_of_human_resources_management"):[model.achievement_name isEqualToString:@"互联网学院"]?
    LoadImage(@"course_internet_academy"):[model.achievement_name isEqualToString:@"行政管理学院"]?
    LoadImage(@"course_school_of_administration"):[model.achievement_name isEqualToString:@"生产管理学院"]?
    LoadImage(@"course_school_of_production_management"):[model.achievement_name isEqualToString:@"仓储物流学院"]?
    LoadImage(@"course_warehousing_and_logistics_college"):LoadImage(@"course_customer_service_management_college");
    [self.collectionView reloadData];
}

- (void)drawUI {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init]; // 瀑布流
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; // 纵向
    self.collectionView.collectionViewLayout = flowLayout;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    flowLayout.minimumInteritemSpacing = 10;      // cell之间左右间隔
    flowLayout.minimumLineSpacing = 8;          // cell之间上下间隔
    _collectionView.scrollEnabled = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"XWCertificateCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:XWCertificateCellID];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeZero;
    size = CGSizeMake(kWidth , 0);
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;

    size = CGSizeMake(cellH, cellH +30);
    return size;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return self.dataSourec.count+1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    XWCertificateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XWCertificateCellID forIndexPath:indexPath];
    if (self.dataSourec.count == indexPath.row) {
        
        cell.icon = @"inviteExpect";
        return cell;
    }
    XWCerChildrenModel * model = self.dataSourec[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSourec.count == indexPath.row) return;
    XWCerChildrenModel * model = self.dataSourec[indexPath.row];
    !self.didSelectCerClick?:self.didSelectCerClick(model);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
