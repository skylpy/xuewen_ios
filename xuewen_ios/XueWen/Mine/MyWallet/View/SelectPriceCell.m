//
//  SelectPriceCell.m
//  XueWen
//
//  Created by ShaJin on 2017/12/7.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "SelectPriceCell.h"
#import "PriceButton.h"
@interface SelectPriceCell()<UITextFieldDelegate>

@property (nonatomic, strong) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UITextField *customMoney;
@property (weak, nonatomic) IBOutlet PriceButton *button1;
@property (weak, nonatomic) IBOutlet PriceButton *button2;
@property (weak, nonatomic) IBOutlet PriceButton *button3;
@property (weak, nonatomic) IBOutlet PriceButton *button4;
@property (weak, nonatomic) IBOutlet PriceButton *button5;
@property (weak, nonatomic) IBOutlet PriceButton *button6;


@end
@implementation SelectPriceCell
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // 限制特殊字符输入
    return [@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@""] containsObject:string];
}

- (void)textChanged:(UITextField *)sender{
    // 最大金额为5000
    if([sender.text integerValue] > 5000) {
        sender.text = @"5000";
    }
    self.price = [sender.text integerValue];
    for (PriceButton *button in self.buttons) {
        button.isSelect = NO;
    }
}

- (void)buttonAction:(PriceButton *)sender{
    for (PriceButton *button in self.buttons) {
        if (button == sender) {
            button.isSelect = YES;
            self.price = button.price;
        }else{
            button.isSelect = NO;
        }
    }
    self.customMoney.text = @"";
    [self.customMoney resignFirstResponder];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *price = @[@6,@12,@30,@68,@108,@1048];
    for (int i = 0 ; i < self.buttons.count; i++) {
        PriceButton *button = self.buttons[i];
        button.price = [price[i] integerValue];
        button.isSelect = (i == 0);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.price = 6;
//    self.customMoney.layer.borderWidth = 1;
//    self.customMoney.layer.borderColor = COLOR(204, 204, 204).CGColor;
//    [self.customMoney addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
//    self.customMoney.delegate = self;
}

- (void)clear{
    for (int i = 0 ; i < self.buttons.count; i++) {
        PriceButton *button = self.buttons[i];
        button.isSelect = (i == 0);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.customMoney.text = @"";
}

- (NSArray *)buttons{
    if (!_buttons) {
        _buttons = @[self.button1,self.button2,self.button3,self.button4,self.button5,self.button6];
    }
    return _buttons;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
