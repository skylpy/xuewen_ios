//
//  XWMedalViewController.m
//  XueWen
//
//  Created by aaron on 2018/8/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWMedalViewController.h"
#import "XWShareView.h"
#import "XWQRCodeView.h"
#import "WXApi.h"

@interface XWMedalViewController ()<XWShareViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (strong,nonatomic) XWShareView *shareView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cerLayoutConstraintY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cerLayoutConstraintH;

//头像
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
//姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation XWMedalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *defaultImg = [[UIImage alloc] init];
    if ([[XWInstance shareInstance].userInfo.sex isEqualToString:@"0"]){
        defaultImg = DefaultImageGril;
    }else{
        defaultImg = DefaultImageBoy;
    }
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[XWInstance shareInstance].userInfo.picture] placeholderImage:defaultImg];
    self.headerImage.layer.cornerRadius = 11;
    self.headerImage.clipsToBounds = YES;
    self.nameLabel.text = [NSString stringWithFormat:@"%@恭喜你获得勋章",[XWInstance shareInstance].userInfo.nick_name];
    
    @weakify(self)
    [[self.shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)

        [self shareBtnClick];
    }];
    
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - kNaviBarH;;
}

- (void)setModel:(XWCerListModel *)model {
    _model= model;
    self.codeView.rqCodeImage.image = [UIImage QRImageWithString:model.nosignShare_url];
    if ([model.pass_type isEqualToString:@"0"]||[model.pass_type isEqualToString:@"1"]) {
        self.shareButton.hidden = YES;
        self.nameLabel.text = @"革命尚未成功，同志仍需努力！";
        self.headerImage.hidden = YES;
    }else {
        self.shareButton.hidden = NO;
        self.shareButton.backgroundColor = Color(@"#FF9900");
    }
}


- (XWQRCodeView *)codeView {
    
    if (!_codeView) {
        _codeView = [XWQRCodeView shareCodeView];
        _codeView.hidden = YES;
    }
    return _codeView;
}

/** 分享事件*/
- (void)shareBtnClick{
    
    XWShareView *shareView = [[XWShareView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    shareView.delegate = self;
    [kMainWindow addSubview:shareView];
    @weakify(self)
    [shareView setCodeClick:^{
        @strongify(self)
        self.cerLayoutConstraintH.constant = 0;
        self.cerLayoutConstraintY.constant = 0;
        self.codeView.hidden = YES;
        self.shareButton.hidden = NO;
    }];
    self.cerLayoutConstraintH.constant = 15;
    self.cerLayoutConstraintY.constant = 20;
    self.shareButton.hidden = YES;
    self.codeView.hidden = NO;
    [self.view addSubview:self.codeView];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(100);
    }];
}

#pragma mark - XWShareViewDelegate

- (void)didSelectShareItemAtIndex:(NSInteger)index{
    
    UIImage * image = [UIImage imageViewView:self.view];
    switch (index) {
        case 0:  // 生成海报
        {
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
            break;
        case 1: // 分享到微信
        {

            //1.创建多媒体消息结构体
            WXMediaMessage *mediaMsg = [WXMediaMessage message];
            //2.创建多媒体消息中包含的图片数据对象
            WXImageObject *imgObj = [WXImageObject object];
            //图片真实数据
            imgObj.imageData =  UIImageJPEGRepresentation(image,1);//[UIImage compressImage:image toByte:32000];
            //多媒体数据对象
            mediaMsg.mediaObject = imgObj;
            //3.创建发送消息至微信终端程序的消息结构体
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            //多媒体消息的内容
            req.message = mediaMsg;
            //指定为发送多媒体消息（不能同时发送文本和多媒体消息，两者只能选其一）
            req.bText = NO;
            req.scene = 0;
            //指定发送到会话(聊天界面)
            req.scene = WXSceneSession;
            //发送请求到微信,等待微信返回onResp
            [WXApi sendReq:req];
    
        }
            break;
        case 2: // 分享到朋友圈
        {
            //1.创建多媒体消息结构体
            WXMediaMessage *mediaMsg = [WXMediaMessage message];
            //2.创建多媒体消息中包含的图片数据对象
            WXImageObject *imgObj = [WXImageObject object];
            //图片真实数据
            imgObj.imageData =  UIImageJPEGRepresentation(image,1);//[UIImage compressImage:image toByte:32000];
            //多媒体数据对象
            mediaMsg.mediaObject = imgObj;
            //3.创建发送消息至微信终端程序的消息结构体
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            //多媒体消息的内容
            req.message = mediaMsg;
            //指定为发送多媒体消息（不能同时发送文本和多媒体消息，两者只能选其一）
            req.bText = NO;
            //指定发送到会话(朋友圈)
            req.scene = WXSceneTimeline;
            //发送请求到微信,等待微信返回onResp
            [WXApi sendReq:req];
        }
            break;
        default:
            break;
    }
    
}

//保存完成后调用的方法
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        
        NSLog(@"保存图片出错%@", error.localizedDescription);
        
    } else {
        NSLog(@"保存图片成功");
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
