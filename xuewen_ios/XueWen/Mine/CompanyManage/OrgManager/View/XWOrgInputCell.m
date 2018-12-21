//
//  XWOrgInputCell.m
//  XueWen
//
//  Created by Karron Su on 2018/12/12.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWOrgInputCell.h"

@interface XWOrgInputCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputField;


@end

@implementation XWOrgInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    @weakify(self)
    [self.inputField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        !self.block ? : self.block(@{self.title : self.inputField.text});
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
    self.inputField.placeholder = [NSString stringWithFormat:@"请输入%@", _title];
}

@end
