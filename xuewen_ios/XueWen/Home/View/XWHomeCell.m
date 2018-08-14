//
//  XWHomeCell.m
//  XueWen
//
//  Created by Karron Su on 2018/7/20.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHomeCell.h"

@interface XWHomeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *BigIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tchLabel;
@property (weak, nonatomic) IBOutlet UILabel *tchIndLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *learnCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

@implementation XWHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.learnCountLabel rounded:3];
    [self.BigIcon rounded:2];
}

#pragma mark - Setter

- (void)setLickModel:(XWCourseIndexModel *)lickModel{
    _lickModel = lickModel;
    
    [self.BigIcon sd_setImageWithURL:[NSURL URLWithString:_lickModel.coverPhotoAll] placeholderImage:DefaultImage];
    self.titleLabel.text = _lickModel.courseName;
    self.tchLabel.text = _lickModel.name;
    NSString *str = [NSDate dateFormTimestamp:_lickModel.shelvesTime withFormat:@"MM-dd"];
    self.timeLabel.text = [NSString stringWithFormat:@"%@更新", str];
    if (_lickModel.total == nil) {
        _lickModel.total = @"0";
    }
    self.learnCountLabel.text = [NSString stringWithFormat:@" %@人学习 ", _lickModel.total];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", _lickModel.amount];
    self.tchIndLabel.text = [NSString filterHTML:_lickModel.teacherProfile];
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
