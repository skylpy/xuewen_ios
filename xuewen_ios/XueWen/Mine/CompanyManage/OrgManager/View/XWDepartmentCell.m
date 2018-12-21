//
//  XWDepartmentCell.m
//  XueWen
//
//  Created by Karron Su on 2018/12/12.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWDepartmentCell.h"

@interface XWDepartmentCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation XWDepartmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(XWChildrenDepartmentModel *)model {
    _model = model;
    self.titleLabel.text = _model.department_name;
}

@end
