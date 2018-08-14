//
//  XWHomeHeavyCell.m
//  XueWen
//
//  Created by Karron Su on 2018/7/20.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHomeHeavyCell.h"

@interface XWHomeHeavyCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation XWHomeHeavyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.icon rounded:3];
}

#pragma mark - Setter
- (void)setModel:(XWCourseIndexModel *)model{
    _model = model;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:_model.coverPhotoAll] placeholderImage:DefaultImage];
    self.titleLabel.text = _model.courseName;
    self.contentLabel.text = _model.shortIntroduction;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
