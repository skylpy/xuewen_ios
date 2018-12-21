//
//  XWHomeCollectCell.m
//  XueWen
//
//  Created by Karron Su on 2018/10/17.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHomeCollectCell.h"
#import "XWCollegeBaseViewController.h"
#import <UIButton+WebCache.h>
#import "XWCourseLabelModel.h"

@interface XWHomeCollectCell ()

@property (nonatomic, strong) UIButton *firstBtn;
@property (nonatomic, strong) UIButton *secondBtn;
@property (nonatomic, strong) UIButton *thirdBtn;
@property (nonatomic, strong) UIButton *fourBtn;

@end

@implementation XWHomeCollectCell

#pragma mark - Getter
- (UIButton *)firstBtn{
    if (!_firstBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn rounded:3];
        btn.tag = 1001;
        [btn addTarget:self action:@selector(CollectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _firstBtn = btn;
    }
    return _firstBtn;
}

- (UIButton *)secondBtn{
    if (!_secondBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn rounded:3];
        btn.tag = 1002;
        [btn addTarget:self action:@selector(CollectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _secondBtn = btn;
    }
    return _secondBtn;
}

- (UIButton *)thirdBtn{
    if (!_thirdBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn rounded:3];
        btn.tag = 1003;
        [btn addTarget:self action:@selector(CollectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _thirdBtn = btn;
    }
    return _thirdBtn;
}

- (UIButton *)fourBtn{
    if (!_fourBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn rounded:3];
        btn.tag = 1004;
        [btn addTarget:self action:@selector(CollectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _fourBtn = btn;
    }
    return _fourBtn;
}

#pragma mark - InitUi
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    [self.contentView addSubview:self.firstBtn];
    [self.contentView addSubview:self.secondBtn];
    [self.contentView addSubview:self.thirdBtn];
    [self.contentView addSubview:self.fourBtn];
    
    [self.firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(15);
        make.left.mas_equalTo(self.contentView).offset(25);
        make.size.mas_equalTo(CGSizeMake((kWidth-75)/2, (kWidth-75)/2*0.62));
    }];
    
    [self.secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-25);
        make.size.mas_equalTo(CGSizeMake((kWidth-75)/2, (kWidth-75)/2*0.62));
    }];
    
    [self.thirdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstBtn.mas_bottom).offset(25);
        make.left.mas_equalTo(self.contentView).offset(25);
        make.size.mas_equalTo(CGSizeMake((kWidth-75)/2, (kWidth-75)/2*0.62));
    }];
    
    [self.fourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.secondBtn.mas_bottom).offset(25);
        make.right.mas_equalTo(self.contentView).offset(-25);
        make.size.mas_equalTo(CGSizeMake((kWidth-75)/2, (kWidth-75)/2*0.62));
    }];
    
    
}

#pragma mark - Setter
- (void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = dataSource;
    XWCourseLabelModel *model1 = _dataSource[0];
    [self.firstBtn sd_setImageWithURL:[NSURL URLWithString:model1.cover] forState:UIControlStateNormal];
    XWCourseLabelModel *model2 = _dataSource[1];
    [self.secondBtn sd_setImageWithURL:[NSURL URLWithString:model2.cover] forState:UIControlStateNormal];
    XWCourseLabelModel *model3 = _dataSource[2];
    [self.thirdBtn sd_setImageWithURL:[NSURL URLWithString:model3.cover] forState:UIControlStateNormal];
    XWCourseLabelModel *model4 = _dataSource[3];
    [self.fourBtn sd_setImageWithURL:[NSURL URLWithString:model4.cover] forState:UIControlStateNormal];
}

#pragma mark - Action
- (void)CollectBtnClick:(UIButton *)btn{
    NSInteger index = btn.tag - 1001;
    XWCourseLabelModel *model = _dataSource[index];
    XWCollegeBaseViewController *vc = [[XWCollegeBaseViewController alloc] init];
    vc.labelID = model.labelId;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
