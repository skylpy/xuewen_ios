//
//  ProjectCoverCell.m
//  XueWen
//
//  Created by ShaJin on 2018/1/24.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "ProjectCoverCell.h"
@interface ProjectCoverCell()

@property (nonatomic, strong) UIImageView *coverImgView;

@end
@implementation ProjectCoverCell

#pragma mark - Getter
- (UIImageView *)coverImgView{
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] init];
    }
    return _coverImgView;
}

#pragma mark - Setter

- (void)setModel:(ProjectModel *)model{
    [super setModel:model];
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:LoadImage(@"default_cover")];
    
}

#pragma mark - LifeCycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    [self addSubview:self.coverImgView];
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
}

@end
