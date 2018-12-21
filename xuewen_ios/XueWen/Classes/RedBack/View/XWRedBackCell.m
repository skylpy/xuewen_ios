//
//  XWRedBackCell.m
//  XueWen
//
//  Created by aaron on 2018/9/8.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWRedBackCell.h"

@interface XWRedBackCell()

@property (nonatomic,strong) UILabel * titleLabel;

@end

@implementation XWRedBackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(46);
        make.right.equalTo(self.mas_right).offset(-46);
        make.centerY.equalTo(self);
    }];
}

- (void)setModel:(XWRedBackModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"";
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont fontWithName:kRegFont size:13];
        _titleLabel.textColor = Color(@"#F9F9F9");
    }
    return _titleLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
