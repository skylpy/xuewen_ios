//
//  XWNearFutureCell.m
//  XueWen
//
//  Created by Karron Su on 2018/6/7.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWNearFutureCell.h"


@interface XWNearFutureCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *indLabel;
@property (weak, nonatomic) IBOutlet UILabel *tchNickLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

@implementation XWNearFutureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.imgView rounded:2];
}

- (void)setModel:(XWCourseIndexModel *)model{
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.coverPhotoAll] placeholderImage:DefaultImage];
    self.titleLabel.text = _model.courseName;
    self.tchNickLabel.text = _model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", _model.amount];
    self.indLabel.text = _model.shortIntroduction;
}

- (void)setIsLast:(BOOL)isLast{
    _isLast = isLast;
    self.lineView.hidden = _isLast;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
