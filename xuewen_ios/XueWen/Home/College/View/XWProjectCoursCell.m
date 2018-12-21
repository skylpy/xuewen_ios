//
//  XWProjectCoursCell.m
//  XueWen
//
//  Created by Karron Su on 2018/8/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWProjectCoursCell.h"
#import "CourseCollectionViewCell.h"
#import "XWCourseCell.h"
#import "CourseModel.h"

#define Recommend       @"XWCourseCellID"


@interface XWProjectCoursCell()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,assign) CGFloat recommendWidth;
@property (nonatomic,assign) CGFloat recommendHeight;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *buyBtn;

@end

@implementation XWProjectCoursCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - lifecycle
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
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.priceLabel];
    [self.bottomView addSubview:self.buyBtn];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-70);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset(-17);
        make.left.mas_equalTo(self).offset(25);
        make.right.mas_equalTo(self).offset(-25);
        make.height.mas_equalTo(35);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView);
        make.left.mas_equalTo(self.bottomView).offset(10);
    }];
    
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self.bottomView);
        make.width.mas_equalTo(90);
    }];
}

#pragma mark - Setter
- (void)setDataSoure:(NSArray *)dataSoure {
    _dataSoure = dataSoure;
    [self.collectionView reloadData];
}

- (void)setModel:(ProjectModel *)model{
    _model = model;
    
    if (model.buy) {
        NSString *priceStr = [NSString stringWithFormat:@"优惠价:¥%@", model.price];
        NSString *originalPriceStr = [NSString stringWithFormat:@"原价:¥%@", model.originalPrice];
        NSString *courseStr = [NSString stringWithFormat:@"(含%ld门课程)", model.courses.count];
        NSString *text = [NSString stringWithFormat:@"%@ %@%@", priceStr, originalPriceStr, courseStr];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
        [attr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:[text rangeOfString:originalPriceStr]];
        [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:kRegFont size:10] range:[text rangeOfString:originalPriceStr]];
        [attr addAttribute:NSForegroundColorAttributeName value:Color(@"#999999") range:[text rangeOfString:originalPriceStr]];
        [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:kRegFont size:10] range:[text rangeOfString:courseStr]];
        [attr addAttribute:NSForegroundColorAttributeName value:Color(@"#999999") range:[text rangeOfString:courseStr]];
        self.priceLabel.attributedText = attr;
        self.buyBtn.userInteractionEnabled = NO;
        [self.buyBtn setTitle:@"已购买" forState:UIControlStateNormal];
        self.buyBtn.backgroundColor = Color(@"#CCCCCC");
    }else{
        NSString *priceStr = [NSString stringWithFormat:@"优惠价:¥%@", model.price];
        NSString *originalPriceStr = [NSString stringWithFormat:@"原价:¥%@", model.originalPrice];
        NSString *courseStr = [NSString stringWithFormat:@"(含%ld门课程)", model.courses.count];
        NSString *text = [NSString stringWithFormat:@"%@ %@%@", priceStr, originalPriceStr, courseStr];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
        [attr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:[text rangeOfString:originalPriceStr]];
        [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:kRegFont size:10] range:[text rangeOfString:originalPriceStr]];
        [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:kRegFont size:10] range:[text rangeOfString:courseStr]];
        [attr addAttribute:NSForegroundColorAttributeName value:Color(@"#FD8829") range:[text rangeOfString:courseStr]];
        self.priceLabel.attributedText = attr;
        self.buyBtn.userInteractionEnabled = YES;
        [self.buyBtn setTitle:@"全部购买" forState:UIControlStateNormal];
        self.buyBtn.backgroundColor = Color(@"#FD8829");
    }
    
    
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

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = Color(@"#F2F0F0");
    }
    return _bottomView;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.textColor = Color(@"#333333");
        _priceLabel.font = [UIFont fontWithName:kRegFont size:14];
    }
    return _priceLabel;
}

- (UIButton *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.backgroundColor = Color(@"#FD8829");
        [_buyBtn setTitle:@"全部购买" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = [UIFont fontWithName:kMedFont size:15];
        [_buyBtn addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}

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
    cell.model = self.dataSoure[indexPath.row];
    cell.buy = self.buy;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CourseModel * model = self.dataSoure[indexPath.row];
    
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseID isAudio:NO] animated:YES];
}

#pragma mark - Action
- (void)buyAction:(UIButton *)btn{
    XWWeakSelf
    UIViewController *vc = [ViewControllerManager orderInfoWithID:self.model.projectID type:1 updateBlock:^{
        [weakSelf postNotificationWithName:@"UPDATEPROJECTPRICE" object:nil];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
