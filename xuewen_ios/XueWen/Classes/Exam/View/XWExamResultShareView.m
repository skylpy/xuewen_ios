//
//  XWExamResultShareView.m
//  XueWen
//
//  Created by Karron Su on 2018/6/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWExamResultShareView.h"
#import "WXApi.h"
#import "XWShareCollectionViewCell.h"
#import "POP.h"

static NSString *const XWShareCollectionViewCellID = @"XWShareCollectionViewCellID";

@interface XWExamResultShareView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIView *backView;

@end

@implementation XWExamResultShareView

#pragma mark - Getter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init]; // 瀑布流
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // 横向
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,15,kWidth,130) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = Color(@"#F0F0F0");
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"XWShareCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:XWShareCollectionViewCellID];
    }
    return _collectionView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight-194, kWidth, 194)];
        _bgView.backgroundColor = Color(@"#F0F0F0");
    }
    return _bgView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-194)];
        _topView.backgroundColor = [UIColor clearColor];
    }
    return _topView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, kWidth, 46)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, 0, kWidth, 46);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:13];
        [_cancelBtn setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
        
        @weakify(self)
        [[[_cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self tapCancelAction];
        }];
    }
    return _cancelBtn;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    }
    return _backView;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    
    [self addSubview:self.backView];
    [self.backView addSubview:self.topView];
    [self.backView addSubview:self.bgView];
    [self.bgView addSubview:self.collectionView];
    [self.bgView addSubview:self.bottomView];
    [self.bottomView addSubview:self.cancelBtn];
    
    POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBackgroundColor];
    spring.toValue = ColorA(0, 0, 0, 0.5);
    [self.backView.layer pop_addAnimation:spring forKey:@"bgColor"];
    
    POPSpringAnimation *spring1 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    spring1.fromValue = [NSValue valueWithCGRect:CGRectMake(0, kHeight, kWidth, 194)];
    spring1.toValue = [NSValue valueWithCGRect:CGRectMake(0, kHeight-194, kWidth, 194)];
    [self.bgView.layer pop_addAnimation:spring1 forKey:@"frame"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCancelAction)];
    [self.topView addGestureRecognizer:tap];
}

- (void)tapCancelAction{
    POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBackgroundColor];
    spring.toValue = ColorA(0, 0, 0, 0);
    [self.backView.layer pop_addAnimation:spring forKey:@"bgColor"];
    POPSpringAnimation *spring1 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    spring1.fromValue = [NSValue valueWithCGRect:CGRectMake(0, kHeight-194, kWidth, 194)];
    spring1.toValue = [NSValue valueWithCGRect:CGRectMake(0, kHeight, kWidth, 194)];
    [self.bgView.layer pop_addAnimation:spring1 forKey:@"frame1"];
    spring1.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [self removeFromSuperview];
    };
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(didSelectShareItemAtIndex:)]) {
        [self.delegate didSelectShareItemAtIndex:indexPath.item];
    }
    [self tapCancelAction];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kWidth)/2, 130);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
    // 判断有没有安装微信
//    return ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) ? 2 : 0;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XWShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XWShareCollectionViewCellID forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:{
            [cell setIcon:@"icon_share_wx" title:@"分享给朋友"];
        }
            break;
        case 1:{
            [cell setIcon:@"icon_share_pyq" title:@"分享到朋友圈"];
        }
            break;
        default:
            break;
    }
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
