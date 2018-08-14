//
//  InvitationViewModel.m
//  XueWen
//
//  Created by ShaJin on 2018/3/15.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "InvitationViewModel.h"
@interface InvitationViewModel()

@property (nonatomic, copy) void (^CompleteBlock)(UIImage *QRImage);

@end
@implementation InvitationViewModel
/** 获取邀请二维码 */
- (void)getInvitationQRViewWithCompleteBlock:(void (^)(UIImage *QRImage,NSString *url))completeBlock{
    /** 拼接文件路径 */
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [XWInstance shareInstance].userInfo.oid;
    NSString *documentsPath = [NSString stringWithFormat:@"%@/QRImage",path[0]];
    NSString *namePath = [NSString stringWithFormat:@"%@/%@",documentsPath,fileName];
    // 判断文件夹是否存在
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:documentsPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ){
        [fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 判断图片是否存在
    UIImage *image = [UIImage imageWithContentsOfFile:namePath];
    // 图片不存在则获取邀请链接并生成二维码
    [XWNetworking getInvitationURLWithcompletionBlock:^(NSString *url) {
        [XWInstance shareInstance].invitationURL = url;
        UIImage *QRImage = [UIImage QRImageWithString:url];
        // 图片保存到本地
        NSData *data = UIImagePNGRepresentation(QRImage);
        [data writeToFile:namePath atomically:YES];
        if (completeBlock) {
            completeBlock(QRImage,url);
        }
    }];
}

@end
