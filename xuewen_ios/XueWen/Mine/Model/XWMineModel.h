//
//  XWMineModel.h
//  XueWen
//
//  Created by aaron on 2018/11/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWMineModel : NSObject

@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * subtitle;
@property (nonatomic,copy) NSString * imageStr;
@property (nonatomic,copy) NSString * controller;


+ (NSArray *)sharemineHide:(NSInteger)hide;


//我的页面控制
+ (void)mineVersion:(NSString *)version
            success:(void(^)(NSInteger hide))success
            failure:(void(^)(NSString *error))failure ;

@end


NS_ASSUME_NONNULL_END
