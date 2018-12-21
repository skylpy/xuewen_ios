//
//  XWCertificateModel.m
//  XueWen
//
//  Created by aaron on 2018/8/18.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCertificateModel.h"

@implementation XWCerListModel

//+ (NSDictionary *)replacedKeyFromPropertyName {
//
//    return @{@"uid" : @"id",
//             @"achievementName" : @"achievement_name",
//             @"pid" : @"pid",
//             @"lock" : @"lock",
//             @"testId" : @"test_id",
//             @"passType" : @"pass_type",
//             @"showPictureAll" : @"show_picture_all",
//             @"createTime" : @"create_time",
//             @"Percentage" : @"Percentage"
//             };
//}
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    
//    return @{@"uid" : @"id",
//             @"achievementName" : @"achievement_name",
//             @"pid" : @"pid",
//             @"lock" : @"lock",
//             @"testId" : @"test_id",
//             @"passType" : @"pass_type",
//             @"showPictureAll" : @"show_picture_all",
//             @"createTime" : @"create_time",
//             @"Percentage" : @"Percentage"
//             };
//}

@end

@implementation XWCertificateModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [XWCerDataModel class]};
}

//生成证书
+ (void)createcertificatetestId:(NSString *)testId
                       withName:(NSString *)cuname
                        success:(void(^)(XWCertificateModel * cmodel))success
                        failure:(void(^)(NSString *error))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@/%@",BASE_URL(Achievements),testId];

    [XWHttpBaseModel BGET:URLString parameters:nil extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        XWCertificateModel * xwModel = [XWCertificateModel modelWithJSON:model.data];
        !success?:success(xwModel);
        
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}
//证书列表
+ (void)certificateThematicListID:(NSString *)cuid
                         withName:(NSString *)cuname
                          success:(void(^)(NSArray * list))success
                          failure:(void(^)(NSString *error))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@/%@",BASE_URL(AchievementThematic),cuid];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:cuname forKey:@"job"];
    
    [XWHttpBaseModel BGET:URLString parameters:dic extra:kShowProgress success:^(XWHttpBaseModel *model) {
        
        NSArray * modelList = [NSArray modelArrayWithClass:[XWCerListModel class] json:model.data];
        !success?:success(modelList);
        
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}


//我的证书
+ (void)myCertificateThematicList:(NSInteger)thematic
                             Page:(NSInteger)page
                          success:(void(^)(XWCertificateModel * cmodel))success
                          failure:(void(^)(NSString *error))failure {
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(thematic) forKey:@"thematicList"];
    
    [XWHttpBaseModel BGET:BASE_URL(AchievementThematic) parameters:dic extra:kShowProgress success:^(XWHttpBaseModel *model) {

        XWCertificateModel * xwModel = [XWCertificateModel modelWithJSON:model.data];
        !success?:success(xwModel);
        
    } failure:^(NSString *error) {
        
        !failure?:failure(error);
    }];
}

@end

@implementation XWCerDataModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"uid" : @"id",
             @"children" : [XWCerChildrenModel class]};
}



@end

@implementation XWCerChildrenModel

//+ (NSDictionary *)replacedKeyFromPropertyName {
//    
//    return @{@"uid" : @"id"};
//}

@end
