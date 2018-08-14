//
//  XWHomeLickCell.m
//  XueWen
//
//  Created by Karron Su on 2018/7/20.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHomeLickCell.h"

@interface XWHomeLickCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *coursIndLabel;
@property (weak, nonatomic) IBOutlet UILabel *tchLabel;
@property (weak, nonatomic) IBOutlet UILabel *tchIndLabel;
@property (weak, nonatomic) IBOutlet UILabel *learnCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

@implementation XWHomeLickCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.icon rounded:2];
    [self.learnCountLabel rounded:3];
}

#pragma mark - Setter

- (void)setModel:(XWCourseIndexModel *)model{
    _model = model;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:_model.coverPhotoAll] placeholderImage:DefaultImage];
    self.titleLabel.text = _model.courseName;
    self.coursIndLabel.text = _model.shortIntroduction;
    self.tchLabel.text = _model.name;
    if (_model.total == nil) {
        _model.total = @"0";
    }
    self.learnCountLabel.text = [NSString stringWithFormat:@" %@人学习 ", _model.total];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", _model.price];
    self.tchIndLabel.text = [NSString filterHTML:_model.teacherProfile];

}

- (void)setHideLine:(BOOL)hideLine{
    _hideLine = hideLine;
    self.lineView.hidden = _hideLine;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
