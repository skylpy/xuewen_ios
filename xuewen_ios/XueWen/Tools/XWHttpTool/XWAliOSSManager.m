//
//  XWAliOSSManager.m
//  XueWen
//
//  Created by Karron Su on 2018/8/7.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWAliOSSManager.h"


@interface XWAliOSSManager ()

@property(assign,nonatomic) NSInteger totalCount ;

@property(assign,nonatomic) NSInteger compeleteIndex ;

@property(strong,nonatomic) NSMutableArray * imageNameArr ;

@end
@implementation XWAliOSSManager

+ (instancetype)sharedInstance {
    static XWAliOSSManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [XWAliOSSManager new];
    });
    return instance;
}


/** 异步上传图片*/
- (void)asyncUploadMultiImages:(NSArray *)images CompeleteBlock:(CompeleteBlock)compelete ErrowBlock:(ErrorBlock)error{
    
    self.imageNameArr = [NSMutableArray array];
    
    self.compelete = compelete;
    self.error  = error;
    _totalCount = images.count;
    
    if (images.count == 0) {
        !compelete ? : compelete(nil);
        return;
    }
    [MBProgressHUD showActivityMessageInWindow:@"上传中"];
    [self multithreadingUploadingWithImages:images];
    
}

// 多线程上传
- (void)multithreadingUploadingWithImages:(NSArray *)images{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSMutableArray * ops = [NSMutableArray array];
    
    for (int i = 0 ; i < images.count ; i++) {
        UIImage * image = [images objectAtIndex:i];
        NSData * imageData = [self compressImageQuality:image toByte:0.2];
        NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
            
            [self uploadObjectAsyncWithDate:imageData WithIndex:i];
        }];
        
        [ops addObject:op];
    }
    
    [queue addOperations:ops waitUntilFinished:YES];
}

- (void)uploadObjectAsyncWithDate:(NSData *)data WithIndex:(int )index{
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName = @"xuewenweb-oss";
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy/MM/dd";
    
    put.objectKey = [NSString stringWithFormat:@"uploads/%@/%@.jpg", [formatter stringFromDate:date],getCurrentTime(13)];
    put.uploadingData = data; // 直接上传NSData
    OSSTask * putTask = [self.client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            // 回到主线程
            [self performSelectorOnMainThread:@selector(uploadOSSCompeleteWithObjectKey:) withObject:put.objectKey waitUntilDone:NO];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:@"上传失败"];
        }
        return nil;
    }];
}

- (void)uploadOSSCompeleteWithObjectKey:(NSString *)objectKey {
    
    _compeleteIndex ++;
    NSDictionary * dict = [NSDictionary dictionaryWithObject:objectKey forKey:@"Img"];
    [self.imageNameArr addObject:dict];
    
    if (_compeleteIndex == _totalCount) {
        
        if (self.compelete) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            _compeleteIndex = 0;
            self.compelete(self.imageNameArr);
        }
    }
    
}

- (NSData *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}

@end
