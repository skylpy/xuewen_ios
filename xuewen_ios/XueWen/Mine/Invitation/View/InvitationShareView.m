//
//  InvitationShareView.m
//  XueWen
//
//  Created by ShaJin on 2018/3/9.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "InvitationShareView.h"
#import "InvitationShareViewCell.h"
#import "WXApi.h"
@interface InvitationShareView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<InvitationShareViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *cancelButton;

@end
@implementation InvitationShareView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndex:)]) {
        [self.delegate didSelectItemAtIndex:indexPath.row];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80, 48);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    // 判断有没有安装微信
    return ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) ? 4 : 2;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    InvitationShareViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:{
            [cell setIcon:@"icoPreservation" title:@"保存到本地"];
        }break;
        case 1:{
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                [cell setIcon:@"ico_wechat" title:@"分享到微信"];
            }else{
                [cell setIcon:@"iconMsg" title:@"短信分享"];
            }
            
        }break;
        case 2:{
            [cell setIcon:@"ico_pyq" title:@"分享到朋友圈"];
        }break;
        case 3:{
            [cell setIcon:@"iconMsg" title:@"短信分享"];
        }break;
        default:
            break;
    }
    return cell;
}

+ (instancetype)shareViewWithDelegate:(id<InvitationShareViewDelegate>)delegate{
    InvitationShareView *shareView = [InvitationShareView new];
    shareView.delegate = delegate;
    return shareView;
}

- (instancetype)init{
    if (self = [super initWithFrame:CGRectMake(0, kHeight - 150 - kBottomH, kWidth, 150 + kBottomH)]) {
        self.animationType = kAnimationBottom;
        self.backgroundColor = [UIColor whiteColor];
        self.cornerRadius = 0;
        [self addSubview:self.collectionView];
        [self addSubview:self.cancelButton];
        // 2431.6+7467  10145
        self.cancelButton.sd_layout.leftSpaceToView(self, 0).bottomSpaceToView(self, kBottomH).rightSpaceToView(self, 0).heightIs(44);
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init]; // 瀑布流
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // 横向
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,15,kWidth,85) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        flowLayout.minimumInteritemSpacing = 10;      // cell之间上下间隔
        flowLayout.minimumLineSpacing = ((kWidth - 80 - 240) / 4.0) ;          // cell之间左右间隔
        [_collectionView registerClass:NSClassFromString(@"InvitationShareViewCell") forCellWithReuseIdentifier:CellID];
    }
    return _collectionView;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:0];
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = kFontSize(15);
        [_cancelButton setTitleColor:DefaultTitleBColor forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 221 / 255.0, 221 / 255.0, 221 / 255.0, 1.0);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, 105);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, self.width ,105);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}

@end
