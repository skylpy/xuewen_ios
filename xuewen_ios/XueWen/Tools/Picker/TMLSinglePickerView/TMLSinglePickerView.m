//
//  TMLPickerView.m
//  happyselling
//
//  Created by charles on 2017/6/20.
//  Copyright © 2017年 iOS李鹏. All rights reserved.
//

#import "TMLSinglePickerView.h"

typedef void(^doneBlock)(TMLPickerModel *);
typedef void(^doneIndexBlock)(NSInteger);

@interface TMLSinglePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPickerView * pickerView;

@property (nonatomic, strong) doneBlock doneBlock;
@property (nonatomic, strong) doneIndexBlock doneIndexBlock;

@property (weak, nonatomic) IBOutlet UIView *pickerContainer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


// 项目项目器 data
@property (strong, nonatomic) NSMutableArray * projectData ;
@end


@implementation TMLSinglePickerView

#pragma mark - getter / setter
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        [self.pickerContainer layoutIfNeeded];
        _pickerView = [[UIPickerView alloc] initWithFrame:self.pickerContainer.bounds];
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}


// 初始化方法
- (instancetype) initPickerArray:(NSMutableArray *)arr WithCompleteBlock:(void(^)(TMLPickerModel * model))completeBlock {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        
        self.projectData = arr;
        
        [self setupUI];
        //        [self defaultConfig];
        
        if (completeBlock) {
            self.doneBlock = ^(TMLPickerModel * pickerStr) {
                completeBlock(pickerStr);
            };
        }
    }
    return self;
}
// 新的方法，带有默认选项的 2018.01.30
- (instancetype)initPickerArray:(NSMutableArray *)arr defaultPick:(NSString *)sex WithCompleteBlock:(void(^)(TMLPickerModel * model))completeBlock{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        self.projectData = arr;
        [self setupUIWithDefaultPick:sex];
        if (completeBlock) {
            self.doneBlock = ^(TMLPickerModel * pickerStr) {
                completeBlock(pickerStr);
            };
        }
    }
    return self;
}

// 初始化方法
- (instancetype)initPickerArray:(NSMutableArray *)arr WithCompleteIndexBlock:(void(^)(NSInteger row))completeBlock {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        
        self.projectData = arr;
        
        [self setupUI];
        
        if (completeBlock) {
            self.doneIndexBlock = ^(NSInteger row) {
                completeBlock(row);
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
    
    [self.pickerContainer addSubview:self.pickerView];

//    [self.pickerView selectedRowInComponent:0];
}

- (void)setupUIWithDefaultPick:(NSString *)sex {
    self.frame=CGRectMake(0, 0, kWidth, kHeight);

    //点击背景是否影藏
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];

    self.bottomConstraint.constant = -self.height;
    self.backgroundColor = ColorA(0, 0, 0, 0);
    [self layoutIfNeeded];

    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];

    [self.pickerContainer addSubview:self.pickerView];

    if ([self.projectData containsObject:sex]) {
        [self.pickerView selectRow:[self.projectData indexOfObject:sex] inComponent:0 animated:NO];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.projectData.count;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:kRegFont size:16]];
        [tView setTextAlignment:NSTextAlignmentCenter];
        tView.numberOfLines=3;
    }
    
    tView.text = _projectData[row];
    return tView;
    
}
#pragma mark - Action
- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        self.bottomConstraint.constant = 0;
        self.backgroundColor = ColorA(0, 0, 0, 0.4);
        [self layoutIfNeeded];
    }];
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



- (TMLPickerModel *)callBackAreaPickerModel {
    
    TMLPickerModel *model = [TMLPickerModel new];
    
    NSInteger index = [self.pickerView selectedRowInComponent:0];
    if (_projectData.count) {
        NSString * str = _projectData[index];
        model.pickerStr = str;
    } else {
        model.pickerStr = @"";
    }
    
    return model;
}


// 点击取消按钮
- (IBAction)cancelBtnClick:(id)sender {
    [self dismiss];
}

// 点击确定按钮
- (IBAction)doneBtnClick:(UIButton *)sender {
    if (self.doneIndexBlock) {
        self.doneIndexBlock([self.pickerView selectedRowInComponent:0]);
    }
    if (self.doneBlock) {
        self.doneBlock([self callBackAreaPickerModel]);
    }
    [self dismiss];
}


@end



