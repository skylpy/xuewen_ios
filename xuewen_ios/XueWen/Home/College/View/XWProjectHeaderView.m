//
//  XWProjectHeaderView.m
//  XueWen
//
//  Created by Karron Su on 2018/8/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWProjectHeaderView.h"
#import "XWProjectCourseController.h"

@interface XWProjectHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UILabel *introduceLabel;

@end

@implementation XWProjectHeaderView

#pragma mark - Getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:kRegFont size:11];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = Color(@"#333333");
    }
    return _titleLabel;
}

- (UIButton *)allBtn{
    if (!_allBtn) {
        _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [_allBtn setTitleColor:Color(@"#FD8829") forState:UIControlStateNormal];
        [_allBtn setTitle:@"全部" forState:UIControlStateNormal];
        [_allBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allBtn;
}

- (UILabel *)introduceLabel{
    if (!_introduceLabel) {
        _introduceLabel = [[UILabel alloc] init];
        _introduceLabel.font = [UIFont fontWithName:kMedFont size:12];
        _introduceLabel.textColor = Color(@"#333333");
        _introduceLabel.textAlignment = NSTextAlignmentLeft;
        _introduceLabel.numberOfLines = 0;
    }
    return _introduceLabel;
}

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.allBtn];
    [self addSubview:self.introduceLabel];
    self.backgroundColor = [UIColor whiteColor];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(25);
        make.top.mas_equalTo(self).offset(27);
    }];
    
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-25);
        make.top.mas_equalTo(self).offset(30);
    }];
    
    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset(0);
        make.left.mas_equalTo(self).offset(25);
        make.right.mas_equalTo(self).offset(-27);
    }];
}

#pragma mark - Setter
- (void)setModel:(ProjectModel *)model{
    _model = model;
    NSString *title = [NSString stringWithFormat:@"%@(%ld门必修)", model.projectName, model.courses.count];
    
    NSMutableAttributedString *attr = [NSMutableAttributedString setupAttributeString:title rangeText:model.projectName textFont:[UIFont fontWithName:kRegFont size:16] textColor:Color(@"#333333")];
    
    self.titleLabel.attributedText = attr;
    
    self.introduceLabel.text = [NSString filterHTML:model.introduction];
}

- (void)moreAction:(UIButton *)btn{
    XWProjectCourseController *vc = [[XWProjectCourseController alloc] init];
    vc.titleStr = self.projectName;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

