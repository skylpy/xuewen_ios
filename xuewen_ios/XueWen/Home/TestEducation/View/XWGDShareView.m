//
//  XWGDShareView.m
//  XueWen
//
//  Created by aaron on 2018/10/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWGDShareView.h"
#import "WXApi.h"
#import "XWShareCollectionViewCell.h"
#import "POP.h"
static NSString *const XWShareCollectionViewCellID = @"XWShareCollectionViewCellID";
@interface XWGDShareView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *topView;



@property (nonatomic, strong) UIView *backView;

@end
@implementation XWGDShareView


#pragma mark - Getter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init]; // 瀑布流
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // 横向
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,kWidth,148) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = Color(@"#F0F0F0");
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"XWShareCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:XWShareCollectionViewCellID];
    }
    return _collectionView;
}



- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 148)];
        
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
    
    [self addSubview:self.collectionView];
//    [self.bgView addSubview:self.collectionView];

    
//    POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBackgroundColor];
//    spring.toValue = ColorA(0, 0, 0, 0.5);
//    [self.backView.layer pop_addAnimation:spring forKey:@"bgColor"];
//
//    POPSpringAnimation *spring1 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
//    spring1.fromValue = [NSValue valueWithCGRect:CGRectMake(0, kHeight, kWidth, 194)];
//    spring1.toValue = [NSValue valueWithCGRect:CGRectMake(0, kHeight-194, kWidth, 194)];
//    [self.bgView.layer pop_addAnimation:spring1 forKey:@"frame"];
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCancelAction)];
//    [self.topView addGestureRecognizer:tap];
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
        !self.codeClick?:self.codeClick();
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
    return CGSizeMake((kWidth-20)/3, 130);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    // 判断有没有安装微信
    return ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) ? 3 : 1;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XWShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XWShareCollectionViewCellID forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:{
            [cell setIcon:@"icon_share_hb" title:@"保存本地"];
        }break;
        case 1:{
            [cell setIcon:@"icon_share_wx" title:@"分享到微信"];
            
        }break;
        case 2:{
            [cell setIcon:@"icon_share_pyq" title:@"分享到朋友圈"];
        }break;
            
        default:
            break;
    }
    return cell;
}

@end
