//
//  ClassesHeaderView.m
//  XueWen
//
//  Created by ShaJin on 2017/11/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "ClassesHeaderView.h"
#import "ClassesSelectViewDelegate.h"
#import "ClassesAllLessionView.h"
#import "ClassesSortLessionView.h"
#import "ClassesHeaderButton.h"
#import "ClassesSelectLessionView.h"
#import "CourseModel.h"
#pragma mark- ClassesHeaderView
@interface ClassesHeaderView()<ClassesSelectViewDelegate>

@property (nonatomic, assign) BOOL all;
@property (nonatomic, strong) ClassesHeaderButton  *sortButton;
@property (nonatomic, strong) ClassesHeaderButton  *allButton;
@property (nonatomic, strong) ClassesHeaderButton  *selectButton;
@property (nonatomic, strong) UIView               *selectView;
@property (nonatomic, strong) UIView               *backgroundView;
@property (nonatomic, assign) NSInteger            selectIndex;

@property (nonatomic, strong) ClassesAllLessionView        *allLessionView;
@property (nonatomic, strong) ClassesSortLessionView       *sortLessionView;
@property (nonatomic, strong) ClassesSelectLessionView     *selectLessionView;

@end
@implementation ClassesHeaderView
#pragma mark- ClassesSelectViewDelegate
- (void)sortLessionDidSelect:(NSString *)text dismiss:(BOOL)dismiss{
    if ([self.delegate respondsToSelector:@selector(sortLessionDidSelect:dismiss:)]) {
        [self.delegate sortLessionDidSelect:text dismiss:dismiss];
    }
    self.sortButton.title = text;
    [self dismiss:dismiss];
}

- (void)allLessionDidSelectLabel:(CourseLabelModel *)model dismiss:(BOOL)dismiss{
    if (model) {
        if ([self.delegate respondsToSelector:@selector(allLessionDidSelectLabel:dismiss:)] && dismiss) {
            [self.delegate allLessionDidSelectLabel:model dismiss:dismiss];
        }
        self.allButton.title = model.labelName;
    }else{
        self.allButton.title = @"全部";
    }
    [self dismiss:dismiss];
}

- (void)selectLessionDidSelect:(NSString *)text dismiss:(BOOL)dismiss{
    if ([self.delegate respondsToSelector:@selector(selectLessionDidSelect:dismiss:)]) {
        [self.delegate selectLessionDidSelect:text dismiss:dismiss];
    }
    self.selectButton.title = text;
    [self dismiss:dismiss];
}

#pragma mark- CustomMethod
- (void)clearButtonColor{
    self.sortButton.isSelect = NO;
    self.allButton.isSelect = NO;
    self.selectButton.isSelect = NO;
}

- (void)sortAction:(UIButton *)sender{
    [self clearButtonColor];
    self.sortButton.isSelect = YES;
    if (self.selectIndex != 1) {
        self.selectView = self.sortLessionView;
        self.show = YES;
        self.selectIndex = 1;
    }else{
        self.show = NO;
    }
}

- (void)allAction:(UIButton *)sender{
    [self clearButtonColor];
    self.allButton.isSelect = YES;
    if (self.selectIndex != 2) {
        ClassesAllLessionView *view = [[ClassesAllLessionView alloc] initWithSelect:self.allButton.title];
        view.delegate = self;
        self.selectView = view;
        self.show = YES;
        self.selectIndex = 2;
    }else{
        self.show = NO;
    }
}

- (void)selectAction:(UIButton *)sender{
    [self clearButtonColor];
    self.selectButton.isSelect = YES;
    if (self.selectIndex != 3) {
        self.selectView = self.selectLessionView;
        self.show = YES;
        self.selectIndex = 3;
    }else{
        self.show = NO;
    }
}

- (void)dismiss:(BOOL)dismiss{
    if (dismiss) {
        self.show = NO;
    }
}

- (void)resetFrame{
    self.allLessionView.frame = CGRectMake(0, 45 + kNaviBarH , kWidth, 250);
    self.sortLessionView.frame = CGRectMake(0, 45 + kNaviBarH , kWidth, 180);
    self.selectLessionView.frame = CGRectMake(0, 45 + kNaviBarH , kWidth, 108);
}

#pragma mark- 初始化
- (instancetype)initWithFrame:(CGRect)frame all:(BOOL)all{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.all = all;
        
        [self addSubview:self.sortButton];
        [self addSubview:self.selectButton];
        if (all) {
            [self addSubview:self.allButton];
        }
        
    }
    return self;
}

#pragma mark- Setter
- (void)setSelectView:(UIView *)selectView{
    [_selectView removeFromSuperview];
    _selectView = selectView;
}

- (void)setShow:(BOOL)show{
    _show = show;
    if (show) {
        CGRect frame = self.selectView.frame;
        self.selectView.frame = CGRectMake(0, 45 + kNaviBarH, kWidth, 0);
        [self addSubview:self.selectView];
        self.backgroundView.alpha = 0.0;
        [kMainWindow addSubview:self.backgroundView];
        [kMainWindow addSubview:self.selectView];
        XWWeakSelf
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.selectView.frame = frame;
            weakSelf.backgroundView.alpha = 0.5;
        }];
    }else{
        XWWeakSelf
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.selectView.frame = CGRectMake(0, 45 + kNaviBarH, kWidth, 0);
            weakSelf.backgroundView.alpha = 0.0;
        
        }completion:^(BOOL finished) {
            [weakSelf.selectView removeFromSuperview];
            [weakSelf.backgroundView removeFromSuperview];
            weakSelf.selectIndex = 0;
            [weakSelf clearButtonColor];
            [weakSelf resetFrame];
        }];
    }
}

- (void)removeSubViews{
    [self.selectView removeFromSuperview];
    [self.backgroundView removeFromSuperview];
}

- (void)setAllButtonTitle:(NSString *)allButtonTitle{
    _allButtonTitle = allButtonTitle;
    self.allButton.title = allButtonTitle;
}

#pragma mark- Getter
- (ClassesSortLessionView *)sortLessionView{
    if (!_sortLessionView) {
        _sortLessionView = [[ClassesSortLessionView alloc] initWithSelect:nil];
        _sortLessionView.delegate = self;
    }
    return _sortLessionView;
}

- (ClassesSelectLessionView *)selectLessionView{
    if (!_selectLessionView) {
        _selectLessionView =[[ClassesSelectLessionView alloc] initWithSelect:nil];
        _selectLessionView.delegate = self;
    }
    return _selectLessionView;
}

- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,45 + kNaviBarH, kWidth, kHeight - 45 - kNaviBarH)];
        _backgroundView.backgroundColor = [UIColor blackColor];
        [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
        _backgroundView.userInteractionEnabled = YES;
    }
    return _backgroundView;
}

- (void)tapAction:(UIGestureRecognizer *)sender{
    self.show = NO;
}

- (ClassesHeaderButton *)sortButton{
    if (!_sortButton) {
        _sortButton = [[ClassesHeaderButton alloc] initWithFrame:CGRectMake(0, 0, (_all)? kWidth / 3.0 : kWidth / 2.0, 45)];
        _sortButton.title = @"综合排序";
        [_sortButton addTarget:self action:@selector(sortAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortButton;
}

- (ClassesHeaderButton *)allButton{
    if (!_allButton) {
        _allButton = [[ClassesHeaderButton alloc] initWithFrame:CGRectMake( kWidth / 3.0 , 0,  kWidth / 3.0 , 45)];
        _allButton.title = @"全部";
        [_allButton addTarget:self action:@selector(allAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allButton;
}

- (ClassesHeaderButton *)selectButton{
    if (!_selectButton) {
        _selectButton = [[ClassesHeaderButton alloc] initWithFrame:CGRectMake((_all)? kWidth / 3.0 * 2 : kWidth / 2.0 , 0, (_all)? kWidth / 3.0 : kWidth / 2.0 , 45)];
        _selectButton.title = @"筛选";
        [_selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 204 / 255.0, 204 / 255.0, 204 / 255.0, 1.0);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 0.5);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, kWidth ,0);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, 45);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, kWidth ,45);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}
@end
