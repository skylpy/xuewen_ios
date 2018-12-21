//
//  XWSuperGroupModel.m
//  XueWen
//
//  Created by aaron on 2018/10/19.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWSuperGroupModel.h"
#import "XWHttpBaseModel.h"

@implementation XWSuperGroupModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [XWSuperGModel class]};
}


@end

@implementation XWSuperGModel

/**
 *注释
 *YYModel 映射替换字段
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"mid" : @"id"};
}

//超级组织
+ (void)getSuperGroupListPage:(NSInteger)page
                      Success:(nonnull void (^)(XWSuperGroupModel * _Nonnull))success
                      failure:(void(^)(NSString *error))failure {
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(20) forKey:@"size"];
    [dic setValue:@(page) forKey:@"page"];
    
    [XWHttpBaseModel BGET:BASE_URL(SuperGroup) parameters:dic extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        XWSuperGroupModel * tmodel = [XWSuperGroupModel modelWithJSON:model.data];
        !success?:success(tmodel);
        
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}


@end
