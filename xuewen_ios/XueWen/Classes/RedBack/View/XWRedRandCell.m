//
//  XWRedRandCell.m
//  XueWen
//
//  Created by aaron on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWRedRandCell.h"

@interface XWRedRandCell()

@property (nonatomic,strong) UILabel * numLabel;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * moneyLabel;

@property (nonatomic,strong) UIImageView * iconImage;

@property (nonatomic,strong) UIView * bgView;
@property (nonatomic,strong) UIView * lineView;

@end

@implementation XWRedRandCell

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

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row +1];
}

- (void)setModel:(XWRedPakListModel *)model {
    _model = model;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.picture_all] placeholderImage:DefaultImage];
    self.nameLabel.text = model.nick_name;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元",model.price];
}

- (void)setupUI {
    
    self.backgroundColor = Color(@"#F4F4F4");
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(25);
        make.right.equalTo(self.mas_right).offset(-25);
    }];
    
    [self.bgView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom);
        make.height.offset(1);
        make.left.right.equalTo(self.bgView);
    }];
    
    
    [self.bgView addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.centerY.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(68);
        make.centerY.equalTo(self.bgView);
        make.width.height.offset(30);
    }];
    
    [self.bgView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(10);
        make.centerY.equalTo(self.bgView);
        make.width.offset(150);
    }];
    
    [self.bgView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-16);
        make.centerY.equalTo(self.bgView);
    }];
}

- (UIView *)bgView {
    
    if (!_bgView) {
        UIView * bgView = [UIView new];
        _bgView = bgView;
        bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIView *)lineView {
    
    if (!_lineView) {
        UIView * lineView = [UIView new];
        _lineView = lineView;
        lineView.backgroundColor = Color(@"#DCDCDC");
    }
    return _lineView;
}

- (UIImageView *)iconImage {
    
    if (!_iconImage) {
        UIImageView * iconImage = [UIImageView new];
        _iconImage = iconImage;
        iconImage.layer.cornerRadius = 15;
        iconImage.clipsToBounds = YES;
        iconImage.backgroundColor = [UIColor redColor];
    }
    return _iconImage;
}

- (UILabel *)numLabel {
    
    if (!_numLabel) {
        _numLabel = [UILabel creatLabelWithFontName:kRegFont TextColor:Color(@"#666666") FontSize:12 Text:@"1"];
        
    }
    return _numLabel;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {

        _nameLabel = [UILabel createALabelText:@"昵*****称" withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#666666")];
    }
    return _nameLabel;
}

- (UILabel *)moneyLabel {
    
    if (!_moneyLabel) {
        _moneyLabel = [UILabel creatLabelWithFontName:kRegFont TextColor:Color(@"#666666") FontSize:12 Text:@"188元"];
        
    }
    return _moneyLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
