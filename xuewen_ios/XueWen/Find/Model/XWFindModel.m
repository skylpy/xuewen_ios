//
//  XWFindModel.m
//  XueWen
//
//  Created by aaron on 2018/10/18.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWFindModel.h"
#import "XWHttpBaseModel.h"

@implementation XWFindListModel

/**
 *注释
 *YYModel 映射替换字段
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"coName" : @"co_name",
             @"mid" : @"id",
             @"coIntroduction" : @"co_introduction",
             @"logoUrl" : @"logo_url",
             @"logoUrlAll" : @"logo_url_all",
             @"pictureUrl" : @"picture_url",
             @"pictureUrlAll" : @"picture_url_all"
             };
}

@end


static NSInteger page = 1;

@implementation XWFindModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [XWFindListModel class]};
}
//获取发现列表
+ (void)getDiscoveryWithIsFirstLoad:(BOOL)isFirst
                    Success:(void (^)(NSMutableArray * _Nonnull, BOOL))success
                    failure:(void(^)(NSString *error))failure {
    if (isFirst) {
        page = 1;
    }else{
        page ++;
    }
    ParmDict
    [dict setValue:@(10) forKey:@"size"];
    [dict setValue:@(page) forKey:@"page"];
    [XWHttpBaseModel BGET:BASE_URL(Discovery) parameters:dict extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        XWFindModel * tmodel = [XWFindModel modelWithJSON:model.data];
        
        !success?:success([tmodel.data mutableCopy], tmodel.last_page >= tmodel.current_page);
        
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}

@end

