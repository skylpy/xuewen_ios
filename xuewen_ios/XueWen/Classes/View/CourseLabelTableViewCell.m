//
//  CourseLabelTableViewCell.m
//  XueWen
//
//  Created by ShaJin on 2018/3/2.
//  Copyright © 2018年 ShaJin. All rights reserved.
//
// 课程库页面左侧标签cell
#import "CourseLabelTableViewCell.h"
@interface CourseLabelTableViewCell ()

@property (nonatomic, strong) UIView *selectView;

@end
@implementation CourseLabelTableViewCell
- (void)setText:(NSString *)text isSelect:(BOOL)isSelect{

    self.textLabel.textColor = isSelect ? kThemeColor : DefaultTitleAColor;
    self.backgroundColor = isSelect ? [UIColor whiteColor] : DefaultBgColor;
    self.selectView.hidden = !isSelect;
    self.textLabel.text = text;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.selectionStyle = 0;
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.selectView];
    }
    return self;
}

- (UIView *)selectView{
    if (!_selectView) {
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 50)];
        _selectView.backgroundColor = kThemeColor;
    }
    return _selectView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
