//
//  XWCourseInfoCell.m
//  XueWen
//
//  Created by Karron Su on 2018/4/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCourseInfoCell.h"

@interface XWCourseInfoCell ()

/** 背景图*/
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
/** 学习人数*/
@property (weak, nonatomic) IBOutlet UILabel *studyCountLab;
/** 课程时长*/
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLab;
/** 课程名称*/
@property (weak, nonatomic) IBOutlet UILabel *courseNameLab;
/** 老师名称*/
@property (weak, nonatomic) IBOutlet UILabel *techerLab;
/** 课程价格*/
@property (weak, nonatomic) IBOutlet UILabel *priceLab;


@end

@implementation XWCourseInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bgImgView rounded:3];
    [self.studyCountLab rounded:3];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.courseNameLab shadow:Color(@"#000000") opacity:1 radius:0 offset:CGSizeMake(1.5, 1.5)];
    self.techerLab.font = [UIFont fontWithName:kMedFont size:16];
}

#pragma mark - Setter
- (void)setIndexModel:(XWCourseIndexModel *)indexModel{
    _indexModel = indexModel;
    
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:_indexModel.coverPhotoAll] placeholderImage:DefaultImage];
    self.studyCountLab.text = [NSString stringWithFormat:@" %@人学习 ", _indexModel.total];
    self.totalTimeLab.text = _indexModel.timeLength;
    self.courseNameLab.text = _indexModel.courseName;
    self.techerLab.text = _indexModel.name;
    if ([_indexModel.amount isEqualToString:@"0.00"]) {
        self.priceLab.text = @"免费";
        self.priceLab.textColor = Color(@"#0EC950");
    }else{
        if ([_indexModel.amount isEqualToString:@""] || _indexModel.amount == nil) {
            self.priceLab.text = @"";
            self.priceLab.textColor = Color(@"#FC651E");
            return;
        }
        self.priceLab.text = [NSString stringWithFormat:@"¥%@", _indexModel.amount];
        self.priceLab.textColor = Color(@"#FC651E");
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
