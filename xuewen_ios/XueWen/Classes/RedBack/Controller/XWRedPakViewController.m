//
//  XWRedPakViewController.m
//  XueWen
//
//  Created by aaron on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWRedPakViewController.h"
#import "XWRedBackUserListView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "XWRedRandViewController.h"
#import "XWRedBackView.h"
#import "XWNoneRedPakeView.h"
#import "XWWaitRedPakeView.h"
#import "XWRedPakModel.h"
#import "XWExamResultShareView.h"
#import "InvitationViewModel.h"
#import "ClassesViewController.h"
#import "XWIncomeViewController.h"
#import "WXApi.h"

@interface XWRedPakViewController ()<XWExamResultShareViewDelegate>

@property (nonatomic,strong) UIScrollView * scrollView;

@property (nonatomic,strong) UIView * contentView;

//上部
@property (nonatomic,strong) UIView * contentTopView;
//下部
@property (nonatomic,strong) UIView * contentBottomView;

@property (nonatomic,strong) XWRedBackUserListView * userListView;

@property (nonatomic,strong) UIImageView * phoneImage;
@property (nonatomic,strong) UILabel * redNumber;

@property (nonatomic, strong) XWExamResultShareView *shareView;
@property (nonatomic, strong) InvitationViewModel *viewModel;

@property (nonatomic, strong) XWRedPakModel *redModel;

@property (nonatomic, assign) NSInteger opportunity;

//展示
@property (nonatomic, assign) BOOL isShow;

@end

@implementation XWRedPakViewController

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = Color(@"#E74143");
    }
    return _scrollView;
}

- (UIView *)contentView {
    
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = Color(@"#E74143");
    }
    return _contentView;
}

- (UIView *)userListView {
    
    if (!_userListView) {
        _userListView = [[XWRedBackUserListView alloc] init];
        _userListView.backgroundColor = [UIColor clearColor];
    }
    return _userListView;
}

- (UIView *)contentTopView {
    
    if (!_contentTopView) {
        _contentTopView = [[UIView alloc] init];
        _contentTopView.backgroundColor = [UIColor clearColor];
        
        UIImageView * bg_imageView = [[UIImageView alloc] init];
        bg_imageView.image = [UIImage imageNamed:@"backgrond"];
        [_contentTopView addSubview:bg_imageView];
        [bg_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentTopView.mas_top);
            make.centerX.equalTo(_contentTopView);
            make.height.offset(358);
            make.left.equalTo(_contentTopView.mas_left).offset(31);
            make.right.equalTo(_contentTopView.mas_right).offset(-31);
        }];
        
        UIImageView * circular = [[UIImageView alloc] init];
        circular.image = [UIImage imageNamed:@"circular"];
        [_contentTopView addSubview:circular];
        [circular mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentTopView.mas_top).offset(160);
            make.centerX.equalTo(_contentTopView);
            make.width.height.offset(212);
        }];
        
        UIImageView * phoneImage = [[UIImageView alloc] init];
        phoneImage.image = [UIImage imageNamed:@"hand"];
        _phoneImage = phoneImage;
        [_contentTopView addSubview:phoneImage];
        [phoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentTopView.mas_top).offset(182);
            make.centerX.equalTo(_contentTopView);
            make.width.offset(120);
            make.height.offset(174);
        }];
        
        UILabel * redNumber = [[UILabel alloc] init];
        redNumber.textColor = Color(@"#FEFEFE");
        redNumber.font = [UIFont fontWithName:kRegFont size:15];
        redNumber.attributedText = [NSMutableAttributedString setupAttributeString:@"摇红包剩余3次" rangeText:@"3" textFont:[UIFont fontWithName:kRegFont size:20] textColor:Color(@"#FCF142")];
        _redNumber = redNumber;
        redNumber.textAlignment = UITextAlignmentCenter;
        [_contentTopView addSubview:redNumber];
        [redNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(20);
            make.top.equalTo(bg_imageView.mas_bottom).offset(38);
            make.centerX.equalTo(_contentTopView);
        }];
    }
    return _contentTopView;
}

- (UIView *)contentBottomView {
    
    if (!_contentBottomView) {
        _contentBottomView = [[UIView alloc] init];
        _contentBottomView.backgroundColor = [UIColor clearColor];
        
        UIButton *shakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shakeButton setImage:[UIImage imageNamed:@"ShakeButton"] forState:UIControlStateNormal];
        [shakeButton setTintColor:Color(@"#FEFEFE")];
        [_contentBottomView addSubview:shakeButton];
        [shakeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_contentBottomView);
            make.top.equalTo(_contentBottomView);
            make.height.mas_equalTo(39);
            make.width.mas_equalTo(174);
        }];
        @weakify(self)
        [[shakeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
        }];
        
        UIImageView * phoneImage = [[UIImageView alloc] init];
        phoneImage.image = [UIImage imageNamed:@"rules_of_activity"];
        [_contentBottomView addSubview:phoneImage];
        [phoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(shakeButton.mas_bottom).offset(42);
            make.centerX.equalTo(_contentBottomView);
            make.width.offset(81);
            make.height.offset(17);
        }];
        
        [_contentBottomView addSubview:self.userListView];
        [self.userListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(phoneImage.mas_bottom).offset(17);
            make.left.right.bottom.equalTo(_contentBottomView);
        }];
    }
    return _contentBottomView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:Color(@"#E74143")];
    
    //创建一个UIButton
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //设置UIButton的图像
    [backButton setImage:[UIImage imageNamed:@"icoBackWhite"] forState:UIControlStateNormal];
    //然后通过系统给的自定义BarButtonItem的方法创建BarButtonItem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    //覆盖返回按键
    self.navigationItem.leftBarButtonItem = backItem;
    @weakify(self)
    [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"红包摇一摇";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:kMedFont size:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.titleLabel.font = [UIFont fontWithName:kRegFont size:13];
    [rightItemButton setTitle:@"红包排行" forState:UIControlStateNormal];
    [rightItemButton setTitleColor:Color(@"#FEFEFE") forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightItemButton];
    
    [[rightItemButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        XWRedRandViewController * vc = [XWRedRandViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:Color(@"#ffffff")];
    [self resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
//    [self setNav];
    [self requestData:YES];
    self.isShow = NO;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
}

- (void)requestData:(BOOL)isNum {
    
    [XWRedPakModel createRedBackIsNum:isNum Success:^(XWRedPakModel *cmodel) {
        
        if (!isNum) {
            //摇一摇返回的数据处理
            [self redBackState:cmodel];
            
        }else {
            //进入页面第一次请求的状态
            self.opportunity = [cmodel.opportunity integerValue];
            _redNumber.attributedText = [NSMutableAttributedString setupAttributeString:[NSString stringWithFormat:@"摇红包剩余%@次",cmodel.opportunity] rangeText:[NSString stringWithFormat:@"%@",cmodel.opportunity] textFont:[UIFont fontWithName:kRegFont size:20] textColor:Color(@"#FCF142")];
        }
    } failure:nil];
}

- (void)redBackState:(XWRedPakModel *)model{
    
    if ([model.state isEqualToString:@"0"]) {
        //成功时的红包状态
        self.opportunity = [model.opportunity integerValue];
        
        _redNumber.attributedText = [NSMutableAttributedString setupAttributeString:[NSString stringWithFormat:@"摇红包剩余%@次",model.opportunity] rangeText:[NSString stringWithFormat:@"%@",model.opportunity] textFont:[UIFont fontWithName:kRegFont size:20] textColor:Color(@"#FCF142")];
        self.isShow = YES;
        [[XWRedBackView shareRedBackView] showFromView:[UIApplication sharedApplication].keyWindow withMoney:model.price withTestClick:^(RedBackType type) {
            self.isShow = NO;
            if (type == AppearType){
                XWIncomeViewController * vc = [[XWIncomeViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        
        }];
    }else if([model.state isEqualToString:@"1"] || [model.state isEqualToString:@"2"])  {
        //没有红包是的状态
        self.opportunity = [model.opportunity integerValue];
        self.isShow = YES;
        [[XWNoneRedPakeView shareNoneRedPakeView] showFromView:[UIApplication sharedApplication].keyWindow withState:model.state withGoSeeClick:^(NoneRedType type,RedBackType rtype) {
            
            self.isShow = NO;
            switch (type) {
                case InvitationType:
                {
                    self.redModel = model;
                    XWExamResultShareView *shareView = [[XWExamResultShareView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
                    shareView.delegate = self;
                    [kMainWindow addSubview:shareView];
                }
                    break;
                case goodType:
                {
                    ClassesViewController *vc = [[ClassesViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case refushType:
                    
                    break;
                default:
                    
                    break;
            }
        }];
    }else {
        //等待时的状态
        [[XWWaitRedPakeView shareWaitRedPakeView] showFromView:[UIApplication sharedApplication].keyWindow];
    }
}

#pragma mark - XWExamResultShareViewDelegate

- (void)didSelectShareItemAtIndex:(NSInteger)index{
    
    WXWebpageObject *pageObj = [WXWebpageObject object];
    pageObj.webpageUrl = self.redModel.url;
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.mediaObject = pageObj;
    message.title = @"注册即送百元奖学金";
    message.description = @"高效工作，快乐生活，尽在“学问”APP";
    message.thumbData = UIImagePNGRepresentation(LoadImage(@"AppIcon"));
    
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    req.scene = index == 0 ? 0 : 1;
    req.message = message;
    req.bText = NO;
    [WXApi sendReq:req];
    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - ShakeToEdit 摇动手机之后的回调方法
- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    //检测到摇动开始
    if (motion == UIEventSubtypeMotionShake) {

        NSLog(@"检测到摇动开始");
    }
    
}

- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    //摇动取消 NSLog(@"摇动取消");
    
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    //摇动结束
    if (self.isShow) return;
    if (event.subtype == UIEventSubtypeMotionShake) {
        
        NSArray * arr = @[@"hand",@"hand1",@"hand",@"hand2",@"hand",@"hand1",@"hand",@"hand2"];
        NSMutableArray *imgArray = [NSMutableArray array];
        for (int i=1; i<arr.count; i++) {
            UIImage *image = [UIImage imageNamed:arr[i]];
            [imgArray addObject:image];
        }
        //把存有UIImage的数组赋给动画图片数
        _phoneImage.animationImages = imgArray;
        //设置执行一次完整动画的时长
        _phoneImage.animationDuration = arr.count*0.15;
        //动画重复次数 （0为重复播放）
        _phoneImage.animationRepeatCount = 0;
        //开始播放动画
        [_phoneImage startAnimating];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            _phoneImage.image = [UIImage imageNamed:@"hand"];
            [_phoneImage stopAnimating];
            
            [self playSoundEffect:@"shakeyao"];
            
            if (self.opportunity == 0) {
                
                [self noneRedPake];
            }else {
                [self requestData:NO];
            }
            
        });
        
        NSLog(@"摇动结束");
    }
}

//没有红包的状态
- (void)noneRedPake {
    
    self.isShow = YES;
    [[XWNoneRedPakeView shareNoneRedPakeView] showFromView:[UIApplication sharedApplication].keyWindow withState:@"1" withGoSeeClick:^(NoneRedType type,RedBackType rtype) {
        
        self.isShow = NO;
        
        if (type == InvitationType) {
            XWExamResultShareView *shareView = [[XWExamResultShareView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
            shareView.delegate = self;
            [kMainWindow addSubview:shareView];
        }
        
    }];
}

-(void)playSoundEffect:(NSString *)name{

    SystemSoundID soundID;
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:@"m4r"];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    NSLog(@"%u",(unsigned int)soundID);

    AudioServicesPlaySystemSound(soundID);

    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}

- (void)setNav {
    
    UIButton *leftItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftItemButton setImage:[UIImage imageNamed:@"icoBackWhite"] forState:UIControlStateNormal];
    [leftItemButton setTintColor:Color(@"#FEFEFE")];
    [self.view addSubview:leftItemButton];
    [leftItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25);
        make.top.equalTo(self.view).offset(33);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(13);
    }];
    
    @weakify(self)
    [[leftItemButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.titleLabel.font = [UIFont fontWithName:kRegFont size:13];
    [rightItemButton setTitle:@"红包排行" forState:UIControlStateNormal];
    [rightItemButton setTitleColor:Color(@"#FEFEFE") forState:UIControlStateNormal];
    [self.view addSubview:rightItemButton];
    [rightItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-25);
        make.top.equalTo(self.view).offset(33);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(60);
    }];
    
    [[rightItemButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        XWRedRandViewController * vc = [XWRedRandViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"红包摇一摇";
    titleLabel.textColor = Color(@"#FEFEFE");
    titleLabel.font = [UIFont fontWithName:kRegFont size:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.centerY.equalTo(rightItemButton);
        make.centerX.equalTo(self.view);
    }];
    
}

#pragma mark - 设置内容
- (void)setupUI {
    
    // 底部滚动
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 底部view， 用于计算scrollview高度
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    /************************ 内容 ******************************/
    
    
    [self.scrollView addSubview:self.contentTopView];
    [self.contentTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.scrollView);
        make.height.offset(450);
        make.top.equalTo(self.scrollView).offset(6);
        make.left.equalTo(self.scrollView);
    }];
    
    NSArray * array = @[@"1.任何用户都有3次摇红包机会，用户以余额购买课 程后，即可再获得一次摇红包机会； ",
                        @"2.用户邀请好友参与活动，好友获得多少金额的红包， 用户也可获得同等金额的红包；",
                        @"3.红包满10元即可提现，提现申请需在App内提交， 提现需绑定支付宝；",
                        @"4.每位用户只能绑定一个支付宝，同一个支付宝不能 同时绑定多个用户；",
                        @"5.每天提现次数最多3次，每月最多10次，到账时间 T+3；",
                        @"6.本次活动最终解释权归广州学问信息科技有限公司 所有。",
                        ];
    CGFloat height = 0;
    for (NSString * title in array) {
       
        height = [title heightWithWidth:kWidth-92 size:14] + height;
    }
    height = height + 120;
    [self.scrollView addSubview:self.contentBottomView];
    [self.contentBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.scrollView);
        make.height.offset(height);
        make.top.equalTo(self.contentTopView.mas_bottom);
        make.left.equalTo(self.scrollView);
    }];
    
    /******************************************************/
    
    // 自动scrollview高度
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentBottomView.mas_bottom).with.offset(55);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
