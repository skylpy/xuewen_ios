//
//  XWNoneManageCell.m
//  XueWen
//
//  Created by aaron on 2018/12/19.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWNoneManageCell.h"

@implementation XWNoneManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
