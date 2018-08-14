//
//  XWHotCoursTableCell.m
//  XueWen
//
//  Created by Karron Su on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHotCoursTableCell.h"

@interface XWHotCoursTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bigImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *intrLabel;
@property (weak, nonatomic) IBOutlet UILabel *tchLabel;
@property (weak, nonatomic) IBOutlet UILabel *tchIndLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

@implementation XWHotCoursTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bigImgView rounded:2];
    [self.countLabel rounded:3];
}

#pragma mark - Setter
- (void)setIsLast:(BOOL)isLast{
    _isLast = isLast;
    self.lineView.hidden = _isLast;
}

- (void)setModel:(XWCourseIndexModel *)model{
    _model = model;
    [self.bigImgView sd_setImageWithURL:[NSURL URLWithString:_model.coverPhotoAll] placeholderImage:DefaultImage];
    self.titleLabel.text = _model.courseName;
    self.tchLabel.text = _model.name;
    self.countLabel.text = [NSString stringWithFormat:@" %@人学习 ", _model.total];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", _model.amount];
    self.intrLabel.text = _model.shortIntroduction;
    self.tchIndLabel.text = [NSString filterHTML:_model.teacherProfile];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
