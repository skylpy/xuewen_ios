//
//  XWStaffTableCell.m
//  XueWen
//
//  Created by Karron Su on 2018/12/13.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWStaffTableCell.h"

@interface XWStaffTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation XWStaffTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = _name;
}

@end
