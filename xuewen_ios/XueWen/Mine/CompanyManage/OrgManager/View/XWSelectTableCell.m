//
//  XWSelectTableCell.m
//  XueWen
//
//  Created by Karron Su on 2018/12/12.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWSelectTableCell.h"

@interface XWSelectTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *partmentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLayout;


@end

@implementation XWSelectTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - Setter
- (void)setHideRight:(BOOL)hideRight {
    _hideRight = hideRight;
    
    self.partmentLabel.hidden = _hideRight;
    
}

- (void)setChildren:(XWChildrenDepartmentModel *)children {
    _children = children;
    self.titleLabel.text = _children.department_name;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setDepartmentName:(NSString *)departmentName {
    _departmentName = departmentName;
    self.partmentLabel.text = _departmentName;
}

@end
