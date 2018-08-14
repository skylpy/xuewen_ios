//
//  XWAliOSSManager.h
//  XueWen
//
//  Created by Karron Su on 2018/8/7.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/OSSService.h>


typedef void(^CompeleteBlock)(NSArray * nameArray);
typedef void(^ErrorBlock)(NSString * errrInfo);

@interface XWAliOSSManager : NSObject

+ (instancetype)sharedInstance;

/* 完成回调 */
@property(copy,nonatomic) CompeleteBlock  compelete ;

/* 失败回调 */
@property(copy,nonatomic) ErrorBlock error ;
@property (nonatomic, strong) OSSClient * client;

/** 异步上传图片*/
- (void)asyncUploadMultiImages:(NSArray *)images CompeleteBlock:(CompeleteBlock) compelete ErrowBlock:(ErrorBlock ) error;

@end
