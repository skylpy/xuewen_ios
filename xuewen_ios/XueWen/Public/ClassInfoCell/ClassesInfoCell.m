//
//  ClassesInfoCell.m
//  XueWen
//
//  Created by ShaJin on 2017/11/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "ClassesInfoCell.h"
#import "CourseModel.h"
#import "ProjectModel.h"
@interface ClassesInfoCell()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIButton *startLession;
@property (nonatomic, strong) UIImageView *requireIcon;

@end
@implementation ClassesInfoCell
#pragma mark- Setter
- (void)setShowPrograss:(BOOL)showPrograss{
    _showPrograss = showPrograss;
    if (showPrograss) {
        self.countLabel.hidden = YES;
        self.priceLabel.hidden = YES;
        self.progressLabel.hidden = NO;
    }else{
        self.priceLabel.hidden = NO;
        self.countLabel.hidden = NO;
        self.progressLabel.hidden = YES;
    }
}

- (void)setModel:(CourseModel *)model{
    _model = model;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.coverPhoto]];
    self.titleLabel.text = model.courseName;
    self.titleLabel.sd_layout.heightIs([model.courseName heightWithWidth:self.titleLabel.frame.size.width size:14]);
    if ([model.price floatValue] == 0) {
        self.priceLabel.text = @"免费";
        self.priceLabel.textColor = COLOR(14, 201, 80);
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
        self.priceLabel.textColor = COLOR(252, 101, 30);
    }
    self.countLabel.text = [NSString stringWithFormat:@"%ld人学习",(long)model.total];
    self.progressLabel.text = [NSString stringWithFormat:@"已学%ld%%",(long)model.percentage];
    self.requireIcon.hidden = model.isOptional;
}

- (void)setCourse:(CourseModel *)course project:(ProjectModel *)project superOrg:(CourseModel *)superOrg price:(NSString *)price{
    NSString *imageUrl = nil;
    NSString *title = nil;
    if (course) {
        imageUrl = course.coverPhoto;
        title = course.courseName;
    }else if (project){
        imageUrl = project.picture;
        title = project.projectName;
    }else if (superOrg){
        imageUrl = superOrg.coverPhoto;
        title = superOrg.courseName;
    }
    [self.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:LoadImage(@"default_cover")];
    self.titleLabel.text = title;
    self.titleLabel.sd_layout.heightIs([title heightWithWidth:self.titleLabel.width size:14]);
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",(price.length > 0 ) ? price : @"0.00"];
    self.priceLabel.textColor = COLOR(252, 101, 30);
    self.requireIcon.hidden = YES;
    self.countLabel.hidden = YES;
    self.progressLabel.hidden = YES;
}
#pragma mark- 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        [self addSubview:self.icon];
        [self addSubview:self.titleLabel];
        [self addSubview:self.countLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.progressLabel];
        [self.icon addSubview:self.requireIcon];
        self.showPrograss = NO;
        self.icon.sd_layout.topSpaceToView(self,7.5).leftSpaceToView(self,15).widthIs(120).heightIs(75);
        
        self.requireIcon.sd_layout.topSpaceToView(self.icon,0).leftSpaceToView(self.icon,0).widthIs(30).heightIs(30);
        self.titleLabel.sd_layout.topSpaceToView(self,7.5).leftSpaceToView(self.icon,10).rightSpaceToView(self,20);
        self.priceLabel.sd_layout.leftSpaceToView(self.icon,10).bottomEqualToView(self.icon).rightSpaceToView(self,15).heightIs(12);
        self.countLabel.sd_layout.leftSpaceToView(self.icon,10).bottomSpaceToView(self.priceLabel,5).rightSpaceToView(self,15).heightIs(12);
        self.startLession.sd_layout.leftSpaceToView(self.icon,10).bottomEqualToView(self.icon).widthIs([self.startLession.titleLabel.text widthWithSize:12]).heightIs(15);
        self.progressLabel.sd_layout.leftSpaceToView(self.icon,10).bottomEqualToView(self.icon).rightSpaceToView(self,15).heightIs(12);
        self.icon.backgroundColor = [UIColor lightGrayColor];
        
        self.icon.layer.cornerRadius = 3;
        self.icon.clipsToBounds = YES;
        self.icon.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return self;
}
#pragma mark- Getter
- (UIImageView *)requireIcon{
    if (!_requireIcon) {
        _requireIcon = [UIImageView new];
        _requireIcon.image = LoadImage(@"requiredCorner");
        _requireIcon.hidden = YES;
    }
    return _requireIcon;
}

- (UIButton *)startLession{
    if (!_startLession) {
        _startLession = [UIButton buttonWithType:0];
        [_startLession setTitle:@"开始学习" forState:UIControlStateNormal];
        [_startLession setTitleColor:kThemeColor forState:UIControlStateNormal];
        _startLession.titleLabel.font = [UIFont systemFontOfSize:12];
        [_startLession addTarget:self action:@selector(startLession:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startLession;
}

- (UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [UILabel new];
        _progressLabel.textColor = kThemeColor;
        _progressLabel.font = [UIFont systemFontOfSize:12];
    }
    return _progressLabel;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
    }
    return _icon;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = COLOR(51, 51, 51);
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.font = [UIFont systemFontOfSize:10];
        _countLabel.textColor = COLOR(153, 153, 153);
        _countLabel.numberOfLines = 0;
    }
    return _countLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = [UIFont systemFontOfSize:12];
        _priceLabel.numberOfLines = 0;
    }
    return _priceLabel;
}

@end
