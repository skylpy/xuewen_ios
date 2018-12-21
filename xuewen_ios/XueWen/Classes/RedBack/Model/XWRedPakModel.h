//
//  XWRedPakModel.h
//  XueWen
//
//  Created by aaron on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWHttpBaseModel.h"

//定义枚举类型
typedef enum {
    AppearType  = 1000,
    DisappearType = 1001
    
} RedBackType;

@interface XWRedPakListModel : NSObject

@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * user_id;
@property (nonatomic,copy) NSString * user_pid;
@property (nonatomic,copy) NSString * b_id;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * create_time;
@property (nonatomic,copy) NSString * picture;
@property (nonatomic,copy) NSString * nick_name;
@property (nonatomic,copy) NSString * sex;
@property (nonatomic,copy) NSString * picture_all;

@end

@interface XWRedPakModel : NSObject

@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * opportunity;
@property (nonatomic,copy) NSString * state;
@property (nonatomic,copy) NSString * url;
//红包列表
@property (nonatomic,copy) NSString * total;
@property (nonatomic,copy) NSString * per_page;
@property (nonatomic,copy) NSString * current_page;
@property (nonatomic,copy) NSString * last_page;
@property (nonatomic,strong) NSArray <XWRedPakListModel *> * data;


//获取红包 和 红包次数
+ (void)createRedBackIsNum:(BOOL)isNum
                   Success:(void(^)(XWRedPakModel * cmodel))success
                   failure:(void(^)(NSString *error))failure;

+ (void)redBackListSuccess:(void(^)(XWRedPakModel * cmodel))success
                   failure:(void(^)(NSString *error))failure;
@end


