//
//  XWCerViewController.m
//  XueWen
//
//  Created by aaron on 2018/8/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCerViewController.h"
#import "XWShareView.h"
#import "WXApi.h"

@interface XWCerViewController () <XWShareViewDelegate>

@end

@implementation XWCerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"证书";
    self.nameLabel.text = [XWInstance shareInstance].userInfo.nick_name;
    
    //从考试结果跳过执行
    if (self.model) {
        self.causeLabel.text = [NSString stringWithFormat:@"在学问APP%@岗位胜任力认证考试中，",self.model.achievement_name];
        self.cerNumberLabel.text = [NSString stringWithFormat:@"证书编号：%@",self.model.certificate_number];
        self.timeLabel.text = [NSString stringWithFormat:@"日期：%@",[NSDate dateFormTimestamp:self.model.create_time withFormat:@"yyyy-MM-dd"]];
        self.occupationLabel.text = [NSString stringWithFormat:@" 成绩优秀，被评为%@。",self.model.jobs];
    }
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - kNaviBarH;;
}

- (void)setLmodel:(XWCerListModel *)lmodel {
    _lmodel = lmodel;
    
    self.causeLabel.text = [NSString stringWithFormat:@"在学问APP%@岗位胜任力认证考试中，",lmodel.achievement_name];
    self.cerNumberLabel.text = [NSString stringWithFormat:@"证书编号：%@",lmodel.certificate_number];
    self.timeLabel.text = [NSString stringWithFormat:@"日期：%@",lmodel.create_time];
    self.occupationLabel.text = [NSString stringWithFormat:@" 成绩优秀，被评为%@。",lmodel.job];
}

/** 分享事件*/
- (void)shareBtnClick{
    
    XWShareView *shareView = [[XWShareView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    shareView.delegate = self;
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
