//
//  XWTestEduListCell.m
//  XueWen
//
//  Created by aaron on 2018/10/18.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWTestEduListCell.h"
#import "CAShapeLayer+XWLayer.h"

@interface XWTestEduListCell()

@property (nonatomic,strong) UIView * bgView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIImageView * picImage;
@property (nonatomic,strong) UILabel * desLabel;

@end

@implementation XWTestEduListCell

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

- (void)setModel:(XWTestEduModel *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    self.desLabel.text = [NSString filterHTML:model.desc];
    [self.picImage setImageWithURL:[NSURL URLWithString:model.picture] placeholder:DefaultImage];
}

- (void)drawUI {
    
    self.backgroundColor = Color(@"#F4F4F4");
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.picImage];
    [self.bgView addSubview:self.desLabel];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(8);
        make.right.equalTo(self.mas_right).offset(-8);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo (self.bgView.mas_top).offset(10);
        make.left.equalTo(self.bgView.mas_left).offset(8);
        make.right.equalTo(self.bgView.mas_right).offset(-8);
        make.height.offset(18);
    }];
    
    [self.picImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bgView.mas_left).offset(8);
        make.right.equalTo(self.bgView.mas_right).offset(-8);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.height.offset(150);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.picImage.mas_bottom).offset(5);
        make.left.equalTo(self.bgView.mas_left).offset(8);
        make.right.equalTo(self.bgView.mas_right).offset(-8);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-8);
    }];
    
    
}

- (UIView *)bgView {
    
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 3;
        _bgView.clipsToBounds = YES;
    }
    return _bgView;
}

#pragma titleLabel
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel createALabelText:@"销售助理上岗测试" withFont:  [UIFont fontWithName:kRegFont size:13] withColor:Color(@"#333333")];
       
    }
    return _titleLabel;
}

#pragma desLabel
- (UILabel *)desLabel {
    
    if (!_desLabel) {
        _desLabel = [UILabel createALabelText:@"你是否具备成为一名合格销售助理的五大能力？一侧便知！" withFont:  [UIFont fontWithName:kRegFont size:12] withColor:Color(@"#333333")];
        
    }
    return _desLabel;
}

#pragma picImage
- (UIImageView *)picImage {
    
    if (!_picImage) {
        _picImage = [[UIImageView alloc] init];
        _picImage.backgroundColor = [UIColor lightGrayColor];
        _picImage.layer.cornerRadius = 3;
        _picImage.clipsToBounds = YES;
        
    }
    return _picImage;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
