//
//  SendNotesTypeView.m
//  XueWen
//
//  Created by ShaJin on 2017/12/19.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "SendNotesTypeView.h"
@interface sendNotesTypeButton : UIButton

@property (nonatomic, assign) BOOL isSelect;

@end

@implementation sendNotesTypeButton

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    self.imageView.image = LoadImage((isSelect) ? @"icoSelectionBoxRight" : @"purseIcoChooseNormal");
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType{
    sendNotesTypeButton *button = (sendNotesTypeButton *) [super buttonWithType:buttonType];
    [button setTitleColor:DefaultTitleBColor forState:UIControlStateNormal];
    [button setTitleColor:COLOR(204, 204, 204) forState:UIControlStateDisabled];
    button.titleLabel.font = kFontSize(13);
    button.isSelect = NO;
    return button;
}

- (void)layoutSubviews{
    self.imageView.frame = CGRectMake(15, (self.height - 11) / 2.0f, 11, 11);
    self.titleLabel.frame = CGRectMake(31.5, 0, 40, self.height);
}

@end

@interface SendNotesTypeView()

@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) sendNotesTypeButton *button1;
@property (nonatomic, strong) sendNotesTypeButton *button2;
@property (nonatomic, strong) sendNotesTypeButton *button3;

@end
@implementation SendNotesTypeView
- (void)selectAction:(UIButton *)sender{
    for (int i = 0; i < self.buttons.count; i++) {
        sendNotesTypeButton *button = self.buttons[i];
        if (button == sender) {
            self.index = i;
            break;
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = DefaultBgColor;
        [self addSubview:self.button1];
        [self addSubview:self.button2];
        [self addSubview:self.button3];
        
        self.button1.sd_layout.topSpaceToView(self,0).leftSpaceToView(self,0).bottomSpaceToView(self,0).widthIs(75);
        self.button2.sd_layout.topSpaceToView(self,0).leftSpaceToView(self.button1,0).bottomSpaceToView(self,0).widthIs(75);
        self.button3.sd_layout.topSpaceToView(self,0).leftSpaceToView(self.button2,0).bottomSpaceToView(self,0).widthIs(75);
        
        self.buttons = @[self.button1,self.button2,self.button3];
        
        self.index = 0;
    }
    return self;
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    for (int i = 0; i < self.buttons.count; i++) {
        sendNotesTypeButton *button = self.buttons[i];
        button.isSelect = (i == index);
    }
}

- (sendNotesTypeButton *)button1{
    if (!_button1) {
        _button1 = [sendNotesTypeButton buttonWithType:0];
        [_button1 setTitle:@"公开" forState:UIControlStateNormal];
        [_button1 addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}

- (sendNotesTypeButton *)button2{
    if (!_button2) {
        _button2 = [sendNotesTypeButton buttonWithType:0];
        [_button2 setTitle:@"企业" forState:UIControlStateNormal];
        [_button2 addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        _button2.enabled = ![XWInstance shareInstance].userInfo.personal;
    }
    return _button2;
}

- (sendNotesTypeButton *)button3{
    if (!_button3) {
        _button3 = [sendNotesTypeButton buttonWithType:0];
        [_button3 setTitle:@"仅自己" forState:UIControlStateNormal];
        [_button3 addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button3;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
