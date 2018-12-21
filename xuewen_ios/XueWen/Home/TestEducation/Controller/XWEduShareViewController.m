//
//  XWEduShareViewController.m
//  XueWen
//
//  Created by aaron on 2018/10/19.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWEduShareViewController.h"
#import "XWShareView.h"
#import "XWGDShareView.h"
#import "WXApi.h"

@interface XWEduShareViewController ()<XWGDShareViewDelegate>{
    
    XWGDShareView *shareView ;
}
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraintCenter;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobsLabel;
@property (weak, nonatomic) IBOutlet UILabel *sorceLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *xwscrollview;

@end

@implementation XWEduShareViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    self.LayoutConstraintCenter.constant =  40;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    
    [shareView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享给好友";
    
    [self setDrawUI];
}

- (void)setDrawUI {
    
    [self.headerImage setImageWithURL:[NSURL URLWithString:[XWInstance shareInstance].userInfo.picture] placeholder:DefaultImage];
    self.headerImage.layer.cornerRadius = 50;
    self.headerImage.clipsToBounds = YES;
    self.nameLabel.text = [XWInstance shareInstance].userInfo.name;
    self.sorceLabel.attributedText = [NSMutableAttributedString setupAttributeString:[NSString stringWithFormat:@"%@ 分",self.score] rangeText:@"分" textFont:[UIFont fontWithName:kRegFont size:15] textColor:Color(@"#C88F22")];
    self.jobsLabel.attributedText = [NSMutableAttributedString setupAttributeString:[NSString stringWithFormat:@"在 %@ 中，获得了",self.jobs] rangeText:self.jobs textFont:[UIFont fontWithName:kRegFont size:18] textColor:Color(@"#C88F22")];
    
    [self shareBtnClick];
    
}

/** 分享事件*/
- (void)shareBtnClick{
    
    shareView = [[XWGDShareView alloc] initWithFrame:CGRectMake(0,kHeight-148, kWidth, 148)];
    shareView.delegate = self;
    shareView.backgroundColor = [UIColor redColor];
    [kMainWindow addSubview:shareView];
    
    [shareView setCodeClick:^{
        
        
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
            
            [mediaMsg setThumbImage:[[UIImage alloc] initWithData:[UIImage compressImage:image toByte:32000]]];
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
        [MBProgressHUD showSuccessMessage:@"保存成功"];
    }
    
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
