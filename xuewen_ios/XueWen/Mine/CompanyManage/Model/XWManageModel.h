//
//  XWManageModel.h
//  XueWen
//
//  Created by aaron on 2018/12/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWManageModel : NSObject

@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * imageStr;
@property (nonatomic,strong) NSString * controller;

+ (NSArray *)shareManage;
+ (NSArray *)shareManageBack;

@end

NS_ASSUME_NONNULL_END
