//
//  XWTestEduDateilViewController.m
//  XueWen
//
//  Created by aaron on 2018/10/18.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWTestEduDateilViewController.h"
#import "ClassTestViewController.h"

@interface XWTestEduDateilViewController ()

@property (nonatomic,strong) UIImageView * picImage;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * desLabel;
@property (nonatomic,strong) UIButton * sureButton;

@end

@implementation XWTestEduDateilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.model.title;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.picImage];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.desLabel];
    [self.view addSubview:self.sureButton];
    
    [self.picImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self.view);
        make.height.offset(150);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.picImage.mas_bottom).offset(10);
        make.height.offset(18);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.offset(15);
        make.right.offset(-15);
        
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.offset(49);
    }];
    
    @weakify(self)
    [[self.sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [XWNetworking getQuestionsListWithTestID:self.model.mid CompletionBlock:^(NSArray<QuestionsModel *> *questions) {
            ClassTestViewController * vc = [[ClassTestViewController alloc] initWithQuestions:questions withTest:YES withAtid:self.model.a_t_id];
            vc.eduType = YES;
            vc.testId = self.model.mid;
            vc.model = self.model;
            [[UIViewController getCurrentVC].navigationController pushViewController:vc animated:YES];
        }];
        
    }];
}

- (void)setModel:(XWTestEduModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.desLabel.text = [NSString filterHTML:model.desc];
    [self.picImage setImageWithURL:[NSURL URLWithString:model.picture] placeholder:DefaultImage];
}

- (UIButton *)sureButton {
    
    if (!_sureButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton = button;
        button.backgroundColor = Color(@"#317FFF");
        button.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        [button setTitle:@"立即开始" forState:UIControlStateNormal];
        [button setTitleColor:Color(@"#FEFEFE") forState:UIControlStateNormal];
    }
    return _sureButton;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel createALabelText:@"测试岗位介绍" withFont:  [UIFont fontWithName:kRegFont size:13] withColor:Color(@"#333333")];
    }
    return _titleLabel;
}

- (UILabel *)desLabel {
    
    if (!_desLabel) {
        _desLabel = [UILabel createALabelText:@"我也不知道试题描述有多少字，反正就按200个字来。我也不知道试题描述有多少字，反正就按200个字来。我也不知道试题描述有多少字，反正就按200个字来。我也不知道试题描述有多少字，反正就按200个字来。我也不知道试题描述有多少字，反正就按200个字来。" withFont:  [UIFont fontWithName:kRegFont size:13] withColor:Color(@"#333333")];
        _desLabel.numberOfLines = 0;
    }
    return _desLabel;
}

- (UIImageView *)picImage {
    
    if (!_picImage) {
        UIImageView * imageView = [UIImageView new];
        _picImage = imageView;
        imageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _picImage;
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
