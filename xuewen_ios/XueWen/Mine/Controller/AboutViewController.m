//
//  AboutViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/12/7.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (nonatomic, strong) UILabel *introductLabel;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation AboutViewController
#pragma mark- CustomMethod
- (void)initUI{
    self.title = @"关于学问";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.introductLabel];
    [self.view addSubview:self.infoLabel];
}

- (void)loadData{
    
}
#pragma mark- Setter
#pragma mark- Getter
- (UILabel *)introductLabel{
    if (!_introductLabel) {
        NSString *text = @"\t      学问网是集电脑、移动手机APP于一身，以低成本、高成效的方式，采用企业自身文化+企业定制式课程+岗位专业培训+个人素质提升，全方位为企业职员进行职业培训的网络培训平台。\n       学问网的宗旨是帮助中小企业轻松有效建立培训体系、让任职人员快速有效提升胜任力。\n       学问网致力于成为中小企业首选的培训供应商、帮助100万以上中小企业建立培训系统、5000万在职人员持续提升职业化素养与工作能力，成为中国规模与影响力排名第一的企业在线培训学院。";
        CGFloat height = [text heightWithWidth:kWidth - 30 size:17];
        _introductLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, kWidth - 30, height)];
        _introductLabel.textColor = DefaultTitleBColor;
        _introductLabel.text = text;
        _introductLabel.numberOfLines = 0;
    }
    return _introductLabel;
}

- (UILabel *)infoLabel{
    if (!_infoLabel) {
        NSString *text = [NSString stringWithFormat:@"Copyright © 2017-2018广州学问信息科技有限公司\n粤ICP备18090951号-1\nv%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        CGFloat height = [text heightWithWidth:kWidth size:15];
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kHeight - height - (IsIPhoneX ? 110 : 80), kWidth, height)];
        _infoLabel.textColor =  DefaultTitleBColor;
        _infoLabel.font = kFontSize(15);
        _infoLabel.textAlignment = 1;
        _infoLabel.numberOfLines = 0;
        _infoLabel.text = text;
    }
    return _infoLabel;
}

#pragma mark- LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
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
