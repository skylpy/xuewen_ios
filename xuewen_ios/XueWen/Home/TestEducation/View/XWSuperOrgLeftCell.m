//
//  XWSuperOrgLeftCell.m
//  XueWen
//
//  Created by aaron on 2018/10/19.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWSuperOrgLeftCell.h"

/**
 *注释
 *XWSuperOrgLeftCell
 */
@interface XWSuperOrgLeftCell ()

@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * desLabel;
@property (nonatomic,strong) UIImageView * iconImage;
@property (nonatomic,strong) UIImageView * bgImage;

@end

@implementation XWSuperOrgLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawUI];
    }
    return self;
}

- (void)setModel:(XWSuperGModel *)model {
    _model = model;
    
    self.titleLabel.text = model.course_name;
    self.nameLabel.text = model.tch_org;
    self.desLabel.text = [NSString filterHTML:model.tch_org_introduction];
    
    [self.iconImage setImageWithURL:[NSURL URLWithString:model.tch_org_photo_all] placeholder:DefaultImage];
}

- (void)drawUI {
    
    [self addSubview:self.bgImage];
    [self addSubview:self.iconImage];
    [self addSubview:self.titleLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.desLabel];
    
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(27);
        make.height.width.offset(66);
        make.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo (self.iconImage.mas_top);
        make.left.equalTo(self.iconImage.mas_right).offset(23);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo (self.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.iconImage.mas_right).offset(23);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo (self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.iconImage.mas_right).offset(23);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
}

#pragma titleLabel
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel createALabelText:@"第一课目标100%达成系统" withFont:  [UIFont fontWithName:kRegFont size:15] withColor:Color(@"#333333")];
        
    }
    return _titleLabel;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [UILabel createALabelText:@"张栋" withFont:  [UIFont fontWithName:kRegFont size:14] withColor:Color(@"#000000")];
        
    }
    return _nameLabel;
}


#pragma desLabel
- (UILabel *)desLabel {
    
    if (!_desLabel) {
        _desLabel = [UILabel createALabelText:@"合才控股集团董事长 /华企在线商学院创始人" withFont:  [UIFont fontWithName:kRegFont size:11] withColor:Color(@"#666666")];
        
    }
    return _desLabel;
}

#pragma picImage
- (UIImageView *)iconImage {
    
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.backgroundColor = [UIColor lightGrayColor];
        _iconImage.layer.cornerRadius = 33;
        _iconImage.clipsToBounds = YES;
        
    }
    return _iconImage;
}


- (UIImageView *)bgImage {
    
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc] init];
        _bgImage.image = [UIImage imageNamed:@"background_super_edu_cell"];
        
    }
    return _bgImage;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

/**
 *注释
 *XWSuperOrgRightCell
 */

@interface XWSuperOrgRightCell ()

@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * desLabel;
@property (nonatomic,strong) UIImageView * iconImage;
@property (nonatomic,strong) UIImageView * bgImage;

@end

@implementation XWSuperOrgRightCell

#pragma mark - lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawUI];
    }
    return self;
}

- (void)setModel:(XWSuperGModel *)model {
    _model = model;
    
    self.titleLabel.text = model.course_name;
    self.nameLabel.text = model.tch_org;
    self.desLabel.text = [NSString filterHTML:model.tch_org_introduction];
    
    [self.iconImage setImageWithURL:[NSURL URLWithString:model.tch_org_photo_all] placeholder:DefaultImage];
}

- (void)drawUI {
    
//    [self addSubview:self.bgImage];
    [self addSubview:self.iconImage];
    [self addSubview:self.titleLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.desLabel];
    
//    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.edges.equalTo(self);
//    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-27);
        make.height.width.offset(66);
        make.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo (self.iconImage.mas_top);
        make.right.equalTo(self.iconImage.mas_left).offset(-23);
        make.left.equalTo(self.mas_left).offset(20);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo (self.titleLabel.mas_bottom).offset(5);
        make.right.equalTo(self.iconImage.mas_left).offset(-23);
        make.left.equalTo(self.mas_left).offset(20);
    }];
    
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo (self.nameLabel.mas_bottom).offset(5);
        make.right.equalTo(self.iconImage.mas_left).offset(-23);
        make.left.equalTo(self.mas_left).offset(20);
    }];
}

#pragma titleLabel
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel createALabelText:@"第二课【打造互联网超级组织】" withFont:  [UIFont fontWithName:kRegFont size:15] withColor:Color(@"#333333")];
        
    }
    return _titleLabel;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [UILabel createALabelText:@"王云" withFont:  [UIFont fontWithName:kRegFont size:14] withColor:Color(@"#000000")];
        
    }
    return _nameLabel;
}


#pragma desLabel
- (UILabel *)desLabel {
    
    if (!_desLabel) {
        _desLabel = [UILabel createALabelText:@"北京大学心理学硕士/学问商学院联合创始人兼CEO" withFont:  [UIFont fontWithName:kRegFont size:11] withColor:Color(@"#666666")];
        
    }
    return _desLabel;
}

#pragma picImage
- (UIImageView *)iconImage {
    
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.backgroundColor = [UIColor lightGrayColor];
        _iconImage.layer.cornerRadius = 33;
        _iconImage.clipsToBounds = YES;
        
    }
    return _iconImage;
}


- (UIImageView *)bgImage {
    
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc] init];
        _bgImage.image = [UIImage imageNamed:@"background_super_edu_cell"];
        
    }
    return _bgImage;
}

@end
