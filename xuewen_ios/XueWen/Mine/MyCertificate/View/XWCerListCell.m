//
//  XWCerListCell.m
//  XueWen
//
//  Created by aaron on 2018/8/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCerListCell.h"

@interface XWCerListCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation XWCerListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 5;
    self.bgView.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(XWCerListModel *)model {
    _model = model;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.show_picture_all] placeholderImage:DefaultImage];
    self.nameLabel.text = model.job;
    self.timeLabel.text = [model.create_time isEqualToString:@""]?model.create_time : [NSString stringWithFormat:@"获得时间：%@",model.create_time];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end

#pragma XWCerHeaderView

@interface XWCerHeaderView()


@property (nonatomic,strong) UIView * leftLine;
@property (nonatomic,strong) UILabel * rightLine;

@end

@implementation XWCerHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.leftLine];
    [self addSubview:self.rightLine];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    
    }];
    
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.titleLabel.mas_left).offset(-10);
        make.centerY.equalTo(self.titleLabel);
        make.height.offset(1);
        make.width.offset(34);
    }];
    
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.centerY.equalTo(self.titleLabel);
        make.height.offset(1);
        make.width.offset(34);
    }];
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel createALabelText:@"上岗认证" withFont:[UIFont fontWithName:kRegFont size:15] withColor:Color(@"#323232")];
    }
    return _titleLabel;
}

- (UIView *)leftLine {
    
    if (!_leftLine) {
        _leftLine = [UIView new];
        _leftLine.backgroundColor = Color(@"#C9C7C7");
    }
    return _leftLine;
}

- (UIView *)rightLine {
    
    if (!_rightLine) {
        _rightLine = [UIView new];
        _rightLine.backgroundColor = Color(@"#C9C7C7");
    }
    return _rightLine;
}

@end
