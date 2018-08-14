//
//  InvitationDetailHeaderView.m
//  XueWen
//
//  Created by ShaJin on 2018/3/20.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "InvitationDetailHeaderView.h"
@interface InvitationDetailHeaderView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) BaseAlertView *alertView;
@property (nonatomic, strong) UIPickerView *datePicker;
@property (nonatomic, strong) NSArray *dateArray;

@end

@implementation InvitationDetailHeaderView
#pragma mark- PickerDeleaget
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dateArray.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)componen{
    return self.dateArray[row];
}

#pragma mark- CustomMethod
- (void)confirmAction:(UIButton *)sender{
    NSInteger index = [self.datePicker selectedRowInComponent:0];
    self.dateLabel.text = self.dateArray[index];
    self.dateLabel.sd_layout.widthIs([self.dateLabel.text widthWithSize:self.dateLabel.font.pointSize]);
    [self.alertView dismiss];
    if (self.CompleteBlock) {
        self.CompleteBlock(self.dateLabel.text);
    }
}

- (void)cancelAction:(UIButton *)sender{
    [self.alertView dismiss];
}

- (void)buttonAction:(UIButton *)sender{
    [self.alertView show];
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = DefaultBgColor;
        [self addSubview:self.dateLabel];
        [self addSubview:self.button];
        self.dateLabel.text = self.dateArray[0];
        self.dateLabel.sd_layout.leftSpaceToView(self, 15).bottomSpaceToView(self, 10).heightIs(13).widthIs([self.dateLabel.text widthWithSize:self.dateLabel.font.pointSize]);
        self.button.sd_layout.bottomSpaceToView(self, 0).rightSpaceToView(self, 6).widthIs(33).heightIs(33);
    }
    return self;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [UILabel labelWithTextColor:DefaultTitleBColor size:13];
    }
    return _dateLabel;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:0];
        [_button setImage:LoadImage(@"ico_date") forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (BaseAlertView *)alertView{
    if (!_alertView) {
        _alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, kHeight - 194 - kBottomH, kWidth, 194 + kBottomH)];
        _alertView.animationType = kAnimationBottom;
        _alertView.cornerRadius = 0;
        _alertView.backgroundColor = DefaultBgColor;
        // 背景
        UIView *backgroundView = [UIView new];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [_alertView addSubview:backgroundView];
        backgroundView.sd_layout.topSpaceToView(_alertView, 44).leftSpaceToView(_alertView, 0 ).bottomSpaceToView(_alertView, 0).rightSpaceToView(_alertView, 0);
        
        [backgroundView addSubview:self.datePicker];
        self.datePicker.sd_layout.topSpaceToView(backgroundView, 0).leftSpaceToView(backgroundView, 0).bottomSpaceToView(backgroundView, kBottomH).rightSpaceToView(backgroundView, 0);
        // 确认
        UIButton *confirmButton = [UIButton buttonWithType:0];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:kThemeColor forState:UIControlStateNormal];
        confirmButton.titleLabel.font = kFontSize(16);
        [confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:confirmButton];
        confirmButton.sd_layout.topSpaceToView(_alertView, 0).rightSpaceToView(_alertView, 0).heightIs(44).widthIs(70);
        
        // 取消
        UIButton *cancelButton = [UIButton buttonWithType:0];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:DefaultTitleBColor forState:UIControlStateNormal];
        cancelButton.titleLabel.font = kFontSize(16);
        [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:cancelButton];
        cancelButton.sd_layout.topSpaceToView(_alertView, 0).leftSpaceToView(_alertView, 0).heightIs(44).widthIs(70);
        
        
    }
    return _alertView;
}

- (UIPickerView *)datePicker{
    if (!_datePicker) {
        _datePicker = [UIPickerView new];
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
    }
    return _datePicker;
}

- (NSArray *)dateArray{
    if (!_dateArray) {
        NSString *date = [NSDate dateWithFormat:@"YYYY-MM"];
        NSArray *array = [date componentsSeparatedByString:@"-"];
        if (array.count == 2) {
            NSMutableArray *mArray = [NSMutableArray array];
            int year = [array[0] intValue];
            int month = [array[1] intValue];
            for (int i = 0; i < 12; i++) {
                [mArray addObject:[NSString stringWithFormat:@"%d-%02d",year,month--]];
                if (month <= 0) {
                    month = 12;
                    year -= 1;
                }
            }
            _dateArray = mArray;
        }
    }
    return _dateArray;
}

@end
