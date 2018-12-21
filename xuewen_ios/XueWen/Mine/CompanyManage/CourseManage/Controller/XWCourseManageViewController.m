//
//  XWCourseManageViewController.m
//  XueWen
//
//  Created by aaron on 2018/12/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCourseManageViewController.h"

@interface XWCourseManageViewController ()
//宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseManageLayoutW;
//购买btn
@property (weak, nonatomic) IBOutlet UIButton *purchaseBtn;
//收藏btn
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
//头部View
@property (weak, nonatomic) IBOutlet UIView *topView;
//滚动
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation XWCourseManageViewController

/**
 *注释
 *动态修改
 */
- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    self.courseManageLayoutW.constant = kWidth*2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"课程管理";
    [self setNav];
    [self drawUI];
  
}

- (void)drawUI {
    
    [self.purchaseBtn setTitleColor:Color(@"#999999") forState:UIControlStateNormal];
    [self.purchaseBtn setTitleColor:Color(@"#2E6AE1") forState:UIControlStateSelected];
    self.purchaseBtn.titleLabel.font = [UIFont fontWithName:kMedFont size:14];
    [self.collectionBtn setTitleColor:Color(@"#999999") forState:UIControlStateNormal];
    [self.collectionBtn setTitleColor:Color(@"#2E6AE1") forState:UIControlStateSelected];
    self.collectionBtn.titleLabel.font = [UIFont fontWithName:kMedFont size:14];
    self.purchaseBtn.selected = YES;
    
    @weakify(self)
    [[self.purchaseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self actionClick:x];
    }];
    
    [[self.collectionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self actionClick:x];
    }];
}

/**
 *注释
 *点击滚动
 */
- (void)actionClick:(UIButton *)button {
    
    for (int i = 1000; i < 1002; i ++) {
        UIButton * btn = [self.topView viewWithTag:i];
        btn.selected = NO;
    }
    button.selected = YES;
    if (button.tag == 1000) {
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }else {
        [self.scrollView setContentOffset:CGPointMake(kWidth, 0)];
    }
}

- (void)setNav {
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 45, 30);
    [rightBtn setTitle:@"课程库" forState:UIControlStateNormal];
    [rightBtn setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    @weakify(self)
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"XWCourseManage" bundle:nil] instantiateViewControllerWithIdentifier:@"XWCourseLibrary"] animated:YES];
    }];
}



@end
