//
//  NetworkViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/12/6.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "NetworkViewController.h"
#import "AppDelegate.h"

@interface NetworkViewController ()

@property (nonatomic, assign) BOOL noNetwork;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation NetworkViewController

- (instancetype)initWithNoNetwork:(BOOL)noNetwork{
    if (self = [super init]) {
        self.noNetwork = noNetwork;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.titleLabel];
    NSString *imageName = nil;
    NSString *title = nil;
    if (self.noNetwork) {
        imageName = @"icoNoInternet";
        title = @"无法连接网络\n请检查网络设置后重试";
    }else{
        imageName = @"icoServerConnectionFailed";
        title = @"服务器接收失败\n请点击尝试重新连接";
    }
    self.imageView.image = LoadImage(imageName);
    self.titleLabel.text = title;
    
    [self.view addTapTarget:self action:@selector(reloadNetwork)];
}

- (void)reloadNetwork{
    if (!self.noNetwork) {
        [[AppDelegate sharedInstanced] setSomeThing];
    }
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth - 122) / 2.0f, 165, 122, 129)];
        _imageView.userInteractionEnabled = YES;
        [_imageView addTapTarget:self action:@selector(reloadNetwork)];
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 304, kWidth, 40)];
        _titleLabel.font = kFontSize(15);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = DefaultTitleCColor;
        _titleLabel.numberOfLines = 0;
        _titleLabel.userInteractionEnabled = YES;
        [_titleLabel addTapTarget:self action:@selector(reloadNetwork)];
    }
    return _titleLabel;
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
