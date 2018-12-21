//
//  XWDepartmentTitleView.m
//  XueWen
//
//  Created by Karron Su on 2018/12/13.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWDepartmentTitleView.h"
#import "XWDepartmentListModel.h"

@interface XWDepartmentTitleView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation XWDepartmentTitleView

#pragma mark - Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 55)];
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(2*kWidth, 55);
    }
    return _scrollView;
}

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    
    [self addSubview:self.scrollView];
}

#pragma mark - Setter
- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self.scrollView removeAllSubviews];
    __block CGFloat contentSizeWidth = 50;
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XWChildrenDepartmentModel *title = (XWChildrenDepartmentModel *)obj;
        CGFloat width;
        width = [title.department_name widthForFont:[UIFont fontWithName:kRegFont size:15]];
        contentSizeWidth = width + contentSizeWidth;
    }];
    
    self.scrollView.contentSize = CGSizeMake(contentSizeWidth, 0);
    __block UIImage *icon = LoadImage(@"goon_ico2");
    __block CGFloat width;
    XWWeakSelf
    [_titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XWChildrenDepartmentModel *title = (XWChildrenDepartmentModel *)obj;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[NSString stringWithFormat:@" %@", title.department_name] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        CGFloat width1 = 15;
        
        if (idx != 0) {
            [btn setImage:icon forState:UIControlStateNormal];
            XWChildrenDepartmentModel *model = titles[idx-1];
            width1 = [model.department_name widthForFont:[UIFont fontWithName:kRegFont size:15]];
            width1 += 10 * idx;
        }
        
        width = width1 + width;
        
        if (idx == titles.count - 1) {
            [btn setTitleColor:Color(@"#999999") forState:UIControlStateNormal];
            btn.userInteractionEnabled = NO;
        }else {
            [btn setTitleColor:Color(@"#2E6AE1") forState:UIControlStateNormal];
            btn.userInteractionEnabled = YES;
        }
        
        [weakSelf.scrollView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.scrollView);
            make.left.mas_equalTo(weakSelf.scrollView).offset(width);
        }];
        @weakify(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(weakSelf)
            !weakSelf.block ? : weakSelf.block(title);
        }];
    }];
}

@end
