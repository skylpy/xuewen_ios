//
//  XWTestEduModel.m
//  XueWen
//
//  Created by aaron on 2018/10/18.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWTestEduModel.h"
#import "XWHttpBaseModel.h"

@implementation XWTestModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [XWTestEduModel class]};
}

@end

@implementation XWTestEduModel

/**
 *注释
 *YYModel 映射替换字段
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc" : @"description",@"mid" : @"id"};
}

//获取测一测试题列表
+ (void)getJobTestListSuccess:(void(^)(NSArray * list,XWTestModel * model))success
                      failure:(void(^)(NSString *error))failure {
    
    [XWHttpBaseModel BGET:BASE_URL(GetJobTest) parameters:nil extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        XWTestModel * tmodel = [XWTestModel modelWithJSON:model.data];
        
        NSMutableArray * array = [NSMutableArray array];
        [array addObjectsFromArray:tmodel.data];
        !success?:success(array,tmodel);
        
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}

@end
