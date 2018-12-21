//
//  XWSubProjectCourseCell.m
//  XueWen
//
//  Created by Karron Su on 2018/8/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWSubProjectCourseCell.h"

@interface XWSubProjectCourseCell ()

@property (nonatomic, strong) UIImageView *bigImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation XWSubProjectCourseCell

#pragma mark - Getter
- (UIImageView *)bigImgView{
    if (!_bigImgView) {
        _bigImgView = [[UIImageView alloc] init];
        _bigImgView.contentMode = UIViewContentModeScaleAspectFill;
        [_bigImgView rounded:2];
    }
    return _bigImgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = Color(@"#333333");
        label.font = [UIFont fontWithName:kMedFont size:14];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 2;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)nickLabel{
    if (!_nickLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = Color(@"#333333");
        label.font = [UIFont fontWithName:kMedFont size:12];
        label.textAlignment = NSTextAlignmentLeft;
        _nickLabel = label;
    }
    return _nickLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = Color(@"#FF7200");
        label.font = [UIFont fontWithName:kMedFont size:13];
        label.textAlignment = NSTextAlignmentLeft;
        _priceLabel = label;
    }
    return _priceLabel;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = Color(@"#999999");
        label.font = [UIFont fontWithName:kMedFont size:12];
        label.textAlignment = NSTextAlignmentLeft;
        _countLabel = label;
    }
    return _countLabel;
}

#pragma mark - lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    [self addSubview:self.bigImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.nickLabel];
    [self addSubview:self.countLabel];
    
    [self.bigImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(25);
        make.top.mas_equalTo(self).offset(22);
        make.size.mas_equalTo(CGSizeMake(137, 86));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bigImgView.mas_right).offset(25);
        make.right.mas_equalTo(self).offset(-26);
        make.top.mas_equalTo(self.bigImgView.mas_top);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bigImgView.mas_right).offset(25);
        make.bottom.mas_equalTo(self.bigImgView.mas_bottom);
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bigImgView.mas_right).offset(25);
        make.right.mas_equalTo(self).offset(-26);
        make.bottom.mas_equalTo(self.priceLabel.mas_top).offset(-6);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-25);
        make.bottom.mas_equalTo(self.bigImgView.mas_bottom);
    }];
}

#pragma mark - Setter
- (void)setModel:(CourseModel *)model{
    _model = model;
    [self.bigImgView sd_setImageWithURL:[NSURL URLWithString:model.coverPhoto]];
    self.titleLabel.text = model.courseName;
    self.nickLabel.text = model.teacherName;
    self.countLabel.text = [NSString stringWithFormat:@"%ld人学习", model.total];
    if (model.percentage == 0) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
        self.priceLabel.textColor = Color(@"#FD8829");
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"已学%ld%%", model.percentage];
        self.priceLabel.textColor = Color(@"#267DFF");
    }
}

- (void)setBuy:(BOOL)buy{
    _buy = buy;
    if (_buy) {
        self.priceLabel.text = [NSString stringWithFormat:@"已学%ld%%", self.model.percentage];
        self.priceLabel.textColor = Color(@"#267DFF");
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", self.model.price];
        self.priceLabel.textColor = Color(@"#FD8829");
    }
}

@end
