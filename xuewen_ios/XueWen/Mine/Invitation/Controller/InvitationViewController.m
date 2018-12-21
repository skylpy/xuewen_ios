//
//  InvitationViewController.m
//  XueWen
//
//  Created by ShaJin on 2018/3/8.
//  Copyright © 2018年 ShaJin. All rights reserved.
//
// 邀请界面
#import "InvitationViewController.h"
#import "InvitationDetailViewController.h"
#import "InvitationShareView.h"
#import "InvitationViewModel.h"
#import "WXApi.h"
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABRecord.h>
#import "ContactViewController.h"

@interface InvitationViewController ()<InvitationShareViewDelegate>

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIImageView *QRView;
@property (nonatomic, strong) UIImage *saveImage;
@property (nonatomic, strong) UIImage *QRImage;
@property (nonatomic, strong) InvitationShareView *shareView;
@property (nonatomic, strong) InvitationViewModel *viewModel;
@property (nonatomic, strong) BaseAlertView *alertView;
@property (nonatomic, strong) NSString *invitationURL;
@property (nonatomic, strong) UIButton *invitationButton;

@end

@implementation InvitationViewController
#pragma mark- CustomMethod
- (void)detailAction:(UIButton *)sender{
    NSLog(@"邀请规则");
    [self.alertView show];
}

- (void)didSelectItemAtIndex:(NSInteger)index{
    UIImage *saveImage = [self.saveImage addImageLogo:self.QRImage frame:CGRectMake(50, 1001, 243, 243)];
    switch (index) {
        case 0:{
            // 保存到本地
            [self saveImageToPhotos:saveImage];
            [Analytics event:EventSaveQRCode label:nil];
        }break;
        case 1:
        {
            /** 安装了微信则显示的微信分享 做微信分享的操作*/
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                
                WXWebpageObject *pageObj = [WXWebpageObject object];
                pageObj.webpageUrl = self.invitationURL;
//                WXImageObject *imgObj = [WXImageObject object];
//                imgObj.imageData = UIImagePNGRepresentation(saveImage);
                // 消息对象
                WXMediaMessage *message = [WXMediaMessage message];
                message.mediaObject = pageObj;
                message.title = @"注册即送百元奖学金";
                message.description = @"高效工作，快乐生活，尽在“学问”APP";
                message.thumbData = UIImagePNGRepresentation(LoadImage(@"AppIcon"));
                
                // 请求对象
                SendMessageToWXReq *req = [SendMessageToWXReq new];
                req.scene = index == 1 ? 0 : 1; // 朋友圈场景
                req.message = message;
                req.bText = NO;
                [WXApi sendReq:req];
                [self.shareView dismiss];
            }else{  /** 没有安装微信则做短信分享的操作*/
                [self shareMeesage];
            }
        }
            break;
        case 2:{
            // 分享到朋友圈

            // 多媒体对象
//            WXImageObject *imageObj = [WXImageObject object];
//            imageObj.imageData = UIImagePNGRepresentation(saveImage);
            WXWebpageObject *pageObj = [WXWebpageObject object];
            pageObj.webpageUrl = self.invitationURL;
            // 消息对象
            WXMediaMessage *message = [WXMediaMessage message];
            message.mediaObject = pageObj;
            message.title = @"注册即送百元奖学金";
            message.description = @"高效工作，快乐生活，尽在“学问”APP";
            message.thumbData = UIImagePNGRepresentation(LoadImage(@"AppIcon"));
            // 请求对象
            SendMessageToWXReq *req = [SendMessageToWXReq new];
            req.scene = index == 1 ? 0 : 1; // 朋友圈场景
            req.message = message;
            req.bText = NO;
            [WXApi sendReq:req];
            [self.shareView dismiss];
        }break;
        case 3:
        {
            //TODO: - 做短信分享的操作
            [self shareMeesage];
        }
            break;
        default:
            break;
    }
}

/** 短信分享*/
- (void)shareMeesage{
//    NSLog(@"点击了短信分享");
    if (IOS_VERSION_9_OR_LATER) {
        CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (authStatus == CNAuthorizationStatusNotDetermined) {
            CNContactStore *constore = [[CNContactStore alloc] init];
            XWWeakSelf
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [constore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {
                        // 授权成功
                        NSLog(@"授权成功");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf pushContactVC];
                        });
                        
                    } else {
                        NSLog(@"授权失败");
                    }
                }];
            });
            
        }else{
            NSLog(@"已经过授权");
            [self pushContactVC];
        }
    }
    [self.shareView dismiss];
}

/** 授权成功/或已授权 进入下一界面*/
- (void)pushContactVC{
    ContactViewController *vc = [ContactViewController new];
    vc.invitationURL = self.invitationURL;
    [self.navigationController pushViewController:vc animated:YES];
}

/** 保存图片 */
- (void)saveImageToPhotos:(UIImage *)savedImage{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)image:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    WeakSelf;
    [XWPopupWindow popupWindowsWithTitle:@"提示" message:(error != NULL) ? @"图片保存失败" : @"图片保存成功" buttonTitle:@"确定" buttonBlock:^{
        [weakSelf.shareView dismiss];
    }];
}

- (void)invitationDetailListAction:(UIButton *)sender{
    [self.navigationController pushViewController:[InvitationDetailViewController new] animated:YES];
}

- (void)shareAction:(UIButton *)sender{
    if (self.QRImage && self.saveImage) {
        self.shareView = [InvitationShareView shareViewWithDelegate:self];
        [self.shareView show];
        [Analytics event:EventClickInvation label:nil];
    }else{
        [XWPopupWindow popupWindowsWithTitle:@"错误" message:@"未能获取到正确的二维码" buttonTitle:@"确定" buttonBlock:nil];
    }
}

#pragma mark - UI
- (void)initUI{
    self.title = @"邀请有礼";
    UIButton *button = [self setRightItemWithTitle:@"邀请明细" action:@selector(invitationDetailListAction:)];
    [button setTitleColor:DefaultTitleAColor forState:UIControlStateNormal];
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.shareButton];
    [self.view addSubview:self.QRView];
    [self.view addSubview:self.invitationButton];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-kBottomH);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(46);
        make.bottom.mas_equalTo(self.view).offset(-kBottomH);
    }];
    
    CGFloat height;
    CGFloat width;
    if (kWidth == 320) {
        height = 90;
        width = 90;
    }else if (kWidth == 375){
        height = 130;
        width = 110;
    }else{
        height = 150;
        width = 130;
    }
    
    [self.QRView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, width));
        make.centerX.mas_equalTo(self.view).multipliedBy(0.5);
        make.bottom.mas_equalTo(self.view).offset(-kBottomH-42);
    }];
    
    [self.invitationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.shareButton.mas_top).offset(-height);
    }];
    
}

- (void)loadData{
    WeakSelf;
    [self.viewModel getInvitationQRViewWithCompleteBlock:^(UIImage *QRImage, NSString *url) {
        weakSelf.QRImage = QRImage;
        weakSelf.invitationURL = url;
    }];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kNaviBarH - kBottomH - 100;
}

#pragma mark- Setter
- (void)setQRImage:(UIImage *)QRImage{
    _QRImage = QRImage;
    _QRView.image = QRImage;
}

#pragma mark- Getter
- (InvitationViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [InvitationViewModel new];
    }
    return _viewModel;
}

- (UIImageView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithImage:LoadImage(@"picture")];
    }
    return _backgroundView;
}

- (UIButton *)shareButton{
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:0];
        [_shareButton setTitleColor:Color(@"#192041") forState:UIControlStateNormal];
        [_shareButton setTitle:@"立即邀请好友" forState:UIControlStateNormal];
        _shareButton.backgroundColor = [UIColor whiteColor];
        [_shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (UIImageView *)QRView{
    if (!_QRView) {
        _QRView = [UIImageView new];
    }
    return _QRView;
}

- (UIImage *)saveImage{
    if (!_saveImage) {
        _saveImage = LoadImage(@"Invitation_save.png");
    }
    return _saveImage;
}

- (UIButton *)invitationButton{
    if (!_invitationButton) {
        _invitationButton = [UIButton buttonWithType:0];
        NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"邀请规则"];
        [tncString addAttribute:NSUnderlineStyleAttributeName
                          value:@(NSUnderlineStyleSingle)
                          range:(NSRange){0,[tncString length]}];
        //此时如果设置字体颜色要这样
        [tncString addAttribute:NSForegroundColorAttributeName value:Color(@"#D8AE49")  range:NSMakeRange(0,[tncString length])];
        [tncString addAttribute:NSFontAttributeName value:[UIFont fontWithName:kRegFont size:10] range:(NSRange){0,[tncString length]}];
        //设置下划线颜色...
        [tncString addAttribute:NSUnderlineColorAttributeName value:Color(@"#D8AE49") range:(NSRange){0,[tncString length]}];
        [_invitationButton setAttributedTitle:tncString forState:UIControlStateNormal];
        [_invitationButton addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _invitationButton;
}

- (BaseAlertView *)alertView{
    _alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake((kWidth - 275) / 2.0 , (kHeight - 372) / 2.0, 275, 372)];
    UILabel *titleLable = [UILabel labelWithTextColor:DefaultTitleAColor size:16];
    titleLable.text = @"邀请规则";
    titleLable.textAlignment = 1;

    UILabel *contentLabel = [UILabel labelWithTextColor:DefaultTitleBColor size:14];
    contentLabel.numberOfLines = 0;
    contentLabel.text = @"1.    邀请对象仅限于未注册学问网的新用户；\n2.    新用户注册成功后，邀请人即可获得一张30元奖学金，购买课程可用，有效期90天；\n3.    在参与活动过程中，如发现违规行为（违规行为包括但不限于恶意批量注册、无效手机、虚假信息等）学问网将封停账号，并撤销获得的相关赠品。";
    UIButton *button = [UIButton buttonWithType:0];
    button.backgroundColor = Color(@"#D8AE49");
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    ViewRadius(button, 18);
    [button addTarget:_alertView action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:titleLable];
    [_alertView addSubview:contentLabel];
    [_alertView addSubview:button];

    titleLable.sd_layout.topSpaceToView(_alertView, 34).leftSpaceToView(_alertView, 0).rightSpaceToView(_alertView, 0).heightIs(16);
    button.sd_layout.centerXEqualToView(_alertView).bottomSpaceToView(_alertView, 25).widthIs(195).heightIs(36);
    contentLabel.sd_layout.topSpaceToView(titleLable, 19).leftSpaceToView(_alertView, 20).rightSpaceToView(_alertView, 20).bottomSpaceToView(button, 19);

    return _alertView;
}

#pragma mark- LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"didReceiveMemoryWarning");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark- 生成二维码
- (UIImage *)getORImageWithURL:(NSString *)url{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    return [UIImage imageWithCIImage:outPutImage];
}

@end
