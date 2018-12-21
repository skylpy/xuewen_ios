//
//  XWChoiceDepartmentCell.m
//  XueWen
//
//  Created by Karron Su on 2018/12/14.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWChoiceDepartmentCell.h"
#import "XWDepartmentListModel.h"

@interface XWChoiceDepartmentCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation XWChoiceDepartmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)nextBtnClick:(UIButton *)sender {
    !self.block ? : self.block(self.department);
}


#pragma mark - Setter
- (void)setIsLabel:(BOOL)isLabel {
    _isLabel = isLabel;
    self.nextBtn.hidden = _isLabel;
}

- (void)setModel:(XWLabelModel *)model {
    _model = model;
    self.titleLabel.text = _model.label_name;
}

- (void)setDepartment:(XWChildrenDepartmentModel *)department {
    _department = department;
    self.titleLabel.text = department.department_name;
    if (_department.children.count == 0 || _department.children == nil) {
        self.nextBtn.hidden = YES;
    }else {
        self.nextBtn.hidden = NO;
    }
}

- (void)setName:(NSString *)name {
    _name = name;
    self.titleLabel.text = _name;
}

@end
