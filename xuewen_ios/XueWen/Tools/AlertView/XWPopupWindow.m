//
//  XWPopupWindow.m
//  XueWen
//
//  Created by ShaJin on 2017/11/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "XWPopupWindow.h"
@interface XWPopupWindow()
@property (nonatomic, copy) void (^block)(void);
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@end

@implementation XWPopupWindow
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle  buttonBlock:(void(^)(void))buttonBlock{
    CGFloat height = [message heightWithWidth:275 size:14];
    if (self = [super initWithFrame:CGRectMake(0, 0, 275, height + 170)]) {
        self.center = [UIApplication sharedApplication].keyWindow.center;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.messageLabel];
        [self addSubview:self.confirmButton];
        if (buttonBlock) {
            self.block = ^{
                buttonBlock();
            };
        }
        self.dismissOnTouchOutside = NO;
        self.titleLabel.sd_layout.topSpaceToView(self,34).centerXIs(275 / 2.0).widthIs([title widthWithSize:16]).heightIs(16);
        self.messageLabel.sd_layout.topSpaceToView(self.titleLabel,20).leftSpaceToView(self,20).rightSpaceToView(self,20).heightIs([message heightWithWidth:235 size:14]);
        self.confirmButton.sd_layout.leftSpaceToView(self,40).rightSpaceToView(self,40).bottomSpaceToView(self,35).heightIs(35);
        
        self.titleLabel.text = title;
        self.messageLabel.text = message;
        [self.confirmButton setTitle:buttonTitle forState:UIControlStateNormal];
        
    }
    return self;
}

#pragma mark- CustomMethod
- (void)confirmAction:(UIButton *)sender{
    if (self.block) {
        self.block();
    }
    [self dismiss];
}

#pragma mark- Getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = COLOR(51, 51, 51);
        _titleLabel.textAlignment = 1;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.textColor = COLOR(153, 153, 153);
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = 1;
    }
    return _messageLabel;
}

- (UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:0];
        _confirmButton.titleLabel.font = kFontSize(15);
        _confirmButton.titleLabel.textColor = [UIColor whiteColor];
        _confirmButton.backgroundColor = kThemeColor;
        [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        ViewRadius(_confirmButton, 35 / 2.0);
    }
    return _confirmButton;
}

#pragma mark- PublicMethods
/** 通用弹窗 只有一个按钮 */
+ (void)popupWindowsWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle  buttonBlock:(void(^)(void))buttonBlock{
    [[[XWPopupWindow alloc] initWithTitle:title message:message buttonTitle:buttonTitle buttonBlock:buttonBlock] show];
}

/** 通用弹窗 */
+ (void)popupWindowsWithTitle:(NSString *)title message:(NSString *)message leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle leftBlock:(void(^)(void))leftBlock rightBlock:(void(^)())rightBlock{
    
    if (leftTitle.length > 0 || rightTitle.length > 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        if (leftTitle.length > 0) {
            UIAlertAction *leftAction = [UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (leftBlock) {
                    leftBlock();
                }
            }];
            [alertController addAction:leftAction];
            // 设置按钮文字颜色
            [leftAction setValue:kThemeColor forKey:@"titleTextColor"];
        }
        if (rightTitle.length > 0) {
            UIAlertAction *rightAction = [UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (rightBlock) {
                    rightBlock();
                }
            }];
            [alertController addAction:rightAction];
            // 设置按钮文字颜色
            [rightAction setValue:kThemeColor forKey:@"titleTextColor"];
        }
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

@end
