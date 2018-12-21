//
//  XWStaffFooterView.m
//  XueWen
//
//  Created by Karron Su on 2018/12/13.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWStaffFooterView.h"

@interface XWStaffFooterView ()

@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation XWStaffFooterView

#pragma mark - Getter
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"移除该员工" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:Color(@"#FD4743") forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _deleteBtn.backgroundColor = [UIColor whiteColor];
        [_deleteBtn rounded:2 width:1 color:Color(@"#DDDDDD")];
        @weakify(self)
        [[_deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            !self.block ? : self.block();
        }];
    }
    return _deleteBtn;
}

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(-15);
        make.height.mas_equalTo(45);
    }];
}

@end
