//
//  XWRedPakModel.m
//  XueWen
//
//  Created by aaron on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWRedPakModel.h"

@implementation XWRedPakListModel

@end

@implementation XWRedPakModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [XWRedPakListModel class]};
}

//获取红包
+ (void)createRedBackIsNum:(BOOL)isNum
                   Success:(void(^)(XWRedPakModel * cmodel))success
                   failure:(void(^)(NSString *error))failure {
    
    NSString * urlStr = isNum ? RedBackBonusesNum : RedBackBonuses;
    [XWHttpBaseModel BGET:BASE_URL(urlStr) parameters:nil extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        XWRedPakModel * xwModel = [XWRedPakModel modelWithJSON:model.data];
        !success?:success(xwModel);
        
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}

+ (void)redBackListSuccess:(void(^)(XWRedPakModel * cmodel))success
                   failure:(void(^)(NSString *error))failure {
    
    [XWHttpBaseModel BGET:BASE_URL(RedBackBonusesList) parameters:nil extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        XWRedPakModel * xwModel = [XWRedPakModel modelWithJSON:model.data];
        !success?:success(xwModel);
        
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}

@end
