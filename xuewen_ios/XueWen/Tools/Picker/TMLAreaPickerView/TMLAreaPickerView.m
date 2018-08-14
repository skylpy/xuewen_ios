//
//  TMLAreaPickerViewController.m
//  TMLBanner(OC)
//
//  Created by charles on 2017/6/12.
//  Copyright © 2017年 Charles. All rights reserved.
//

#import "TMLAreaPickerView.h"
#import "AreaModel.h"
 
#define RGB(r, g, b) RGBA(r,g,b,1)

typedef void(^doneBlock)(AreaPickerModel *);

@interface TMLAreaPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>


@property (nonatomic, strong) UIPickerView    * pickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


@property (weak, nonatomic) IBOutlet UIView *showProvinceView;

@property (nonatomic,strong)doneBlock doneBlock;


@property (nonatomic, strong) NSArray<ProvinceModel *> *provinceArray;
@property (nonatomic, strong) ProvinceModel            *selectProvince;
@property (nonatomic, strong) CityModel                *selectCity;
@property (nonatomic, strong) AreaModel                *selectArea;
@end

@implementation TMLAreaPickerView
#pragma mark - UIPickerViewDataSource
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:{
            self.selectProvince = self.provinceArray[row];
            self.selectCity = self.selectProvince.cities[0];
            self.selectArea = self.selectCity.districts[0];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
        }break;
        case 1:{
            self.selectCity = self.selectProvince.cities[row];
            self.selectArea = self.selectCity.districts[0];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
        }break;
        case 2:{
            self.selectArea = self.selectCity.districts[row];
        }break;
        default:
            break;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger count = 0;
    switch (component) {
        case 0:{
            count = self.provinceArray.count;
        }break;
        case 1:{
            count = self.selectProvince.cities.count;
        }break;
        case 2:{
            count = self.selectCity.districts.count;
        }
        default:
            break;
    }
    return count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        [tView setTextAlignment:NSTextAlignmentCenter];
        tView.numberOfLines=3;
    }
    switch (component) {
        case 0:{
            tView.text = self.provinceArray[row].provinceName;
        }break;
        case 1:{
            tView.text = self.selectProvince.cities[row].cityName;
        }break;
        case 2:{
            tView.text = self.selectCity.districts[row].areaName;
        }break;
        default:
            break;
    }
    return tView;
}

#pragma mark - getter / setter
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        [self.showProvinceView layoutIfNeeded];
        _pickerView = [[UIPickerView alloc] initWithFrame:self.showProvinceView.bounds];
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

// 初始化方法
- (instancetype)initAreaPickerWithDataSource:(NSArray *)dataSource{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        self.provinceArray = dataSource;
        [self setupUI];
        [self setDefaultSelect];
    }
    return self;
}

// 初始化方法
- (instancetype) initAreaPickerWithCompleteBlock:(void(^)(AreaPickerModel *))completeBlock {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        
        
        [self setupUI];

        if (completeBlock) {
            
            self.doneBlock = ^(AreaPickerModel * Area) {
                completeBlock(Area);
            };
        }
    }
    return self;

    
}

- (void)setupUI {
    
    self.frame=CGRectMake(0, 0, kWidth, kHeight);
    
    //点击背景是否影藏
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    self.bottomConstraint.constant = -self.height;
    self.backgroundColor = ColorA(0, 0, 0, 0);
    [self layoutIfNeeded];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    [self.showProvinceView addSubview:self.pickerView];
    
}

- (void)setDefaultSelect{
    if (self.provinceArray.count > 0) {
        XWUserInfo *userInfo = kUserInfo;
        for (int i = 0; i < self.provinceArray.count; i++) {
            ProvinceModel *province = self.provinceArray[i];
            if ([userInfo.province isEqualToString:province.provinceID]) {
                self.selectProvince = province;
                for (int j = 0; j < province.cities.count; j++) {
                    CityModel *city = province.cities[j];
                    if ([userInfo.area isEqualToString:city.cityID]) {
                        self.selectCity = city;
                        for (int k = 0; k < city.districts.count; k++) {
                            AreaModel *area = city.districts[k];
                            if ([userInfo.county isEqualToString:area.areaID]) {
                                self.selectArea = area;
                                [self.pickerView reloadAllComponents];
                                [self.pickerView selectRow:i inComponent:0 animated:YES];
                                [self.pickerView selectRow:j inComponent:1 animated:YES];
                                [self.pickerView selectRow:k inComponent:2 animated:YES];
                                return;
                            }
                        }
                    }
                }
            }
        }
        self.selectProvince = self.provinceArray[0];
        self.selectCity = self.selectProvince.cities[0];
        self.selectArea = self.selectCity.districts[0];
    }
}

#pragma mark - Action
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        self.bottomConstraint.constant = 0;
        self.backgroundColor = ColorA(0, 0, 0, 0.4);
        [self layoutIfNeeded];
    }];
//    [self.pickerView selectRow:1 inComponent:1 animated:YES];
}


- (void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        self.bottomConstraint.constant = -self.height;
        self.backgroundColor = ColorA(0, 0, 0, 0);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}



- (IBAction)cancelBtnClick:(id)sender {
    [self dismiss];
}

- (IBAction)doneAction:(UIButton *)btn {
    NSString *address = [NSString stringWithFormat:@"%@%@%@",self.selectProvince.provinceName,self.selectCity.cityName,self.selectArea.areaName];
    if (self.CompleteBlock) {
        self.CompleteBlock(@{@"province":self.selectProvince.provinceID,@"area":self.selectCity.cityID,@"county":self.selectArea.areaID,@"region_name":address});
    }else{
        if (![address isEqualToString:kUserInfo.region_name]) {
            [XWNetworking setPersonalInfoWithParam:@{@"province":self.selectProvince.provinceID,@"area":self.selectCity.cityID,@"county":self.selectArea.areaID,@"region_name":address} completionBlock:nil];
        }
    }
    [self dismiss];
}
@end


@implementation AreaPickerModel

@end
