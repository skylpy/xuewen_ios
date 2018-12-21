//
//  XWMedalCerViewController.m
//  XueWen
//
//  Created by aaron on 2018/8/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWMedalCerViewController.h"
#import "XWCerViewController.h"
#import "XWMedalViewController.h"
#import "XWNoneTestView.h"
#import "XWNoneCerView.h"
#import "ClassTestViewController.h"

@interface XWMedalCerViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraintWidth;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (strong,nonatomic) XWMedalViewController * medVc;
@property (strong,nonatomic) XWCerViewController * cerVc;

@end

@implementation XWMedalCerViewController

- (void)updateViewConstraints {
    
    [super updateViewConstraints];
    
    self.LayoutConstraintWidth.constant = kWidth*2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.medVc = self.childViewControllers[0];
    self.cerVc = self.childViewControllers[1];
    self.medVc.desLabel.text = [NSString stringWithFormat:@"通过了%@上岗认证考试， 是一名%@！",self.model.job,self.model.job];
    [self.medVc.iconURLImage sd_setImageWithURL:[NSURL URLWithString:self.model.show_picture_all] placeholderImage:DefaultImage];
    self.medVc.causeLabel.text = self.model.job;
    self.medVc.model = self.model;
    
    
    self.cerVc.lmodel = self.model;
    
    if ([self.model.pass_type isEqualToString:@"0"] || [self.model.pass_type isEqualToString:@"1"]) {
        self.rightBtn.hidden = YES;
    }else{
        self.rightBtn.hidden = NO;
    }
    
    [self requestData];
    
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - kNaviBarH;;
}

- (void)requestData {
    
    [XWCertificateModel createcertificatetestId:self.testId withName:@""  success:^(XWCertificateModel *cmodel) {
        
        self.cerVc.causeLabel.text = [NSString stringWithFormat:@"在学问APP%@岗位胜任力认证考试中，",cmodel.achievement_name];
        self.cerVc.cerNumberLabel.text = [NSString stringWithFormat:@"证书编号:%@",cmodel.certificate_number];
        self.cerVc.timeLabel.text = [NSString stringWithFormat:@"日期:%@",cmodel.create_time];
        self.cerVc.causeLabel.text = [NSString stringWithFormat:@"在学问APP%@岗位胜任力认证考试中，",cmodel.achievement_name];
        self.cerVc.occupationLabel.text = [NSString stringWithFormat:@" 成绩优秀，被评为%@。",cmodel.jobs];
        
    } failure:^(NSString *error) {
        
    }];
}


- (IBAction)didSection:(UIButton *)sender {
    
    if (sender.tag == 1000) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else {
        if ([self.model.pass_type isEqualToString:@"0"]) {
            [[XWNoneCerView shareNoneCerView] showFromView:[UIApplication sharedApplication].keyWindow];
            return;
        }else if([self.model.pass_type isEqualToString:@"1"]){
            @weakify(self)
            [[XWNoneTestView shareNoneTestView] showFromView:[UIApplication sharedApplication].keyWindow withTestClick:^{
                @strongify(self)
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [XWNetworking getQuestionsListWithTestID:self.model.test_id CompletionBlock:^(NSArray<QuestionsModel *> *questions) {
                    [MBProgressHUD hideHUD];
                    if (questions.count > 0) {
                        [self.navigationController pushViewController:[[ClassTestViewController alloc] initWithQuestions:questions withTest:YES withAtid:self.model.id] animated:YES];
                    }
                }];
            }];
            return;
        }
        [self.scrollView setContentOffset:CGPointMake(kWidth, 0) animated:YES];
    }
    for (int i = 1000; i < 1002; i ++) {
        
        UIButton * button = [self.buttonView viewWithTag:i];
        button.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [button setTitleColor:Color(@"#666666") forState:UIControlStateNormal];
    }
    sender.titleLabel.font = [UIFont fontWithName:kRegFont size:18];
    [sender setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
    
}

- (IBAction)shareAction:(UIButton *)sender {
    
    if (self.scrollView.contentOffset.x == kWidth) { // 在证书页面
        NSLog(@"在证书页面");
        [self.cerVc shareBtnClick];
    }else{
        NSLog(@"在勋章页面");
        [self.medVc shareBtnClick];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
